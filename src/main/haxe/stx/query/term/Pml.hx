package stx.query.term;

class Pml<T> extends stx.assert.pml.comparable.PExpr<T>{
  public function new(T){
    super(T);
  }
  public function apply(self:QExpr<PExpr<T>>):Upshot<Bool,QueryFailure>{
    return switch(self){
      case QEIdx                  : __.accept(true);
      //case QEVal(v)             : true;
      case QEAnd(l, r)            : apply(l).flat_map(
        l -> apply(r).map(r -> l && r)
      );
      case QEOr(l, r)             : apply(l).flat_map(
        l -> l == true ? __.accept(true) : apply(r)
      );
      case QENot(e)               : apply(e).map(b -> !b);
      case QEIn(filter, e, sub)   : 
        final embed = __.nano().embed();
        switch(filter){
          case UNIVERSAL : e.all_bind_layer(
            e -> apply(sub.express(e)).embed(embed)
          ).disembed(embed);
          case EXISTENTIAL : e.any_bind_layer(
            e -> apply(sub.express(e)).embed(embed)
          ).disembed(embed);
        }
      case QEBinop(op,l,r)        : 
          switch(op){
            case EQ     : __.accept(this.eq().comply(l,r).is_ok());
            case NEQ    : __.accept(this.eq().comply(l,r).is_ok().not());
            case LT     : __.accept(this.lt().comply(l,r).is_ok());
            case LTEQ   : __.accept(this.eq().comply(l,r).is_ok() || this.lt().comply(l,r).is_ok());
            case GT     : __.accept(this.lt().comply(r,l).is_ok());
            case GTEQ   : __.accept(this.eq().comply(r,l).is_ok() || this.lt().comply(l,r).is_ok());
          
            case LIKE   : __.reject(f -> f.explain(d -> d.e_unimplemented()));
          }
      case QEUnop(EXISTS,l) : __.accept(l != null);
    }
  }
}