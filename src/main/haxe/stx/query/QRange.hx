package stx.query.range;

enum QRangeSum{
  At(idx:Int);
  Between(lo:Int,hi:Int);//<
}
abstract QRange(QRangeSum) from QRangeSum to QRangeSum{
  public function new(self) this = self;
  static public function lift(self:QRangeSum):QRange return new QRange(self);

  public function prj():QRangeSum return this;
  private var self(get,never):QRange;
  private function get_self():QRange return lift(this);
}