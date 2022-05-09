package stx.assert.eq;

import stx.query.QFilter in TQFilter;

class QFilter extends EqCls<TQFilter>{
  public function new(){}
  public function comply(lhs:TQFilter,rhs:TQFilter){
    return Eq.EnumValueIndex().comply(lhs,rhs);
  }
}