package stx.query.pack;

import stx.query.head.data.QUnop in QUnopT;

abstract QUnop(QUnopT) from QUnopT{
  public function new(self) this = self;
  public function toString(){
    return switch(this){
      case QUNot      : '!';
      case QUExists   : "?";
    }
  }
}