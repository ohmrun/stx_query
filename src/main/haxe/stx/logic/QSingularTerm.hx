package stx.query;

typedef QSingleTermDef<T> = {
  final ident     : T;
  final subscript : QSubscript; 
}
abstract QSingleTerm<T>(QSingleTermDef<T>) from QSingleTermDef<T> to QSingleTermDef<T>{
  public function new(self) this = self;
  static public function lift<T>(self:QSingleTermDef<T>):QSingleTerm<T> return new QSingleTerm(self);

  public function prj():QSingleTermDef<T> return this;
  private var self(get,never):QSingleTerm<T>;
  private function get_self():QSingleTerm<T> return lift(this);
}