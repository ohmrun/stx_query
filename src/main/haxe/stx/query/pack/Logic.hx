package stx.query.pack;

import stx.query.head.data.Logic in LogicT;

abstract Logic<T>(LogicT<T>) from LogicT<T> to LogicT<T>{
  public function new(self) this = self;
  public function toString(){
    return toStringWith((x) -> Std.string(x));
  }
  public function toStringWith(fn:T->String){
    function rec(v:LogicT<T>){
      return switch(v){
        case LConj(l, r) :
          var ls = rec(l);
          var rs = rec(r);  
          '$ls && $rs';
        case LDisj(l, r) :
          var ls = rec(l);
          var rs = rec(r); 
          '$ls || $rs';
        case LInj(v)     :fn(v);
      }
    }
    return rec(this);
  }
}