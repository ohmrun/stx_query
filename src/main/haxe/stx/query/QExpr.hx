package stx.query;

class QExprCtr extends Clazz {
	@:noUsing static public function lift<T>(self:QExprSum<T>):QExpr<T> return QExpr.lift(self);

	public function Val<T>(v:QVal<T>){ return lift(QEVal(v)); }
	public function Id<T>():QExpr<T>{ return lift(QEIdx); }
	public function Eq<T>(self:QExpr<T>, that:QExpr<T>):QExpr<T> { return lift(QEBinop(EQ, self,that)); }
	public function Neq<T>(self:QExpr<T>, that:QExpr<T>):QExpr<T> { return lift(QEBinop(NEQ, self, that));}
	public function Gt<T>(self:QExpr<T>, that:QExpr<T>):QExpr<T> { return lift(QEBinop(GT, self, that)); }
	public function GtEq<T>(self:QExpr<T>, that:QExpr<T>):QExpr<T> { return lift(QEBinop(GTEQ, self, that)); }
	public function Lt<T>(self:QExpr<T>, that:QExpr<T>):QExpr<T> { return lift(QEBinop(LT, self, that)); }
	public function LtEq<T>(self:QExpr<T>, that:QExpr<T>):QExpr<T> { return lift(QEBinop(LTEQ, self, that)); }
	public function Like<T>(self:QExpr<T>, that:QExpr<T>):QExpr<T> { return lift(QEBinop(LIKE, self,that));}

	public function Of<T>(key:String, expr:CTR<QExprCtr, QExpr<T>>):QExpr<T> {
		return lift(QEOf(key, expr.apply(this)));
	}
	public function In<T>(filter:CTR<QExprCtr, QFilter>, expr:CTR<QExprCtr, QExpr<T>>,sub:CTR<QSubExprCtr, QSubExpr<T>>) {
		return lift(QEIn(filter.apply(this), expr.apply(this), sub.apply(new QSubExprCtr())));
	}

	public function All() { return UNIVERSAL;}
	public function Any() { return EXISTENTIAL;}
}

enum QExprSum<T = haxe.ds.Option<stx.pico.Nada>> {
	QEIdx;
	QEVal(v:QVal<T>);
	QEAnd(l:QExpr<T>, r:QExpr<T>);
	QEOr(l:QExpr<T>, r:QExpr<T>);
	QENot(e:QExpr<T>);

	QEOf(key:String, expr:QExpr<T>);
	QEIn(filter:QFilter, e:QExpr<T>, sub:QSubExpr<T>);
	QEBinop(op:QBinop, l:QExpr<T>,r:QExpr<T>);
	QEUnop(op:QUnop, e:QExpr<T>);
}

@:using(stx.query.QExpr.QExprLift)
abstract QExpr<T = haxe.ds.Option<stx.pico.Nada>>(QExprSum<T>) from QExprSum<T> to QExprSum<T> {
	static public var _(default, never) = QExprLift;

	public var value(get,never):Option<QVal<T>>;
	private function get_value():Option<QVal<T>>{
		return switch(this){
			case QEVal(v) : __.option(v);
			default 			: __.option();
		}
	}
	public function new(self)
		this = self;

	@:noUsing static public function lift<T>(self:QExprSum<T>):QExpr<T>
		return new QExpr(self);

	public function prj():QExprSum<T>
		return this;

	private var self(get, never):QExpr<T>;

	private function get_self():QExpr<T>
		return lift(this);

	static public function pure<T>(v:T):QExpr<T> {
		return lift(QEVal(v));
	}

	@:noUsing static public function unit<T>():QExpr<T> {
		return lift(QEIdx);
	}

	@:op(A && B)
	public function and(that:QExpr<T>) {
		return lift(QEAnd(this, that));
	}

	@:op(A || B)
	public function or(that:QExpr<T>) {
		return lift(QEOr(this, that));
	}	

	@:op(A.B)
	public function dot(that:String){
		return lift(QEOf(that, this));
	}
}

class QExprLift {
	static public function toStringWith<T>(self:QExpr<T>,fn:T->String) {
		final f 	= toStringWith.bind(_,fn);
		final fI  = QSubExpr._.toStringWith.bind(_,fn);
		return switch(self){
			case QEIdx 																: '_';
			case QEVal(v)	 														: QVal._.toString_with(v,fn);
			case QEAnd(l, r) 													: '${f(l)} && ${f(r)}';
			case QEOr(l, r) 													: '${f(l)} || ${f(r)}';
			case QENot(e) 														: '!${f(e)}';
			case QEOf(key, expr) 											: '${f(expr)}.${key}';
			case QEIn(UNIVERSAL, expr, sub_exprs) 		: 'all ${f(expr)} ${fI(sub_exprs)}';
			case QEIn(EXISTENTIAL, expr, sub_exprs) 	: 'any ${f(expr)} ${fI(sub_exprs)}';
			case QEBinop(op, l, r) 										: '${f(l)} ${op.toString()} ${f(r)}';
			case QEUnop(EXISTS,e) 										: 'exists ${f(e)}';
		}
	}
	// static public function apply<T>(self:QExpr<T>,val:T,api:QueryApi<T>):Upshot<QResult,QueryFailure>{
	// 	final f = apply.bind(_,api);
	// 	return switch(self){
	// 		case QVal(v) 									: __.accept(QTrue);//TODO: is this right?
	// 		case QUpshot(result)							: __.accept(result);
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
	// 		case QUnop(op,v) 							: __.accept(api.assess().apply(v));
	// 	}
	// }
}
