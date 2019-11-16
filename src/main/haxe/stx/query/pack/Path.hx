package stx.query.pack;

abstract Path(List<Node>) from List<Node>{
  public function new(?self){
    this = self == null ? Nil : self;
  }
  function cons(v:Node):Path{
    return this.cons(v);
  }
  @:arrayAccess
  function getIdx(idx:Int):Path{
    return cons(NIndex(idx));
  }
  @:resolve 
  function getKey(key:String):Path{
    return cons(NField(key));
  }  
  public function at(expr:QExpr):QExpr{
    function rec(ls){
      return switch(ls){
        case Cons(x,xs) : QEPos(x,rec(xs));
        case Nil        : expr; 
      }
    }
    return rec(this);
  }
  @:to public function toExpr():QExpr{
    return at(QEConst(QCSelf));
  }
  public function e():QExpr{
    return toExpr();
  }
}