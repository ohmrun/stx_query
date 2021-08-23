package stx.query;

enum QBinopSum{
	GT;
	LT;
	EQ;
	GTEQ;
	LTEQ;
}


abstract QBinop(QBinopSum)  from QBinopSum to QBinopSum{
	public function toString(){
		return switch this {
			
			case GT: 					    ">";
			case LT: 					    "<";
			case EQ: 					    "==";
			case GTEQ: 				    "=>";
			case LTEQ: 				    "=<";
		};
	}
}