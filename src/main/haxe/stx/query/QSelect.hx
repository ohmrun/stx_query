package stx.query;

enum QSelectSum{
	SField(key:String,?idx:Int);
	SIndex(idx:Int);
	SRange(start:Int,?finish:Int);

	SWhich;
}
abstract QSelect(QSelectSum) from QSelectSum to QSelectSum{
  public function new(self) this = self;
  static public function lift(self:QSelectSum):QSelect return new QSelect(self);

  public function prj():QSelectSum return this;
  private var self(get,never):QSelect;
  private function get_self():QSelect return lift(this);
}