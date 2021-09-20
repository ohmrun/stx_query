package stx.query;

enum QAggPredSum{
	ANY;
	ALL;
}
abstract QAggPred(QAggPredSum) from QAggPredSum to QAggPredSum{
	public function new(self) this = self;
	static public function lift(self:QAggPredSum):QAggPred return new QAggPred(self);
	public function prj():QAggPredSum return this;
	private var self(get,never):QAggPred;
	private function get_self():QAggPred return lift(this);
}