package stx.assert.eq;

import stx.query.QUnop in TQUnop;

class QUnop extends EqCls<TQUnop>{
  public function new(){}
  public function comply(lhs:TQUnop,rhs:TQUnop):Equaled{
    return null;// Eq.EnumValueIndex().comply(lhs,rhs);
  }
}