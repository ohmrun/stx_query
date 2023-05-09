package stx.query.term.object;

class ObjectQueryCls extends stx.assert.om.comparable.Spine<Nada>{
  public function new(){
    super(Comparable.Anon(
      Eq.Anon((x,y) -> AreEqual),
      Ord.Anon((x,y) -> NotLessThan)
    ));
  }
  public function select(val:Spine,key:String):Upshot<Option<Spine>,QueryFailure>{
    return switch(val){
      case Collate(rec) : __.accept(rec.get(key).map(x -> x()));
      default           : __.reject(f -> f.of(E_Query('calling select on $val')));
    }
  }
  public function filter(val:Cluster<Spine>,expr:QExpr<Spine>):Upshot<Cluster<Spine>,QueryFailure>{
    return __.accept(val.filter(
      x -> search(x,expr)
    ));
  }
  public function search(val:Spine,expr:QExpr<Spine>):Bool{
    return switch(expr){
      case QEIdx            : true;
      case QEVal(v)         : eq().comply(val,v).is_ok();
      case QEAnd(l,r)       : 
        search(val,l) && search(val,r);
      case QEOr(l,r)        : 
        search(val,l) || search(val,r);
      case QENot(e)         : 
        !search(val,e);
      case QEOf(key,e1)   : 
        select(val,key).fold(
          opt -> search(opt.defv(Unknown),e1),
          err -> false
        );
      case QEIn(filter,sub_exprs) : 
          final next = switch(val){
            case Collect(arr) : arr;
            default           : [];
          }
          final filtered = next.map(x -> search(x(),sub_exprs));
          switch(next.length){
            case 0  : false;
            default : switch(filter){
              case UNIVERSAL    : next.length == filtered.length; 
              case EXISTENTIAL  : filtered.length > 0;
            } 
          }
      case QEBinop(EQ,v)    : 
        eq().comply(val,v).is_ok();
      case QEBinop(NEQ,v)   : 
        !eq().comply(val,v).is_ok();
      case QEBinop(LT,v)    : 
        lt().comply(val,v).is_ok();
      case QEBinop(LTEQ,v)  : 
        lt().comply(val,v).is_ok() || eq().comply(val,v).is_ok();
      case QEBinop(GT,v)    : 
        lt().comply(v,val).is_ok();
      case QEBinop(GTEQ,v)  : 
        lt().comply(v,val).is_ok() || eq().comply(val,v).is_ok();
      case QEBinop(LIKE,v)  : 
        Eq.EnumValueIndex().comply(val,v).is_ok();
      case QEUnop(EXISTS)   : 
        switch(val){
          case  Unknown : false;
          default       : true;
        }
    }
  }
  /**
   */
  public function refine(val:Spine,expr:QExpr<Spine>):Upshot<Option<Spine>,QueryFailure>{
    return switch(expr){
      case QEIdx            : __.accept(__.option((val)));
      case QEVal(v)         : __.accept(__.option(v));
      case QEAnd(l,r)       : 
        final lI = refine(val,l);
        final rI = refine(val,r);
        lI.zip(rI).map(
          __.decouple(
            (lopt,ropt) -> {
              return switch([lopt,ropt]){
                case [Some(Collate(lII)),Some(Collate(rII))]  : Some(Collate(lII.concat(rII)));
                case [Some(Collect(lII)),Some(Collect(rII))]  : Some(Collect(lII.concat(rII)));
                case [Some(l),Some(r)]                        : Some(Collect([() -> l, () -> r]));
                case [Some(l),None]                           : Some(l);
                case [None,Some(r)]                           : Some(r);
                case [Some(Unknown),r]                        : r;
                case [l,Some(Unknown)]                        : l;
                case [None,None]                              : None;
              }
            }
          )
        );
      case QEOr(l,r)        : 
        final lhs = refine(val,l);
        switch(lhs){
          case Accept(Some(Unknown)) | Accept(None)   : refine(val,r);
          default                                     : lhs;
        }
      case QENot(e)         : 
        __.accept(__.option(search(val,e) ? Unknown : val ));
      case QEOf(key,e1)   : 
        select(val,key).flat_map(
          x -> refine(x.defv(Unknown),e1)
        );
      case QEIn(filter,sub_exprs) : 
          final next = switch(val){
            case Collect(arr) : arr;
            default           : [];
          }
          final filtered = next.map_filter(
            (x) -> {
              final v = x();
              return search(v,sub_exprs).if_else(
                () -> Some(v),
                () -> None
              );
            }
          );
          Upshot.bind_fold(
            filtered,
            function(n:Spine,m:Cluster<Spine>):Upshot<Cluster<Spine>,QueryFailure>{
              return refine(n,sub_exprs).map(
                (opt:Option<Spine>) -> opt.fold(
                  m.snoc,
                  () -> m
                )
              );
            },
            [].imm()
          ).map(arr -> arr.map(x -> () -> x))
           .map(x -> Some(Collect(x)));
      
      case QEBinop(EQ,v)    : 
        eq().comply(val,v).is_ok()  
          ?  __.accept(__.option(val)) 
          : __.accept(None);
      case QEBinop(NEQ,v)   : 
        !eq().comply(val,v).is_ok() 
          ?  __.accept(__.option(val)) 
          : __.accept(None);
      case QEBinop(LT,v)    : 
        lt().comply(val,v).is_ok()  
          ?  __.accept(__.option(val)) 
          : __.accept(None);
      case QEBinop(LTEQ,v)  : 
        lt().comply(val,v).is_ok() || eq().comply(val,v).is_ok() 
          ? __.accept(__.option(val)) 
          : __.accept(None);
      case QEBinop(GT,v)    : 
        lt().comply(v,val).is_ok()
          ? __.accept(__.option(val)) 
          : __.accept(None);
      case QEBinop(GTEQ,v)  : 
        lt().comply(v,val).is_ok() || eq().comply(val,v).is_ok() 
          ? __.accept(__.option(val)) 
          : __.accept(None);
      case QEBinop(LIKE,v)  : 
        Eq.EnumValueIndex().comply(val,v).is_ok() 
          ? __.accept(__.option(val)) 
          : __.accept(None);
      case QEUnop(EXISTS)   : 
        switch(val){
          case Unknown  : __.accept(None);
          default       : __.accept(__.option(val));
        }
    }   
  }
}