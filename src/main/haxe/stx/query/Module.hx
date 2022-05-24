package stx.query;

class Module extends Clazz{
  public function that<T>(o:T):QExpr<T>{
    return QEVal(o);
  }
}