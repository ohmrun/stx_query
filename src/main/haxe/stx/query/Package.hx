package stx.query;

typedef Logic<T>  = stx.query.pack.Logic<T>;
typedef QUnop     = stx.query.pack.QUnop;
typedef QExpr     = stx.query.pack.QExpr;

typedef QConst    = stx.query.pack.QConst;
typedef Path      = stx.query.pack.Path;
typedef Variable  = stx.query.pack.Variable;


enum CheckT{
  Compare(v:Comparative);
}
abstract Check(CheckT) from CheckT{
  public function new(self) this = self;
  public function toString(){
    return switch(this){
      case Compare(v) : v.toString();
    }
  }
}
enum QBinop{
  QBCheck(c:Check);
}

enum PlacePattern{

}


typedef SymbolTable = Map<String,QExpr>;

typedef CollectionName = String;

typedef UnboundSelect = {
  var what : String;
  var from : CollectionName;
}
enum What{
  Sig();
  Schema();
}