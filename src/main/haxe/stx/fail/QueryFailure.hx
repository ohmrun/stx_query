package stx.fail;


enum QueryFailureSum{
	E_Query_ParseFailure(f:stx.fail.ParseFailure);
	E_Query(str:String);
	E_Query_BareValue;
	E_Query_NullAtIndex(e:stx.query.QExpr<Dynamic>,i:Int);
	E_Query_NullAtRecord(e:stx.query.QExpr<Dynamic>,str:String);
}
abstract QueryFailure(QueryFailureSum) from QueryFailureSum to QueryFailureSum{
	public function new(self) this = self;
	@:noUsing static public function lift(self:QueryFailureSum):QueryFailure return new QueryFailure(self);
	
	@:noUsing static public function null_at_index(e,i):QueryFailure{
		return E_Query_NullAtIndex(e,i);
	}
	@:noUsing static public function null_at_record(e,i):QueryFailure{
		return E_Query_NullAtRecord(e,i);
	}

	public function prj():QueryFailureSum return this;
	private var self(get,never):QueryFailure;
	private function get_self():QueryFailure return lift(this);
}