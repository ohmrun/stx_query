package stx.logic;

enum QStatementSum<T,P>{ 
  QSSimple(letter:QSimpleStatementLetter<T>);
  QSSingular(pred:QPredicateLetter<P>, args: Cluster<QSingularTerm<T>>);
  QSConjunction(lhs:QStatement<T,P>, rhs:QStatement<T,P>);
  QSNegation(statement:QStatement<T,P>);
  QSDisjunction(lhs:QStatement<T,P>, rhs:QStatement<T,P>);
  QSConditional(lhs:QStatement<T,P>, rhs:QStatement<T,P>);
  QSExistential(v:QVariable<T>, f:QFormula<T,P>);
  QSUniversal(v:QVariable<T>, f:QFormula<T,P>);
}
abstract QStatement<T,P>(QStatementSum<T,P>) from QStatementSum<T,P> to QStatementSum<T,P>{
  public function new(self) this = self;
  @:noUsing static public function lift<T,P>(self:QStatementSum<T,P>):QStatement<T,P> return new QStatement(self);

  public function prj():QStatementSum<T,P> return this;
  private var self(get,never):QStatement<T,P>;
  private function get_self():QStatement<T,P> return lift(this);
}
