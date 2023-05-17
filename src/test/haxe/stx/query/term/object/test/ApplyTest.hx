package stx.query.term.object.test;

import eu.ohmrun.pml.term.spine.PmlSpine;

final Eq = __.assert().Eq();

class ApplyTest extends TestCase{
  public function test(){
    final _     = __.query().that();
    trace(__.resource("value").string());
    //parse.pml.Lexer.main.apply
    final rval  = 
      switch(new eu.ohmrun.pml.term.spine.Decode().apply(
        __.pml().parser()(__.resource("value").string().reader())
              .toUpshot()
              .errate(x -> E_Query_ParseFailure(x))
              .flat_map(
                opt -> opt.resolve(f -> f.of(E_Query("no value")))
              ).fudge()
      )){
        case Collect(x) : x.head().map(x -> x());
        default         : None;
      }
    trace(select(_.Val(rval.fudge()),'array_of_objects'));
    //final q = _.In("")
  }
  // static public function comparable(){
  //   return new stx.assert.query.eq.QVal(Eq.Pm) 
  // }
  static public function assess<T>(self:QExpr<Spine<T>>):Upshot<Bool,QueryFailure>{
    switch(self){
      case QEIdx                          : __.accept(true);
      case QEVal(v)                       : __.accept(true);
      case QEAnd(l, r)                    : assess(l).zip(assess(r)).map(__.decouple((l,r)-> l && r));
      case QEOr(l, r)                     : assess(l).flat_map(
        l -> l ? __.accept(l) :  assess(r)
      );
      case QENot(e)                       : assess(e).map(b -> !b);
      case QEOf(key, expr)                : select(expr,key).flat_map(
        opt -> opt.fold( 
          ok -> assess(ok),
          () -> __.accept(false)
        )
      );
      case QEIn(filter, expr, sub)        : 
        final values = supply(expr);
        final result = values.flat_map(
          values -> {
            return Upshot.bind_fold(
              values,
              (next:QExpr<Spine<T>>,memo:Cluster<QExpr<Spine<T>>>) -> {
                return refine(sub,next).map(
                  memo.snoc
                );
              },
              [].imm()
            );
          }
        );
        result.flat_map(
          result -> Upshot.bind_fold(
            result,
            (next,memo:Cluster<Bool>) -> {
              return assess(next).map(memo.snoc);
            },
            [].imm()
          )
        ).map(
          arr -> switch(filter){
            case UNIVERSAL    : arr.all(x -> x == true);
	          case EXISTENTIAL  : arr.any(x -> x == true);
          }
        );
      case QEBinop(EQ, l, r)              : 
        final _l = unfold(l);
        final _r = unfold(r);
        return _l.zip(_r).flat_map(
          __.decouple(
            (x,y) -> {
              return stx.assert.query.eq.QVal(this)
            }
          )
        );
      case QEUnop(op, e)                  : null;
    }
    return null;
  }
  static public function unfold<T>(self:QExpr<Spine<T>>):Upshot<QVal<Spine<T>>,QueryFailure>{
    return switch(self){
      case QEVal(v)               : __.accept(v);
      case QEOf(key, expr)        : select(expr,key).flat_map(unfold);
      default                     : __.reject(f -> f.of(E_Query("cannot unfold")))
    }
  }
  static public function select<T>(self:QExpr<Spine<T>>,key:String):Upshot<Option<QExpr<Spine<T>>>,QueryFailure>{
    return switch(self){
      case QEVal(QVItm(Collate(arr))) : 
        __.accept(
          arr.search((kv) -> kv.key == key).map(x -> QEVal(x.value()))
        );
      default : 
        __.accept(__.option());
    }
    return __.accept(__.option());
  }
  // static public function finger<T>(self:QExpr<Spine<T>>,expr:QExpr<Spine<T>>){
    
  // }
  static public function supply<T>(self:QExpr<Spine<T>>):Upshot<Cluster<QExpr<Spine<T>>>,QueryFailure>{
    return switch(self){
      case QEVal(QVItm(Collect(arr))) : __.accept(arr.map(x -> QEVal(QVItm(x()))));
      default                         : __.reject(f -> f.of(E_Query('expr not a collection')));
    }
    return __.accept([].imm());
  }
  static public function refine<T>(self:QSubExpr<Spine<T>>,that:QExpr<Spine<T>>):Upshot<QExpr<Spine<T>>,QueryFailure>{
		final f = refine.bind(_,that);
		return switch(self){
			case QSAnd(l,r) 				:  
				f(l).flat_map(
					l -> f(r).map(r -> QEAnd(l,r))
				);
			case QSOr(l,r)					: 
				f(l).flat_map(
					l -> f(r).map(r -> QEOr(l,r))
				);
			case QSNot(e) 					:
				f(e).map(QENot);
			case QSOf(key,expr)			:
        f(expr).flat_map(
          e -> select(e,key).flat_map(
            opt -> opt.resolve(f -> f.of(E_Query("oops")))
          )
        );
			case QSIn(filter,q,e) 	:
        f(q).flat_map(
          q -> refine(e,q)
        );
			case QSBinop(op,l)			:
        f(l).map(
          l -> QEBinop(op,l,that)
        );
			case QSUnop(op) 				:
        __.accept(QEUnop(op,that));
		}
	}
}                 
class QSubExprApply{
  static public function assess(self){

  }
}