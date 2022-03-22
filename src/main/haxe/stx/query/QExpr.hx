package stx.query;

enum QExprSum<T>{
	QAnd(l:QExpr<T>,r:QExpr<T>);
	QOr(l:QExpr<T>,r:QExpr<T>);
	QNot(e:QExpr<T>);

	QIn(of:T,sum:QFilter,e:QExpr<T>);

	QBinop(op:QBinop,l:T,r:T);
	QUnop(op:QUnop,v:T);
}
//	QSel(path:QPath,query:QExpr);
abstract QExpr<T>(QExprSum<T>) from QExprSum<T> to QExprSum<T>{
	public function new(self) this = self;
	static public function lift<T>(self:QExprSum<T>):QExpr<T> return new QExpr(self);

	public function prj():QExprSum<T> return this;
	private var self(get,never):QExpr<T>;
	private function get_self():QExpr<T> return lift(this);
	
	@:op(A && B)
	public function and(that:QExpr<T>){
		return lift(QAnd(this,that));
	}
	@:op(A || B)
	public function or(that:QExpr<T>){
		return lift(QOr(this,that));
	}
}