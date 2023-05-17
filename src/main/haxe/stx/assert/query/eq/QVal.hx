package stx.assert.query.eq;

import stx.query.QVal in TQVal;

class QVal<T> extends EqCls<TQVal<T>>{
  final inner : Eq<T>;
  public function new(inner){
    this.inner = inner;
  }
  public function comply(lhs:TQVal<T>,rhs:TQVal<T>):Equaled{
    return switch([lhs,rhs]){
      case [QVLst(l),QVLst(r)] : Eq.Cluster(inner).comply(l,r);
      case [QVItm(l),QVItm(r)] : inner.comply(l,r);
      default                  : Eq.EnumValueIndex().comply(lhs,rhs);
    }
  }
}
