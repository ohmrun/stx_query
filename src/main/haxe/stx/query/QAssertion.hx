package stx.query;

typedef QAssertionDef<T,U> = {
  final op  : QBinop;
  final lhs : T;
  final rhs : U;
}