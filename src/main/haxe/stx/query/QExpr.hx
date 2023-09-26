package stx.query;

class QExprCtr extends Clazz {
	@:noUsing static public function lift<T>(self:QExprSum<T>):QExpr<T> return QExpr.lift(self);

	public function Id<T>():QExpr<T>{ return lift(QEIdx); }
	public function Eq<T>(self:T, that:T):QExpr<T> { return lift(QEBinop(EQ, self,that)); }
	public function Neq<T>(self:T, that:T):QExpr<T> { return lift(QEBinop(NEQ, self, that));}
	public function Gt<T>(self:T, that:T):QExpr<T> { return lift(QEBinop(GT, self, that)); }
	public function GtEq<T>(self:T, that:T):QExpr<T> { return lift(QEBinop(GTEQ, self, that)); }
	public function Lt<T>(self:T, that:T):QExpr<T> { return lift(QEBinop(LT, self, that)); }
	public function LtEq<T>(self:T, that:T):QExpr<T> { return lift(QEBinop(LTEQ, self, that)); }
	public function Like<T>(self:T, that:T):QExpr<T> { return lift(QEBinop(LIKE, self,that));}

	public function In<T>(filter:CTR<QExprCtr, QFilter>, v:T,sub:CTR<QSubExprCtr, QSubExpr<T>>) {
		return lift(QEIn(filter.apply(this), v, sub.apply(new QSubExprCtr())));
	}

	public function All() { return UNIVERSAL; }
	public function Any() { return EXISTENTIAL; }
}

enum QExprSum<T = haxe.ds.Option<stx.pico.Nada>> {
	QEIdx;
	//QEVal(v:T);
	QEAnd(l:QExpr<T>, r:QExpr<T>);
	QEOr(l:QExpr<T>, r:QExpr<T>);
	QENot(e:QExpr<T>);

	QEIn(filter:QFilter, e:T, sub:QSubExpr<T>);
	QEBinop(op:QBinop, l:T,r:T);
	QEUnop(op:QUnop, e:T);
}

@:using(stx.query.QExpr.QExprLift)
abstract QExpr<T = haxe.ds.Option<stx.pico.Nada>>(QExprSum<T>) from QExprSum<T> to QExprSum<T> {
	static public var _(default, never) = QExprLift;

	public function new(self)
		this = self;

	@:noUsing static public function lift<T>(self:QExprSum<T>):QExpr<T>
		return new QExpr(self);

	public function prj():QExprSum<T>
		return this;

	private var self(get, never):QExpr<T>;

	private function get_self():QExpr<T>
		return lift(this);

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
}

class QExprLift {
	static public function toStringWith<T>(self:QExpr<T>,fn:T->String) {
		final f 	= toStringWith.bind(_,fn);
		final fI  = QSubExpr._.toStringWith.bind(_,fn);
		return switch(self){
			case QEIdx 																: '_';
			case QEAnd(l, r) 													: '${f(l)} && ${f(r)}';
			case QEOr(l, r) 													: '${f(l)} || ${f(r)}';
			case QENot(e) 														: '!${f(e)}';
			case QEIn(UNIVERSAL, expr, sub_exprs) 		: 'all ${expr} ${fI(sub_exprs)}';
			case QEIn(EXISTENTIAL, expr, sub_exprs) 	: 'any ${expr} ${fI(sub_exprs)}';
			case QEBinop(op, l, r) 										: '${l} ${op.toString()} ${r}';
			case QEUnop(EXISTS,e) 										: 'exists ${e}';
		}
	}
}
