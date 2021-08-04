package stx.query;

enum QUnopSum{
	EXISTS;
	DEFINED;
	AGG(def:QAggSum);
	NOT;
}
abstract QUnop(QUnopSum) from QUnopSum{
	public function toString(){
		return switch this {
			case EXISTS		: "@?";//key is present but may be null
			case DEFINED	: "$?";//value has been defined
			case AGG(def)	: '$def';	
			case NOT 			: "^";
		}
	}
}