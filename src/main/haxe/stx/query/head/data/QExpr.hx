package stx.query.head.data;

enum QExpr{
  QEBlank;
  
  QEConst(c:QConst);

  QEPos(pos:Node,e:QExpr);

  QEUnop(c:QUnop,e:QExpr);
  QEBinop(c:QBinop,l:QExpr,r:QExpr);

  QELogic(l:Logic<QExpr>);

  QEGroup(e:QExpr);

  //LEBind
}