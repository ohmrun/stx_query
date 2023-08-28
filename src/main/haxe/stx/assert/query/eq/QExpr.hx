package stx.assert.query.eq;

import stx.query.QExpr in TQExpr;

class QExpr<T> extends EqCls<TQExpr<T>>{
  final inner : Eq<T>;
  public function new(inner:Eq<T>){
    this.inner = inner;
  }
  public function comply(lhs:TQExpr<T>,rhs:TQExpr<T>):Equaled{
    return switch([lhs,rhs]){
      // case [QEVal(l),QEVal(r)]               : 
      //   inner.comply(l,r);
      case [QEAnd(lI,rI),QEAnd(lII,rII)]     : 
        comply(lI,lII) && comply(rI,rII);
      case [QEOr(lI,rI),QEOr(lII,rII)]       : 
        comply(lI,lII) && comply(rI,rII);
      case [QENot(eI),QENot(eII)]            : 
        comply(eI,eII);
      case [QEIn(filterI,exprI,sub_exprsI),QEIn(filterII,exprII,sub_exprsII)] : 
        var eq = new stx.assert.query.eq.QFilter().comply(filterI,filterII);
        if(eq.is_ok()){
          eq = inner.comply(exprI,exprII);
        }
        if(eq.is_ok()){
          eq = new stx.assert.query.eq.QSubExpr(inner).comply(sub_exprsI,sub_exprsII);
        }
        eq;
      case [QEBinop(oI,lI,rI),QEBinop(oII,lII,rII)] :
        var eq = new stx.assert.query.eq.QBinop().comply(oI,oII);
        if(eq.is_ok()){
          eq = inner.comply(lI,lII);
        }
        if(eq.is_ok()){
          eq = inner.comply(rI,rII);
        }
        eq;
      case [QEUnop(opI,eI),QEUnop(opII,eII)]        :
        new stx.assert.query.eq.QUnop().comply(opI,opII);
      default : 
        Eq.EnumValueIndex().comply(lhs,rhs);
    }
  }
}
