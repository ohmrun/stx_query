package stx.query;

enum QGatherSum<T>{
	GPath(sel:QPath);
	GBunch(data:Cluster<QDive<T>>);
	GWhere(data:T);
}
abstract QGather<T>(QGatherSum<T>) from QGatherSum<T> to QGatherSum<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:QGatherSum<T>):QGather<T> return new QGather(self);

  public function prj():QGatherSum<T> return this;
  private var self(get,never):QGather<T>;
  private function get_self():QGather<T> return lift(this);
}