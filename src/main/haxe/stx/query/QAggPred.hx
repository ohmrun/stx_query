package stx.query;

enum QAggPredSum{
	ANY;
	ALL;
}
abstract QSel(QAggPredSum) from QAggPredSum to QAggPredSum{
	public function new(self) this = self;
	static public function lift(self:QAggPredSum):QSel return new QSel(self);
	public function prj():QAggPredSum return this;
	private var self(get,never):QSel;
	private function get_self():QSel return lift(this);
}