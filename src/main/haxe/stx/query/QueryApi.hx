package stx.query;

interface QueryApi<T> extends ComparableApi<T>{
  public function select(val:T,key:String):Res<Option<T>,QueryFailure>;
  public function filter(val:Cluster<T>,expr:QExpr<T>):Res<Option<T>,QueryFailure>;
  public function refine(val:T,expr:QExpr<T>):Res<Option<T>,QueryFailure>;
  public function search(val:T,expr:QExpr<T>):Bool;
}