package stx.query.term;

class Pml<T> extends stx.assert.comparable.PExpr<T>{
  final T : Comparable<T>;
  public function new(T){
    this.T = T;
  }
  public function apply(self:QExpr<PExpr<T>>){
    return switch(self){
      
    }
  }
}