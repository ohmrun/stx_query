package stx.assert.query.ord;

import stx.query.QSubExpr in TQSubExpr;

class QSubExpr<T> extends OrdCls<TQSubExpr<T>>{
  final inner : Ord<T>;
  public function new(inner:Ord<T>){
    this.inner = inner;
  }
  public function comply(lhs:TQSubExpr<T>,rhs:TQSubExpr<T>):Ordered{
    return switch([lhs,rhs]){
      case [QSAnd(lI,rI),QSAnd(lII,rII)]     : comply(lI,lII) && comply(rI,rII);
      case [QSOr(lI,rI),QSOr(lII,rII)]       : comply(lI,lII) && comply(rI,rII);
      case [QSNot(eI),QSNot(eII)]            : comply(eI,eII);
      case [QSBinop(oI,lI),QSBinop(oII,lII)] :
        var ord = new stx.assert.query.ord.QBinop().comply(oI,oII);
        if(ord.is_not_less_than()){
          ord = inner.comply(lI,lII);
        }
        ord;
      case [QSUnop(opI),QSUnop(opII)]        :
        new stx.assert.query.ord.QUnop().comply(opI,opII);
      default : Ord.EnumValueIndex().comply(lhs,rhs);
    }
  }
}