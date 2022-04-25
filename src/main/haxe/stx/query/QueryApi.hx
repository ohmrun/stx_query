package stx.query;

interface QueryApi<T> extends ComparableApi<T>{
  public function exists(t:T):Bool;
}