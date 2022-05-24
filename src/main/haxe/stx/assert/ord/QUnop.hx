package stx.assert.ord;

import stx.query.QUnop in TQUnop;

class QUnop extends OrdCls<TQUnop>{
  public function new(){}
  public function comply(lhs:TQUnop,rhs:TQUnop){
    return Ord.EnumValueIndex().comply(lhs,rhs);
  }
}