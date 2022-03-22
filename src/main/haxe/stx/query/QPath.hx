package stx.query;

typedef QPathDef = Cluster<QSelect>;

abstract QPath(QPathDef) from QPathDef to QPathDef{
	public function new(self) this = self;
	static public function lift(self:QPathDef):QPath return new QPath(self);

	public function prj():QPathDef return this;
	private var self(get,never):QPath;
	private function get_self():QPath return lift(this);
}
