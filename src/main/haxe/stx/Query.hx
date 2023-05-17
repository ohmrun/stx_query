package stx;

using stx.Nano;

typedef QBinopSum 					                              = stx.query.QBinop.QBinopSum;
typedef QBinop 					                                  = stx.query.QBinop;
typedef QExpr<T = haxe.ds.Option<stx.pico.Nada>> 				  = stx.query.QExpr<T>;
typedef QExprSum<T = haxe.ds.Option<stx.pico.Nada>>       = stx.query.QExpr.QExprSum<T>;
typedef QSubExpr<T> 		                                  = stx.query.QSubExpr<T>;
typedef QSubExprSum<T> 	                                  = stx.query.QSubExpr.QSubExprSum<T>;
typedef QSubExprCtr 	                                    = stx.query.QSubExpr.QSubExprCtr;
typedef QFilter 				                                  = stx.query.QFilter;
typedef QPath 					                                  = stx.query.QPath;
typedef QPathDef  			                                  = stx.query.QPath.QPathDef;
typedef QSelect 				                                  = stx.query.QSelect;
typedef QSelectSum  		                                  = stx.query.QSelect.QSelectSum;
typedef QUnop 					                                  = stx.query.QUnop;
typedef QueryApi<T>                                       = stx.query.QueryApi<T>;
typedef QVal<T>                                           = stx.query.QVal<T>;
typedef QValSum<T>                                        = stx.query.QVal.QValSum<T>;

class Query{
  static public function query(wildcard:Wildcard){
    return new stx.query.Module();
  }  
}
