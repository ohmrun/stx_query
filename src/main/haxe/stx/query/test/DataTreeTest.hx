class DataTreeTest extends Case{
  public function test(){
    var data = DataTree.unit();
				data = data.setSet(
					Field(0,"a"),
					DataTree.unit().setVal(
						Field(0,"fst"),
						true.toPrimitive()
					)
				).setSet(
					Field(1,"b"),
					DataTree.unit().setVal(
						Index(0),
						0.toPrimitive()
					).setVal(
						Index(1),
						1.toPrimitive()
					)
				);
		var obj   = data.toObject();
    var obj0  = {
      a : {
        fst : true
      },
      b : [0,1]
    };
		Equal.getEqualFor(obj).toAssertation(
      __.fault().because("structures don't match")
    ).fire(obj,obj0);
  }
}