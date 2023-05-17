package stx.query;

enum QValSum<T>{
  QVItm(v:T);
  QVLst(xs:Cluster<T>);
}
@:using(stx.query.QVal.QValLift)
abstract QVal<T>(QValSum<T>) from QValSum<T> to QValSum<T>{
  static public var _(default,never) = QValLift;
  public inline function new(self:QValSum<T>) this = self;
  @:noUsing static inline public function lift<T>(self:QValSum<T>):QVal<T> return new QVal(self);
  @:noUsing @:from static inline public function fromCluster<T>(self:Cluster<T>){
    return lift(QVLst(self));
  }
  @:noUsing @:from static inline public function fromT<T>(self:T){
    return lift(QVItm(self));
  }
  public function prj():QValSum<T> return this;
  private var self(get,never):QVal<T>;
  private function get_self():QVal<T> return lift(this);

  public function one(){
    return switch(self){
      case QVItm(v)   : __.option(v);
      default         : __.option();
    }
  }
}
class QValLift{
  static public inline function lift<T>(self:QValSum<T>):QVal<T>{
    return QVal.lift(self);
  }
  static public function toString_with<T>(self:QVal<T>,fn:T->String){
    return switch(self){
      case QVItm(v)   : fn(v);
      case QVLst(xs)  : xs.map(fn).join(", ");
    }
  }
}
