package stx.query.term.object;

using stx.om.Spine;
using stx.Query;
using stx.Log;

import stx.query.term.object.test.*;

class Test{
  static public function main(){
    __.logger().global().configure(
      logger -> logger.with_logic(
        logic -> logic.or(
          logic.tags([])
        )
      )
    );
    __.test().run([
      //new ObjectQueryTest(),
      //new WriteTest(),
      new ApplyTest()
    ],[]);
  }
}
class WriteTest extends TestCase{
  public function test(){
    // final _     = __.query().that();
    // final q    = _.Id().data.length;
    // //final qI   = _.Of("_").data.length;
    // //_.Gt(Primate(0)));
    // //final qII   = _.Of("_.meta.type_name",_.Eq(Primate("String")));
    // //final qIII  = qI.and(qII);
    // //$type(qIII);
    // trace(qI.toStringWith(x -> '$x'));
  }
}