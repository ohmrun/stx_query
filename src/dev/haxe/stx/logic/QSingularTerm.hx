package stx.logic;

typedef QSingularTermDef<T> = {
  final ident     : T;
  final subscript : QSubscript; 
}
abstract QSingularTerm<T>(QSingularTermDef<T>) from QSingularTermDef<T> to QSingularTermDef<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:QSingularTermDef<T>):QSingularTerm<T> return new QSingularTerm(self);

  public function prj():QSingularTermDef<T> return this;
  private var self(get,never):QSingularTerm<T>;
  private function get_self():QSingularTerm<T> return lift(this);
}