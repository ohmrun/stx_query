package stx.query;

enum QSelectSum{
  Opn(?next:QSelect);
  Rec(name:String,next:QSelect);
}