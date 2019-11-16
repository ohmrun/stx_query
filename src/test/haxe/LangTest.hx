class LangTest extends Case{
  public function test(){
    var eq = Equal.getEqualFor(QEBlank).toAssertation(
			__.fault().because("structures don't match")
		);
		/*
			//item of list has a field 'f':
		*/
		var a_ = P().f.e();
		var a = QEPos(NField("f"),QEConst(QCSelf)).lift();
		eq.fire(a_,a);
		/*
			//items of list with field f equal to 2;
		*/
		var b = QEBinop(
				QBCheck(Compare(EQ)),
				QEPos(NField("f"),QEConst(QCSelf)),
				QEConst(QCPrim(PInt(2)))
			).lift();
		var b_ = Q(P().f) == 2;
		eq.fire(b,b_);
		/*
			//items of list with field f equal to field y of item of other list 'hmm'
		*/
		var c = QEBinop(
				QBCheck(Compare(EQ)),
				QEPos(NField("f"),QEConst(QCSelf)),
				QEPos(NField("y"),QEConst(QCVar(V("hmm"))))
			).lift();
		var c_ = 
			Q(P().f)
			==
			"hmm".v().e().at(
				P().y
			);
		eq(c,c_);
  }
}