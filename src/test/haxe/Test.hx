package;

class Test extends stx.test.pack.Test{
  public function new(){
    super(
      [
        new LangTest().tests,
        new DataTreeTest().tests,
				new SenseTest().tests  
      ]
    );
  }
}
class SenseTest extends Case{

}