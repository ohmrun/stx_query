package stx.query;

enum QBinopSum{
	EQ;
	NEQ;
	LT;
	LTEQ;
	GT;
	GTEQ;

	LIKE;
}
@:using(stx.query.QBinop.QBinopLift)
abstract QBinop(QBinopSum) from QBinopSum to QBinopSum{
	static public var _(default,never) = QBinopLift;
	public inline function new(self:QBinopSum) this = self;
	@:noUsing static inline public function lift(self:QBinopSum):QBinop return new QBinop(self);

	public function prj():QBinopSum return this;
	private var self(get,never):QBinop;
	private function get_self():QBinop return lift(this);
}
class QBinopLift{
	static public inline function lift(self:QBinopSum):QBinop{
		return QBinop.lift(self);
	}
	static public function toString(self:QBinop):String{
		return switch(self){
			case EQ		: "==";
			case NEQ 	: "!=";
			case LT 	: "<";
			case LTEQ : "<=";
			case GT 	: ">";
			case GTEQ : ">=";
			case LIKE : "~";
		}
	}
}