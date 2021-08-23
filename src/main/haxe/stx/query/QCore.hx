package stx.query;

enum QCoreSum<QS,QR,Sp>{
  QPred(in:QCore<QS,QR,Sp>);
  QFilt(d:QSelect<QS,QR>);
  QData(spine:Spine<Sp>);

  QSeq(l:QCore<QS,QR,Sp>,r:QCore<QS,QR,Sp>);
  QAlt(l:QCore<QS,QR,Sp>,r:QCore<QS,QR,Sp>);
}