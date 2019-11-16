package stx.query.pack;

import stx.query.head.data.QConst in QConstT;

abstract QConst(QConstT) from QConstT{
  public function new(self) this = self;
  public function toString(){
    return switch(this){
      case QCSelf             :  '*';
      case QCPrim(prim)       :  prim.toString();
      case QCVar(v)           :  v.toString();
    }
  }
}