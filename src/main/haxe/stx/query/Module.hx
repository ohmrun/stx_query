package stx.query;

class Module extends Clazz{
  //value
  public function v(p:Primitive):QVar{
		return QLit(Value(p));
  }
  //variable
	//public function x(key:String,val:QExpr,scope:QExpr):QExpr{
		//return QExpr.fromQVar(QLet(key,val,scope));
  //}
  public var _ : QVar = QNil;
}