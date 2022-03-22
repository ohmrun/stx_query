package stx.query;

typedef QSimpleStatementLetterDef<T> = {
  final ident     : T;
  final subscript : QSubscript; 
}
abstract QSimpleStatementLetter<T>(QSimpleStatementLetterDef<T>) from QSimpleStatementLetterDef<T> to QSimpleStatementLetterDef<T>{
  public function new(self) this = self;
  static public function lift<T>(self:QSimpleStatementLetterDef<T>):QSimpleStatementLetter<T> return new QSimpleStatementLetter(self);

  public function prj():QSimpleStatementLetterDef<T> return this;
  private var self(get,never):QSimpleStatementLetter<T>;
  private function get_self():QSimpleStatementLetter<T> return lift(this);
}