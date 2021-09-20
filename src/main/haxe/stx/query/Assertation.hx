package stx.query;

using stx.Nano;
using stx.Log;


enum AssertationSum<L,R>{
  And(lhs:AssertationSum<L,R>,rhs:AssertationSum<L,R>);
  Or(lhs:AssertationSum<L,R>,rhs:AssertationSum<L,R>);

  Binop(op:AssertationBinop,lhs:L,rhs:R);
}
abstract Assertation<L,R>(AssertationSum<L,R>) from AssertationSum<L,R> to AssertationSum<L,R>{
  public function new(self) this = self;
  static public function lift<L,R>(self:AssertationSum<L,R>):Assertation<L,R> return new Assertation(self);

  public function prj():AssertationSum<L,R> return this;
  private var self(get,never):Assertation<L,R>;
  private function get_self():Assertation<L,R> return lift(this);

}
class AssertationLift{
  static public function apply<L,R,T>(self:Assertation<L,R>,fn:Couple<L->T,R->T>):AssertationResolved<T>{
    var f = apply.bind(_,fn);
    return switch(self){
      case And(l,r)       : And(f(l),f(r));
      case Or(l,r)        : Or(f(l),f(r));
      case Binop(op,l,r)  : fn.decouple(
        (fl,fr) -> Binop(op,fl(l),fr(r)) 
      );
    }
  }
}

enum AssertationBinopSum{
  EQ;
  
  GT;
  LT;

  GTEQ;
  LTEQ;

}
abstract AssertationBinop(AssertationBinopSum) from AssertationBinopSum to AssertationBinopSum{
  public function new(self) this = self;
  static public function lift(self:AssertationBinopSum):AssertationBinop return new AssertationBinop(self);

  public function prj():AssertationBinopSum return this;
  private var self(get,never):AssertationBinop;
  private function get_self():AssertationBinop return lift(this);
}


typedef AssertationResolvedSum<T> = AssertationSum<T,T>;

@:using(stx.query.Assertation.AssertationResolvedLift)
abstract AssertationResolved<T>(AssertationResolvedSum<T>) from AssertationResolvedSum<T> to AssertationResolvedSum<T>{
  public function new(self) this = self;
  static public function lift<T>(self:AssertationResolvedSum<T>):AssertationResolved<T> return new AssertationResolved(self);

  public function prj():AssertationResolvedSum<T> return this;
  private var self(get,never):AssertationResolved<T>;
  private function get_self():AssertationResolved<T> return lift(this);
}

typedef AssertationResolvedImpl<T> = {
  final eq : Eq<T>;
  final lt : Ord<T>;
}
class AssertationResolvedLift{
  static public function apply<T>(self:AssertationResolved<T>,impl:AssertationResolvedImpl<T>):Report<AssertFailure>{
    return switch(self){
      case Binop(EQ,l,r)    : impl.eq.toAssertion().comply(l,r);
      case Binop(GT,l,r)    : impl.lt.toAssertion().comply(r,l);
      case Binop(LT,l,r)    : impl.lt.toAssertion().comply(l,r);
      case Binop(GTEQ,l,r)  : 
        impl.lt.toAssertion().comply(r,l).fold(
          (e) -> e.report(),
          ()  -> impl.eq.toAssertion().comply(r,l)
        );
      case Binop(LTEQ,l,r)  : 
        impl.lt.toAssertion().comply(l,r).fold(
          (e) -> e.report(),
          ()  -> impl.eq.toAssertion().comply(l,r)
        );
      case And(l,r)         : 
        apply(l,impl).fold(
          e -> e.report(),
          ()  -> apply(r,impl)
        );
      case Or(l,r)          : 
        apply(l,impl).fold(
          e -> apply(r,impl),
          () -> __.report()
        );
    }
  }  
}