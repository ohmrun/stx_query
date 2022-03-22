package stx.query;

typedef QPredicateLetterDef<T> = {
  final ident     : T;
  final subscript : QSubscript; 
}
abstract QPredicateLetter<T>(QPredicateLetterDef<T>) from QPredicateLetterDef<T> to QPredicateLetterDef<T>{
  public function new(self) this = self;
  static public function lift<T>(self:QPredicateLetterDef<T>):QPredicateLetter<T> return new QPredicateLetter(self);

  public function prj():QPredicateLetterDef<T> return this;
  private var self(get,never):QPredicateLetter<T>;
  private function get_self():QPredicateLetter<T> return lift(this);
}