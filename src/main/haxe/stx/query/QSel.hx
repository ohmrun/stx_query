package stx.query;

enum QSelSum{
	ANY;
	ALL;
}
abstract QSel(QSelSum) from QSelSum to QSelSum{
	public function new(self) this = self;
	static public function lift(self:QSelSum):QSel return new QSel(self);
	public function prj():QSelSum return this;
	private var self(get,never):QSel;
	private function get_self():QSel return lift(this);
}