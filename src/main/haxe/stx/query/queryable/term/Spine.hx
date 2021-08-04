package stx.query.queryable.term;
// class SpineQueryable<T,X> implements QueryableApi<Spine<T>,SpineQueryable<T,X>>{
// 	public var value(default,null):Option<Spine<T>>;
// 	public var error(default,null):Option<QueryFailure>;
	
// 	private function new(value:Option<Spine<T>>,error:Option<QueryFailure>){
// 		this.value = value;
// 		this.error = error;
// 	}
// 	static public function make<T,X>(value:Option<Spine<T>>,error:Option<QueryFailure>):SpineQueryable<T,X>{
// 		return new SpineQueryable(value,error);
// 	}
// 	private function recurse_or_error(fn:Void->SpineQueryable<T,X>):SpineQueryable<T,X>{
// 		return switch(error){
// 			case Some(_) : this;
// 			default 		 : fn();
// 		}
// 	}
// 	public function at(i:Int):SpineQueryable<T,X>{
// 		return recurse_or_error(() -> 
// 			switch(value){
// 				case Some(Collect(arr)) : 
// 					var v = __.option(arr[i]).map( (fn) -> fn() );
// 					if(v.is_defined()){
// 						make(v,None);
// 					}else{
// 						make(None,Some(E_Query_NullAtIndex(null,i)));
// 					}
// 				default : make(None,Some(E_Query_NullAtIndex(null,i)));
// 			}
// 		);
// 	}
// 	public function resolve(str:String):SpineQueryable<T,X>{
// 		return recurse_or_error(
// 			() -> switch(value){
// 				case Some(Collate(record)) : 
// 					var v = record.get(str).map( fn -> fn() );
// 					if(v.is_defined()){
// 						make(v,None);
// 					}else{
// 						make(None,Some(E_Query_NullAtRecord(null,str)));
// 					}
// 				default : make(None,Some(E_Query_NullAtRecord(null,str)));
// 			}
// 		);
// 	}
// 	public function extract(){
// 		return value;
// 	}
// 	public function exists(){
// 		return value.is_defined();
// 	}
// 	public function asQueryableApi():QueryableApi<Spine<T>,SpineQueryable<T,X>>{
// 		return this;
// 	}
// 	public function eq(){
// 		return stx.assert.eq.term.Spine()
// 	}
// }