package stx.assert.ord;

import stx.query.QExpr in TQExpr;

class QExpr<T> extends OrdCls<TQExpr<T>>{
  final inner : Ord<T>;
  public function new(inner:Ord<T>){
    this.inner = inner;
  }
  public function comply(lhs:TQExpr<T>,rhs:TQExpr<T>):Ordered{
    return switch([lhs,rhs]){
      case [QEVal(l),QEVal(r)]               : inner.comply(l,r);
      case [QEAnd(lI,rI),QEAnd(lII,rII)]     : comply(lI,lII) && comply(rI,rII);
      case [QEOr(lI,rI),QEOr(lII,rII)]       : comply(lI,lII) && comply(rI,rII);
      case [QENot(eI),QENot(eII)]            : comply(eI,eII);
      case [QEIn(filterI,sub_exprsI),QEIn(filterII,sub_exprsII)] : 
        var ord = new stx.assert.ord.QFilter().comply(filterI,filterII);
        if(ord.is_not_less_than()){
          ord = new stx.assert.ord.QSubExpr(inner).comply(sub_exprsI,sub_exprsII);
        }
        ord;
      case [QEBinop(oI,lI),QEBinop(oII,lII)] :
        var ord = new stx.assert.ord.QBinop().comply(oI,oII);
        if(ord.is_not_less_than()){
          ord = inner.comply(lI,lII);
        }
        ord;
      case [QEUnop(opI),QEUnop(opII)]        :
        new stx.assert.ord.QUnop().comply(opI,opII);
      default : Ord.EnumValueIndex().comply(lhs,rhs);
    }
  }
}