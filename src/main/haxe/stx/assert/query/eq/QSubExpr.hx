package stx.assert.query.eq;

import stx.query.QSubExpr in TQSubExpr;

class QSubExpr<T> extends EqCls<TQSubExpr<T>>{
  final inner : Eq<T>;
  public function new(inner:Eq<T>){
    this.inner = inner;
  }
  public function comply(lhs:TQSubExpr<T>,rhs:TQSubExpr<T>):Equaled{
    final expr_eq = new stx.assert.query.eq.QExpr(inner);
    return switch([lhs,rhs]){
      case [QSAnd(lI,rI),QSAnd(lII,rII)]     : expr_eq.comply(lI,lII) && expr_eq.comply(rI,rII);
      case [QSOr(lI,rI),QSOr(lII,rII)]       : expr_eq.comply(lI,lII) && expr_eq.comply(rI,rII);
      case [QSNot(eI),QSNot(eII)]            : expr_eq.comply(eI,eII);
      case [QSBinop(oI,lI),QSBinop(oII,lII)] :
        var eq = new stx.assert.query.eq.QBinop().comply(oI,oII);
        if(eq.is_ok()){
          eq = inner.comply(lI,lII);
        }
        eq;
      case [QSOf(keyI,restI),QSOf(keyII,restII)] : 
        var eq = Eq.String().comply(keyI,keyII);
        if(eq.is_ok()){
          eq = expr_eq.comply(restI,restII);
        }
        eq;
      case [QSIn(filterI,sub_exprsI),QSIn(filterII,sub_exprsII)] : 
        var eq = new stx.assert.query.eq.QFilter().comply(filterI,filterII);
        if(eq.is_ok()){
          eq = new stx.assert.query.eq.QSubExpr(inner).comply(sub_exprsI,sub_exprsII);
        }
        eq;
      case [QSUnop(opI),QSUnop(opII)]        :
        new stx.assert.query.eq.QUnop().comply(opI,opII);
      default : Eq.EnumValueIndex().comply(lhs,rhs);
    }
  }
}