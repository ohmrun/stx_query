package stx.assert.ord;

import stx.query.QBinop in TQBinop;

class QBinop extends OrdCls<TQBinop>{
  public function new(){}
  public function comply(lhs:TQBinop,rhs:TQBinop){
    return Ord.EnumValueIndex().comply(lhs,rhs);
  }
}