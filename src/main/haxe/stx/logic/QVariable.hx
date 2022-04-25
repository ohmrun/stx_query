package stx.logic;

typedef QVariableDef<T> = {
  final ident     : T;
  final subscript : QSubscript; 
}
abstract QVariable<T>(QVariableDef<T>) from QVariableDef<T> to QVariableDef<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:QVariableDef<T>):QVariable<T> return new QVariable(self);

  public function prj():QVariableDef<T> return this;
  private var self(get,never):QVariable<T>;
  private function get_self():QVariable<T> return lift(this);
}