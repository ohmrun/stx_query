package stx.assert.query.eq;

import stx.query.QSubExpr in TQSubExpr;

class QSubExpr<T> extends EqCls<TQSubExpr<T>>{
  final delegate : Eq<T>;
  public function new(delegate:Eq<T>){
    this.delegate = delegate;
  }
  public function comply(lhs:TQSubExpr<T>,rhs:TQSubExpr<T>):Equaled{
    return switch([lhs,rhs]){
      case [QSAnd(lI,rI),QSAnd(lII,rII)]     : comply(lI,lII) && comply(rI,rII);
      case [QSOr(lI,rI),QSOr(lII,rII)]       : comply(lI,lII) && comply(rI,rII);
      case [QSNot(eI),QSNot(eII)]            : comply(eI,eII);
      case [QSBinop(oI,lI),QSBinop(oII,lII)] :
        var eq = new stx.assert.query.eq.QBinop().comply(oI,oII);
        if(eq.is_ok()){
          eq = delegate.comply(lI,lII);
        }
        eq;
      case [QSUnop(opI),QSUnop(opII)]        :
        new stx.assert.query.eq.QUnop().comply(opI,opII);
      default : Eq.EnumValueIndex().comply(lhs,rhs);
    }
  }
}