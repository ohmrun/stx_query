package stx.query;

enum QFormulaSum<T,P>{
  QFStatement(statement:QStatement<T>);
  QFPredicate(pred:PredicateLetter<P>, Cluster<Term<T>>);
  QFConjunction(lhs:QFormula<T,P>, rhs:QFormula<T,P>);
  QFNegation(formula:QFormula<T,P>);
  QFDisjunction(lhs:QFormula<T,P>, rhs:QFormula<T,P>);
  QFConditional(lhs:QFormula<T,P>, rhs:QStatement<T,P>);
}