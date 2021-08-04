package stx.query;

enum QExprSum{
  QOK;
  QVal(v:QVar);
  QUn(op:QUnop,e:QVar);
  QBin(op:QBinop,l:QVar,r:QVar);

  QSeq(lhs:QExpr,rhs:QExpr);
  QAlt(lhs:QExpr,rhs:QExpr);

  QHas(dep:QSel,op:QBinop,lhs:QExpr,rhs:QExpr);
}
abstract QExpr(QExprSum) from QExprSum{
 static public var _(default,never) = QExprLift;
 
 @:from static public function fromInt(int:Int):QExpr					return QVal(QLit(Value(PInt(int))));
 @:from static public function fromString(str:String):QExpr		return QVal(QLit(Value(PString(str))));

 static public function fromQVar(t:QVarDef):QExpr					    return QVal(t);

 @:op(A && B)	public function and(that:QExpr):QExpr						return QSeq(self,that);
 @:op(A || B)	public function or(that:QExpr):QExpr						return QAlt(self,that);
 public function has(that:QExpr,?sel,?op):QExpr								return QHas(__.option(sel).defv(ANY),__.option(op).defv(EQ),this,that);

 private var self(get,never):QExpr;
 private function get_self():QExpr return this;

 public function prj():QExprSum return this;
 
 public function toString():String{
   var fp = (d:Dynamic) -> Std.string(d);
   return switch this {
     case QOK								    : '*';
     case QSeq(l,r)			        : '${l} ${r}';
     case QAlt(l,r)			        : '${l} || ${r}';
     case QBin(op,l,r)				  : '${l} ${op} ${r}';
     case QUn(op,e)					    : '${op}${e}';
     case QVal(v)							  : '$v';
     case QHas(sel,op,l,r)	    : '$sel(${l}[$op:${r}])';
   }
 }
}
class QExprLift{

}