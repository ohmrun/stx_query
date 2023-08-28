package stx.query;

class QSubExprCtr extends Clazz{
  @:noUsing static public function lift<T>(self:QSubExprSum<T>):QSubExpr<T> return QSubExpr.lift(self);

//	public function Val<T>(v:T):QSubExpr<T> { return lift(QSVal(v)); }
	public function Eq<T>(that:QSubExpr<T>):QSubExpr<T>	  { 	return lift(QSBinop(EQ, that)); 	}
	public function Neq<T>(that:QSubExpr<T>):QSubExpr<T> 	{ 	return lift(QSBinop(NEQ, that));	}
	public function Gt<T>(that:QSubExpr<T>):QSubExpr<T> 	{ 	return lift(QSBinop(GT, that)); 	}
	public function GtEq<T>(that:QSubExpr<T>):QSubExpr<T> { 	return lift(QSBinop(GTEQ, that)); }
	public function Lt<T>(that:QSubExpr<T>):QSubExpr<T> 	{ 	return lift(QSBinop(LT, that)); 	}
	public function LtEq<T>(that:QSubExpr<T>):QSubExpr<T> { 	return lift(QSBinop(LTEQ, that)); }
	public function Like<T>(that:QSubExpr<T>):QSubExpr<T> { 	return lift(QSBinop(LIKE, that)); }
}
enum QSubExprSum<T>{
  //QSVal(v:T);

	QSAnd(l:QSubExpr<T>,r:QSubExpr<T>);
	QSOr(l:QSubExpr<T>,r:QSubExpr<T>);
	QSNot(e:QSubExpr<T>);

  QSIn(filter:QFilter,q:QSubExpr<T>,e:QSubExpr<T>);

	QSBinop(op:QBinop,l:T);
	QSUnop(op:stx.query.QUnop);
}
@:using(stx.query.QSubExpr.QSubExprLift)
abstract QSubExpr<T>(QSubExprSum<T>) from QSubExprSum<T> to QSubExprSum<T>{
  static public var _(default,never) = QSubExprLift;
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:QSubExprSum<T>):QSubExpr<T> return new QSubExpr(self);

  public function prj():QSubExprSum<T> return this;
  private var self(get,never):QSubExpr<T>;
  private function get_self():QSubExpr<T> return lift(this);

  @:op(A && B) public function and(that:QSubExpr<T>) {
		return lift(QSAnd(this, that));
	}
	@:op(A || B) public function or(that:QSubExpr<T>) {
		return lift(QSOr(this, that));
	}
	public function express(v:T){
		return switch(this){
			case QSAnd(l,r) 				: QEAnd(l.express(v),r.express(v));
			case QSOr(l,r) 					: QEOr(l.express(v),r.express(v));
			case QSNot(e)   				: QENot(e.express(v));
			case QSIn(filter,q,e)		: QEIn(filter,q.express(v),e);
			case QSBinop(op,l) 			: QEBinop(op,l,v);
			case QSUnop(op) 				: QEUnop(op,v);
		}
	}
}
class QSubExprLift{
  static public function toStringWith<T>(self:QSubExpr<T>,fn:T->String) {
		final f = toStringWith.bind(_,fn);
		return switch(self){
			case QSAnd(l, r) 										      : '${f(l)} && ${f(r)}';
			case QSOr(l, r) 										      : '${f(l)} || ${f(r)}';
			case QSNot(e) 											      : '!${f(e)}';
			case QSIn(UNIVERSAL, expr, sub_exprs) 		: 'all ${f(expr)} ${f(sub_exprs)}';
			case QSIn(EXISTENTIAL, expr, sub_exprs) 	: 'any ${f(expr)} ${f(sub_exprs)}';
			case QSBinop(op, l) 							        : '${op.toString()} ${f(l)}';
			case QSUnop(EXISTS) 							        : 'existsx';
		}
	}
}