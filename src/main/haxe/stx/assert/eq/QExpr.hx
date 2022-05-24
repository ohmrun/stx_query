package stx.assert.eq;

import stx.query.QExpr in TQExpr;

class QExpr<T> extends EqCls<TQExpr<T>>{
  final inner : Eq<T>;
  public function new(inner:Eq<T>){
    this.inner = inner;
  }
  public function comply(lhs:TQExpr<T>,rhs:TQExpr<T>):Equaled{
    return switch([lhs,rhs]){
      case [QEVal(l),QEVal(r)]               : inner.comply(l,r);
      case [QEAnd(lI,rI),QEAnd(lII,rII)]     : comply(lI,lII) && comply(rI,rII);
      case [QEOr(lI,rI),QEOr(lII,rII)]       : comply(lI,lII) && comply(rI,rII);
      case [QENot(eI),QENot(eII)]            : comply(eI,eII);
      case [QEIn(filterI,sub_exprsI),QEIn(filterII,sub_exprsII)] : 
        var eq = new stx.assert.eq.QFilter().comply(filterI,filterII);
        if(eq.is_ok()){
          eq = new stx.assert.eq.QSubExpr(inner).comply(sub_exprsI,sub_exprsII);
        }
        eq;
      case [QEBinop(oI,lI),QEBinop(oII,lII)] :
        var eq = new stx.assert.eq.QBinop().comply(oI,oII);
        if(eq.is_ok()){
          eq = inner.comply(lI,lII);
        }
        eq;
      case [QEUnop(opI),QEUnop(opII)]        :
        new stx.assert.eq.QUnop().comply(opI,opII);
      default : Eq.EnumValueIndex().comply(lhs,rhs);
    }
  }
}
