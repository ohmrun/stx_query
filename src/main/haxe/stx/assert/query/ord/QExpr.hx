package stx.assert.query.ord;

import stx.query.QExpr in TQExpr;

class QExpr<T> extends OrdCls<TQExpr<T>>{
  final inner : Ord<T>;
  public function new(inner:Ord<T>){
    this.inner = inner;
  }
  public function comply(lhs:TQExpr<T>,rhs:TQExpr<T>):Ordered{
    return switch([lhs,rhs]){
      case [QEAnd(lI,rI),QEAnd(lII,rII)]          : comply(lI,lII) && comply(rI,rII);
      case [QEOr(lI,rI),QEOr(lII,rII)]            : comply(lI,lII) && comply(rI,rII);
      case [QENot(eI),QENot(eII)]                 : comply(eI,eII);
      case [QEIn(filterI,exprI,sub_exprsI),QEIn(filterII,exprII,sub_exprsII)] : 
        var ord = new stx.assert.query.ord.QFilter().comply(filterI,filterII);
        if(ord.is_not_less_than()){
          ord = inner.comply(exprI,exprII);
        }
        if(ord.is_not_less_than()){
          ord = new stx.assert.query.ord.QSubExpr(inner).comply(sub_exprsI,sub_exprsII);
        }
        ord;
      case [QEBinop(oI,lI,rI),QEBinop(oII,lII,rII)] :
        var ord = new stx.assert.query.ord.QBinop().comply(oI,oII);
        if(ord.is_not_less_than()){
          ord = inner.comply(lI,lII);
        }
        if(ord.is_not_less_than()){
          ord = inner.comply(rI,rII);
        }
        ord;
      case [QEUnop(opI,l),QEUnop(opII,r)]        :
        var ord = new stx.assert.query.ord.QUnop().comply(opI,opII);
        if(ord.is_not_less_than()){
          ord = inner.comply(l,r);
        }
        ord;
      default : Ord.EnumValueIndex().comply(lhs,rhs);
    }
  }
}