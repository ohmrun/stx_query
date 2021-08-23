package stx.query;

enum QuerySum{
  QUnop(op:QUnop,expr:Query);
}
abstract Query(QuerySum) from QuerySum to QuerySum{
  public function new(self) this = self;
  static public function lift(self:QuerySum):Query return new Query(self);

  public function prj():QuerySum return this;
  private var self(get,never):Query;
  private function get_self():Query return lift(this);
}