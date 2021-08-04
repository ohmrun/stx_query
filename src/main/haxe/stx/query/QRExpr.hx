package stx.query;

enum QRExprDef{
	QROK;
	QRVal(v:QLit);
	QRUn(op:QUnop,e:QLit);
	QRBin(op:QBinop,l:QLit,r:QLit);
	

	QRSeq(l:QRExpr,r:QRExpr);
	QRAlt(l:QRExpr,r:QRExpr);
	QRHas(sel:QSel,op:QBinop,l:QExpr,r:QExpr);
	
	QRNot(e:QRExpr);
}
@:forward abstract QRExpr(QRExprDef) from QRExprDef to QRExprDef{
	public function new(self) this = self;
	static public function lift(self:QRExprDef):QRExpr return new QRExpr(self);

	public function prj():QRExprDef return this;
	private var self(get,never):QRExpr;
	private function get_self():QRExpr return lift(this);

	public function value():Option<QLit>{
		return switch(this){
			case QRVal(v) : Some(v);
			default 			: None;
		}
	}
	public function exists():Bool return (this == QROK || value().is_defined());
}
