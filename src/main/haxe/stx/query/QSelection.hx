package stx.query;

enum QSelectionSum{
  QSelField(name:String,?prev:QSelection);
  QSelQuery(range:QRange);
  QSelAnd(head:QSelection,rest:Cluster<QSelection>);
}
abstract QSelection(QSelectionSum) from QSelectionSum to QSelectionSum{
  public function new(self) this = self;
  static public function lift(self:QSelectionSum):QSelection return new QSelection(self);

  public function prj():QSelectionSum return this;
  private var self(get,never):QSelection;
  private function get_self():QSelection return lift(this);
}