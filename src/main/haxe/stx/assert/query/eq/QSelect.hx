package stx.assert.query.eq;

import stx.query.QSelect in TQSelect;

class QSelect extends EqCls<TQSelect>{
  public function new(){}
  public function comply(lhs:TQSelect,rhs:TQSelect){
    return switch([lhs,rhs]){
      case [SField(keyI,idxI),SField(keyII,idxII)]  : 
        var eq = Eq.String().comply(keyI,keyII);
        if(eq.is_equal()){
          eq = Eq.NullOr(Eq.Int()).comply(idxI,idxII);
        }
        eq;
      case [SIndex(idxI),SIndex(idxII)]             : 
        Eq.Int().comply(idxI,idxII);
      case [SRange(lidxI,ridxI),SRange(lidxII,ridxII)]  : 
        var eq = Eq.NullOr(Eq.Int()).comply(lidxI,lidxII);
        if(eq.is_equal()){
          eq = Eq.NullOr(Eq.Int()).comply(ridxI,ridxII);
        }
        eq;
      default:  Eq.EnumValueIndex().comply(lhs,rhs);
    }
  }
}