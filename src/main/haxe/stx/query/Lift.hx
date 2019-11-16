package stx.query;

import stx.query.head.data.QExpr in QExprT;

class Lift{
  static public function v(x:String):Variable{
    return { name : x };
  }
  static public function lift(e:QExprT):QExpr{
    return e;
  }
}