package stx.query;

class Methods{
  static public function P(){
    return new Path();
  }
  static public function Q(?q:QExpr){
    return q == null ? new QExpr() : q;
  }
  static public function V(name:String):Variable{
    return { name : name };
  }
}