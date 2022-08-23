package stx.query;

using stx.Test;

import stx.assert.query.eq.QBinop;
import stx.assert.query.eq.QExpr;
import stx.assert.query.eq.QFilter;
import stx.assert.query.eq.QSubExpr;
import stx.assert.query.eq.QUnop;

import stx.assert.query.ord.QBinop;
import stx.assert.query.ord.QExpr;
import stx.assert.query.ord.QFilter;
import stx.assert.query.ord.QSubExpr;
import stx.assert.query.ord.QUnop;

class Test {
  static public function main(){
    __.test().run(
      [
        new QueryTest()
      ],
      []
    );
  }
}

class QueryTest extends TestCase{
  public function test(){
    
  }
}