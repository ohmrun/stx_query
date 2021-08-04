package stx.query;

enum QBinopSum{
	IN;

	GT;
	LT;
	EQ;
	GTEQ;
	LTEQ;
}


abstract QBinop(QBinopSum)  from QBinopSum to QBinopSum{
	public function toString(){
		return switch this {
			case IN: 							"\\";
			
			case GT: 					    ">";
			case LT: 					    "<";
			case EQ: 					    "==";
			case GTEQ: 				    "=>";
			case LTEQ: 				    "=<";
		};
	}
}