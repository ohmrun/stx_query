package stx.logic;

enum QFormulaSum<T,P>{
  QFStatement(statement:QStatement<T,P>);
  QFPredicate(pred:QPredicateLetter<P>, rest: Cluster<QTerm<T>>);
  QFConjunction(lhs:QFormula<T,P>, rhs:QFormula<T,P>);
  QFNegation(formula:QFormula<T,P>);
  QFDisjunction(lhs:QFormula<T,P>, rhs:QFormula<T,P>);
  QFConditional(lhs:QFormula<T,P>, rhs:QStatement<T,P>);
}
typedef QFormula<T,P> = QFormulaSum<T,P>; 