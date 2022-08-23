package stx.assert.query.ord;

import stx.query.QSelect in TQSelect;

class QSelect extends OrdCls<TQSelect>{
  public function new(){}
  public function comply(lhs:TQSelect,rhs:TQSelect){
    return switch([lhs,rhs]){
      case [SField(keyI,idxI),SField(keyII,idxII)]  : 
        var ord = Ord.String().comply(keyI,keyII);
        if(ord.is_not_less_than()){
          ord = Ord.NullOr(Ord.Int()).comply(idxI,idxII);
        }
        ord;
      case [SIndex(idxI),SIndex(idxII)]             : 
        Ord.Int().comply(idxI,idxII);
      case [SRange(lidxI,ridxI),SRange(lidxII,ridxII)]  : 
        var ord = Ord.NullOr(Ord.Int()).comply(lidxI,lidxII);
        if(ord.is_not_less_than()){
          ord = Ord.NullOr(Ord.Int()).comply(ridxI,ridxII);
        }
        ord;
      default:  Ord.EnumValueIndex().comply(lhs,rhs);
    }
  }
}