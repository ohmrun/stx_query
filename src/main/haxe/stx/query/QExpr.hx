package stx.query;

enum QExprSum<T>{
	QEVal(v:T);
	QEAnd(l:QExpr<T>,r:QExpr<T>);
	QEOr(l:QExpr<T>,r:QExpr<T>);
	QENot(e:QExpr<T>);

	QEIn(filter:QFilter,sub_exprs:QSubExpr<T>);  

	QEBinop(op:QBinop,l:T);
	QEUnop(op:QUnop);
}
@:using(stx.query.QExpr.QExprLift)
abstract QExpr<T>(QExprSum<T>) from QExprSum<T> to QExprSum<T>{
	static public var _(default,never) = QExprLift;
	public function new(self) this = self;
	@:noUsing static public function lift<T>(self:QExprSum<T>):QExpr<T> return new QExpr(self);

	public function prj():QExprSum<T> return this;
	private var self(get,never):QExpr<T>;
	private function get_self():QExpr<T> return lift(this);
	
	@:op(A && B)
	public function and(that:QExpr<T>){
		return lift(QEAnd(this,that));
	}
	@:op(A || B)
	public function or(that:QExpr<T>){
		return lift(QEOr(this,that));
	}
	
}
class QExprLift{
	// static public function apply<T>(self:QExpr<T>,val:T,api:QueryApi<T>):Res<QResult,QueryFailure>{
	// 	final f = apply.bind(_,api);
	// 	return switch(self){
	// 		case QVal(v) 									: __.accept(QTrue);//TODO: is this right?
	// 		case QRes(result)							: __.accept(result);
		
	// 		case QAnd(l,r) 								: f(l).zip(f(r)).map(__.decouple((l,r)-> l && r));
	// 		case QOr(l,r)									: f(l).zip(f(r)).map(__.decouple((l,r)-> l || r));
	// 		case QNot(e)									: f(e).map(x -> !x);
		
	// 		case QIn(filter,arg,sub_expr) : 
				  
	// 		case QBinop(EQ,l,r)						: __.accept(api.eq().comply(l,r).ok());
	// 		case QBinop(NEQ,l,r)					: __.accept(!api.eq().comply(l,r).ok());
	// 		case QBinop(LT,l,r)						: __.accept(api.lt().comply(l,r).ok());
	// 		case QBinop(LTEQ,l,r)					: __.accept(api.lt().comply(l,r).ok() || api.eq().comply(l,r).ok());

	// 		case QBinop(GT,l,r)						: __.accept(api.lt().comply(r,l).ok());
	// 		case QBinop(GTEQ,l,r)					: __.accept(api.lt().comply(r,l).ok() || api.eq().comply(r,l).ok());

	// 		case QUnop(op,v) 							: __.accept(api.exists().apply(v));
	// 	}
	// }
}