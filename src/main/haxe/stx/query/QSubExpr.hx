package stx.query;

enum QSubExprSum<T>{
  //QSQExpr(result:QExpr<T>);

	QSAnd(l:QExpr<T>,r:QExpr<T>);
	QSOr(l:QExpr<T>,r:QExpr<T>);
	QSNot(e:QExpr<T>);

  QSOf(key:String,expr:QExpr<T>);
  QSIn(filter:QFilter,sub_exprs:QSubExpr<T>);

	QSBinop(op:QBinop,l:T);
	QSUnop(op:stx.query.QUnop);
  //QRange
}
@:using(stx.query.QSubExpr.QSubExprLift)
abstract QSubExpr<T>(QSubExprSum<T>) from QSubExprSum<T> to QSubExprSum<T>{
  static public var _(default,never) = QSubExprLift;
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:QSubExprSum<T>):QSubExpr<T> return new QSubExpr(self);

  public function prj():QSubExprSum<T> return this;
  private var self(get,never):QSubExpr<T>;
  private function get_self():QSubExpr<T> return lift(this);

}
class QSubExprLift{
  // static public function comply<T>(self:QSubExpr<T>,api:QueryApi<T>,val:T):Res<Cluster<QResult>,QueryFailure>{
  //   final f = comply.bind(_,api,val);
  //   return switch(self){
  //     case QSQExpr(qexpr)                     : qexpr.apply(api);
  //     case QAnd(l,r) 								          : f(l).zip(f(r)).map(__.decouple((l,r)-> l && r));
	// 		case QOr(l,r)									          : f(l).zip(f(r)).map(__.decouple((l,r)-> l || r));
	// 		case QNot(e)									          : f(e).map(x -> !x);

  //     case QSBinop(op,l)                      : expr
  //     case QSUnop(op)                         : 
  //   }
  // }
}