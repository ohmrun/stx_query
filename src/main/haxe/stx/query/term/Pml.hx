package stx.query.term;

class Pml<T> extends stx.assert.pml.comparable.PExpr<T>{
  public function new(T){
    super(T);
  }
  public function apply(self:QExpr<PExpr<T>>){
    return switch(self){
      case QEIdx                  : true;
      case QEVal(v)               : true;
      case QEAnd(l, r)            : apply(l) && apply(r);
      case QEOr(l, r)             : apply(l) ? true : apply(r);
      case QENot(e)               : !apply(e);
      case QEIn(filter, e, sub)   : switch(filter){
        case UNIVERSAL : e.all_layer(
          e -> apply(sub.express(e))
        ).fold(_ -> true, (_) -> false);
        case EXISTENTIAL : e.any_layer(
          e -> apply(sub.express(e))
        ).fold(_ -> true, (_) -> false);
      }
      case QEBinop(op,l,r)        : 
        switch(op){
          case EQ     : this.eq()
          case NEQ    : 
          case LT     : 
          case LTEQ   : 
          case GT     : 
          case GTEQ   : 
        
          case LIKE   : 
        }
    }
  }
  public function apply_sub(self:QSubExpr<PExpr<T>>){
    return switch(self){
      case QSAnd(l,r) : 
        (x:PExpr<T>) -> apply(l)(x) && apply(r)(x);
	    case QSOr(l,r)  : 
        (x:PExpr<T>) -> apply(l)(x) || apply(r)(x);
	    case QSNot(e)   : 
        (x:PExpr<T>) -> !apply(e)(x);
      case QSIn(filter,q,e) : 
        (x:PExpr<T>) -> {
          return switch(filter){
            case UNIVERSAL    : q.all_layer(
              (e:PExpr<T>) -> apply(e)
            );
            case EXISTENTIAL  : q.any_layer(
              (e:PExpr<T>) -> apply(e)
            );
          }
        }
      case QSBinop(op:QBinop,l) : QEBinop(op)
      case QSUnop(op:stx.query.QUnop);
    }
  }
}