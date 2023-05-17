package stx.query;

/**
 * API to query and morph a value of type `T`.
 */
interface QueryApi<T> extends ComparableApi<T>{
  /**
   * key on object
   * @param val 
   * @param key 
   * @return Upshot<Option<T>,QueryFailure>
   */
  public function select(val:T,key:String):Upshot<Option<T>,QueryFailure>;
  /**
   * values matching expression in collection
   * @param val 
   * @param expr 
   * @return Upshot<Option<T>,QueryFailure>
   */
  public function filter(val:Cluster<T>,expr:QExpr<T>):Upshot<Cluster<T>,QueryFailure>;
  /**
   * only values matching expression
   * @param val 
   * @param expr 
   * @return Upshot<Option<T>,QueryFailure>
   */
  public function refine(val:T,expr:QExpr<T>):Upshot<Option<T>,QueryFailure>;
  /**
   * evaluate the truth of expression `expr` over `val`
   * @param val 
   * @param expr 
   * @return Bool
   */
  public function assess(val:T,expr:QExpr<T>):Bool;
}