package stx.assert.query.ord;

import stx.query.QSubExpr in TQSubExpr;

class QSubExpr<T> extends OrdCls<TQSubExpr<T>>{
  final inner : Ord<T>;
  public function new(inner:Ord<T>){
    this.inner = inner;
  }
  public function comply(lhs:TQSubExpr<T>,rhs:TQSubExpr<T>):Ordered{
    final expr_ord = new stx.assert.query.ord.QExpr(inner);
    return switch([lhs,rhs]){
      case [QSAnd(lI,rI),QSAnd(lII,rII)]     : expr_ord.comply(lI,lII) && expr_ord.comply(rI,rII);
      case [QSOr(lI,rI),QSOr(lII,rII)]       : expr_ord.comply(lI,lII) && expr_ord.comply(rI,rII);
      case [QSNot(eI),QSNot(eII)]            : expr_ord.comply(eI,eII);
      case [QSBinop(oI,lI),QSBinop(oII,lII)] :
        var ord = new stx.assert.query.ord.QBinop().comply(oI,oII);
        if(ord.is_not_less_than()){
          ord = inner.comply(lI,lII);
        }
        ord;
      case [QSOf(keyI,restI),QSOf(keyII,restII)]  : 
        var ord = Ord.String().comply(keyI,keyII);
        if(ord.is_ok()){
          ord = expr_ord.comply(restI,restII);
        }
        ord;
      case [QSIn(filterI,sub_exprsI),QSIn(filterII,sub_exprsII)] : 
        var ord = new stx.assert.query.ord.QFilter().comply(filterI,filterII);
        if(ord.is_not_less_than()){
          ord = new stx.assert.query.ord.QSubExpr(inner).comply(sub_exprsI,sub_exprsII);
        }
        ord;
      case [QSUnop(opI),QSUnop(opII)]        :
        new stx.assert.query.ord.QUnop().comply(opI,opII);
      default : Ord.EnumValueIndex().comply(lhs,rhs);
    }
  }
}