package stx.query.head.data;

enum QConst{
  QCSelf;
  QCPrim(p:Primitive);
  QCVar(v:Variable);
}