package stx.query;

using stx.Test;

import stx.assert.eq.QBinop;
import stx.assert.eq.QExpr;
import stx.assert.eq.QFilter;
import stx.assert.eq.QSubExpr;
import stx.assert.eq.QUnop;

import stx.assert.ord.QBinop;
import stx.assert.ord.QExpr;
import stx.assert.ord.QFilter;
import stx.assert.ord.QSubExpr;
import stx.assert.ord.QUnop;

class Test {
  static public function main(){
    __.test(
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