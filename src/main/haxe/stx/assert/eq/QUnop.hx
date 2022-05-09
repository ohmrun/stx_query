package stx.assert.eq;

import stx.assert.eq.QUnop in TQUnop;

class QUnop extends EqCls<TQUnop>{
  public function new(){}
  public function comply(lhs:TQUnop,rhs:TQUnop){
    return Eq.EnumValueIndex().comply(lhs,rhs);
  }
}