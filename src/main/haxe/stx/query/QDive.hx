package stx.query;

typedef QDiveDef<T> = Cluster<QGather<T>>;

abstract QDive<T>(QDiveDef<T>) from QDiveDef<T> to QDiveDef<T>{
	public function new(self) this = self;
	static public function lift<T>(self:QDiveDef<T>):QDive<T> return new QDive(self);

	public function prj():QDiveDef<T> return this;
	private var self(get,never):QDive<T>;
	private function get_self():QDive<T> return lift(this);
}