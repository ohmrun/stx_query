package stx.query;

class Module extends Clazz{
  public function that(){
    return new stx.query.QExpr.QExprCtr();
  }
}