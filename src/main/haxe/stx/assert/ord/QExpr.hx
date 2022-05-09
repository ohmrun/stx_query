package stx.assert.ord;

import stx.query.QExpr in TQExpr;

class QExpr<T> extends OrdCls<TQExpr<T>>{
  final inner : Ord<T>;
  public function new(inner:Ord<T>){
    this.inner = inner;
  }
  public function comply(lhs:TQExpr<T>,rhs:TQExpr<T>):Ordered{
    return switch([lhs,rhs]){
      case [QVal(l),QVal(r)]               : inner.comply(l,r);
      case [QAnd(lI,rI),QAnd(lII,rII)]     : comply(lI,lII) && comply(rI,rII);
      case [QOr(lI,rI),QOr(lII,rII)]       : comply(lI,lII) && comply(rI,rII);
      case [QNot(eI),QNot(eII)]            : comply(eI,eII);
      case [QIn(filterI,sub_exprsI),QIn(filterII,sub_exprsII)] : 
        var ord = new stx.assert.ord.QFilter().comply(filterI,filterII);
        if(ord.is_not_less_than()){
          ord = Ord.Cluster(new stx.assert.ord.QSubExpr()).comply(sub_exprsI,sub_exprsII);
        }
        ord;
      case [QBinop(oI,lI),QBinop(oII,lII)] :
        var ord = new stx.assert.ord.QBinop().comply(oI,oII);
        if(ord.is_not_less_than()){
          ord = inner.comply(lI,lII);
        }
        ord;
      case [QUnop(opI),QUnop(opII)]        :
        new stx.assert.ord.QUnop().comply(opI,opII);
      default : Ord.EnumValueIndex().comply(lhs,rhs);
    }
  }
}