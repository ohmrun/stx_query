package stx.query;

enum QSubExprSum<T>{
  QSQExpr(result:QExpr<T>);

	QSAnd(l:QSubExpr<T>,r:QSubExpr<T>);
	QSOr(l:QSubExpr<T>,r:QSubExpr<T>);
	QSNot(e:QSubExpr<T>);

	QSBinop(op:QBinop,l:T);
	QSUnop(op:QUnop);
}
abstract QSubExpr<T>(QSubExprSum<T>) from QSubExprSum<T> to QSubExprSum<T>{
  public function new(self) this = self;
  static public function lift<T>(self:QSubExprSum<T>):QSubExpr<T> return new QSubExpr(self);

  public function prj():QSubExprSum<T> return this;
  private var self(get,never):QSubExpr<T>;
  private function get_self():QSubExpr<T> return lift(this);
}