package stx.query.assertation;

using stx.Test;

import stx.query.Assertation;

class Test{
  static public function main(){
    __.log().info("assertation");
    __.test(
      [new AssertationTest()],
      []
    );
  }
}
class AssertationTest extends TestCase{
  public function test(){
    
  }
}