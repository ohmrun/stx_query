package stx.query.term.object.test;

import stx.query.term.object.ObjectQueryCls;

class ObjectQueryTest extends TestCase{
  public function ctr(){
    return new ObjectQueryCls();
  }
  public function test_val_eq_true(){
    final v   = Primate(PSprig(Byteal(NInt((1)))));
    final l   = __.query().that().Eq(v);
    final res = ctr().assess(v,l);
    is_true(res);
  }
  public function test_val_eq_false(){
    final v   = Primate(PSprig(Byteal(NInt((1)))));
    final vI  = Primate(PSprig(Byteal(NInt((2)))));
    final l   = __.query().that().Eq(vI);
    final res = ctr().assess(v,l);
    is_false(res);
  }
  public function test_val_gt_true(){
    final v   = Primate(PSprig(Byteal(NInt((3)))));
    final vI  = Primate(PSprig(Byteal(NInt((2)))));
    final l   = __.query().that().Gt(vI);
    final res = ctr().assess(v,l);
    is_true(res);
  }
}