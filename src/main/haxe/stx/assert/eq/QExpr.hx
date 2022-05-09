package stx.assert.eq;

import stx.query.QExpr in TQExpr;

class QExpr<T> extends EqCls<TQExpr<T>>{
  final inner : Eq<T>;
  public function new(inner:Eq<T>){
    this.inner = inner;
  }
  public function comply(lhs:TQExpr<T>,rhs:TQExpr<T>):Equaled{
    return switch([lhs,rhs]){
      case [QVal(l),QVal(r)]               : inner.comply(l,r);
      case [QAnd(lI,rI),QAnd(lII,rII)]     : comply(lI,lII) && comply(rI,rII);
      case [QOr(lI,rI),QOr(lII,rII)]       : comply(lI,lII) && comply(rI,rII);
      case [QNot(eI),QNot(eII)]            : comply(eI,eII);
      case [QIn(filterI,sub_exprsI),QIn(filterII,sub_exprsII)] : 
        var eq = new stx.assert.eq.QFilter().comply(filterI,filterII);
        if(eq.is_ok()){
          eq = Eq.Cluster(new QSubExpr().comply(sub_exprsI,sub_exprsII));
        }
        eq;
      case [QBinop(oI,lI),QBinop(oII,lII)] :
        var eq = new QBinop().comply(oI,oII);
        if(eq.is_ok()){
          eq = inner.comply(lI,lII);
        }
        eq;
      case [QUnop(opI),QUnop(opII)]        :
        new QUnop().comply(opI,opII);
      default : Eq.EnumValueIndex().comply(lhs,rhs);
    }
  }
}
