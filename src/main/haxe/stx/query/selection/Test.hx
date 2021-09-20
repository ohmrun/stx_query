package stx.query.selection;

using stx.Test;

import stx.query.Selection;

class Test{
  static public function main(){
    __.log().info("selection");
    __.test(
      [new SelectionTest()],
      []
    );
  }
}
class SelectionTest extends TestCase{
  public function test(){
    
  }
}