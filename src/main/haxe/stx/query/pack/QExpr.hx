package stx.query.pack;

import stx.query.head.data.QExpr in QExprT;

abstract QExpr(QExprT) from QExprT to QExprT{
  public function toString(){
    function rec(v){
      return switch (v:QExpr) {
        case QEBlank                          : '_';
        case QEConst(c)                       : c.toString();
        case QEPos(NIndex(idx), e)            : '${rec(e)}[$idx]';
        case QEBinop(QBCheck(c), l, r)        : '${rec(l)} $c ${rec(r)}';
        case QELogic(l)                       : l.toStringWith(rec);
        case QEPos(NField(idx), e)            : '${rec(e)}.$idx';
        case QEUnop(c, e)                     : '$c${rec(e)}';
        case QEGroup(e)                       : '(${rec(e)})';
      }
    }
    return rec(this);
  }
  public function new(?self){
    this = self == null ? QEConst(QCSelf) : self;
  }
  @:op(!A) 
  function not():QExpr{
    return QEUnop(QUNot,this);
  }
  public function exists():QExpr{
    return QEUnop(QUExists,this);
  }
  @:op(A==A)
  function eq(that:QExpr):QExpr{
    return QEBinop(QBCheck(Compare(EQ)),this,that);
  }
  @:op(A!=A)
  function neq(that:QExpr):QExpr{
    return QEUnop(QUNot,QEBinop(QBCheck(Compare(EQ)),this,that));
  }
  @:op(A<A)
  function ltq(that:QExpr):QExpr{
    return QEBinop(QBCheck(Compare(LT)),this,that);
  }
  @:op(A<=A)
  function lteq(that:QExpr):QExpr{
    return QEBinop(QBCheck(Compare(LTEQ)),this,that);
  }
  @:op(A>A)
  function gt(that:QExpr):QExpr{
    return QEBinop(QBCheck(Compare(GT)),this,that);
  }
  @:op(A=>A)
  function gteq(that:QExpr):QExpr{
    return QEBinop(QBCheck(Compare(GTEQ)),this,that);
  }
  @:from static public function fromVar(v:Variable):QExpr{
    return QEConst(QCVar(v));
  }
  @:from static public function fromPrim(p:Primitive):QExpr{
    return QEConst(QCPrim(p));
  }
  @:from static public function fromInt(i:Int):QExpr{
    return fromPrim(PInt(i));
  }
  public function at(p:Path){
    return p.at(this);
  }
  @:op(A||A)
  function or(that:QExpr):QExpr{
    return QELogic(LDisj(LInj(this),LInj(that)));
  }
  @:op(A&&A)
  function and(that:QExpr):QExpr{
    return QELogic(LConj(LInj(this),LInj(that)));
  }
}