package stx.logic;

enum QTermSum<T>{
  QTVariable(v:QVariable<T>);
  QTSingularTerm(v:QSingularTerm<T>);
}
typedef QTerm<T> = QTermSum<T>;