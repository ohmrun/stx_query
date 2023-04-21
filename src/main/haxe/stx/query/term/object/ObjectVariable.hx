package stx.query.term.object;

enum ObjectVariable{
  OVUnbound(str:QExpr<Option<Noise>>);
  OVBound(om:Spine);
}