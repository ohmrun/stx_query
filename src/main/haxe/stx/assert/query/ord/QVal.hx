package stx.assert.query.ord;

import stx.query.QVal in TQVal;

class QVal<T> extends OrdCls<TQVal<T>>{
  final inner : Ord<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function comply(lhs:TQVal<T>,rhs:TQVal<T>):Ordered{
    return switch([lhs,rhs]){
      case [QVLst(l),QVLst(r)] : Ord.Cluster(inner).comply(l,r);
      case [QVItm(l),QVItm(r)] : inner.comply(l,r);
      default                  : Ord.EnumValueIndex().comply(lhs,rhs);
    }
  }
}
