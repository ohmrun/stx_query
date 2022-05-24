package stx.assert.query.ord;

import stx.query.QFilter in TQFilter;

class QFilter extends OrdCls<TQFilter>{
  public function new(){}
  public function comply(lhs:TQFilter,rhs:TQFilter){
    return Ord.EnumValueIndex().comply(lhs,rhs);
  }
}