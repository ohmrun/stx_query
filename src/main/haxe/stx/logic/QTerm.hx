package stx.query;

enum QTermSum<T>{
  QTVariable(v:QVariable<T>);
  QTSingularTerm(v:QSingularTerm<T>);
}