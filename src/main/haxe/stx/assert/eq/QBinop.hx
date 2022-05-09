package stx.assert.eq;

import stx.query.QBinop in TQBinop;

class QBinop extends EqCls<TQBinop>{
  public function new(){}
  public function comply(lhs:TQBinop,rhs:TQBinop){
    return Eq.EnumValueIndex().comply(lhs,rhs);
  }
}