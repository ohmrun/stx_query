package stx.logic;

enum QInputSum<T,P>{
  QIStatementSet(arr:Cluster<QStatement<T,P>>);
  QIArgument(statements:Cluster<QStatement<T,P>>, arg:QStatement<T,P>);
  QIStatement(statement:QStatement<T,P>);
}
abstract QInput<T,P>(QInputSum<T,P>) from QInputSum<T,P> to QInputSum<T,P>{
  public function new(self) this = self;
  @:noUsing static public function lift<T,P>(self:QInputSum<T,P>):QInput<T,P> return new QInput(self);

  public function prj():QInputSum<T,P> return this;
  private var self(get,never):QInput<T,P>;
  private function get_self():QInput<T,P> return lift(this);
}