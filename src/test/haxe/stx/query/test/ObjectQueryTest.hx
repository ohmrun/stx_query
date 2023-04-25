package stx.query.test;

import stx.query.term.object.ObjectQueryCls;

class ObjectQueryTest extends TestCase{
  public function ctr(){
    return new ObjectQueryCls();
  }
  public function test_val_eq_true(){
    final v   = Primate(PSprig(Byteal(NInt((1)))));
    final l   = QExpr.Eq(v);
    final res = ctr().search(v,l);
    is_true(res);
  }
  public function test_val_eq_false(){
    final v   = Primate(PSprig(Byteal(NInt((1)))));
    final vI  = Primate(PSprig(Byteal(NInt((2)))));
    final l   = QExpr.Eq(vI);
    final res = ctr().search(v,l);
    is_false(res);
  }
  public function test_val_gt_true(){
    final v   = Primate(PSprig(Byteal(NInt((3)))));
    final vI  = Primate(PSprig(Byteal(NInt((2)))));
    final l   = QExpr.Gt(vI);
    final res = ctr().search(v,l);
    is_true(res);
  }
}