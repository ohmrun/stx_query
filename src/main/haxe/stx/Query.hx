package stx;

typedef QBinop 					= stx.query.QBinop;
typedef QExpr<T> 				= stx.query.QExpr<T>;
typedef QExprSum<T> 		= stx.query.QExpr.QExprSum<T>;
typedef QSubExpr<T> 		= stx.query.QSubExpr<T>;
typedef QSubExprSum<T> 	= stx.query.QSubExpr.QSubExprSum<T>;
typedef QFilter 				= stx.query.QFilter;
typedef QPath 					= stx.query.QPath;
typedef QPathDef  			= stx.query.QPath.QPathDef;
typedef QSelect 				= stx.query.QSelect;
typedef QSelectSum  		= stx.query.QSelect.QSelectSum;
typedef QUnop 					= stx.query.QUnop;
typedef QueryApi<T>     = stx.query.QueryApi<T>;
class Query{
  static public function query(wildcard:Wildcard){
    return new stx.query.Module();
  }  
}
