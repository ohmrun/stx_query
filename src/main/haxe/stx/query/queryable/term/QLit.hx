package stx.query.queryable.term;

typedef QLitDef = QueryableApi<QLit,QLitDef>;

class QLitCls implements QLitDef{
	public var value(default,null):Chunk<QLit,QueryFailure>;
	private function new(value:Chunk<QLit,QueryFailure>){
		this.value = value;
	}
	static public function make(value:Chunk<QLit,QueryFailure>):QLitDef{
		return new QLitCls(value);
	}
	public function at(int:Int):QLitDef{
		var fail = (e,?pos:Pos) -> make(End(__.fault().of(QueryFailure.null_at_index(e,int))));

		return switch(value){
			case Val(Group(ls)) : 
				var value = __.option(ls.toArray()[int]).toChunk();
				value.is_defined().if_else(
					() -> make(value),
					() -> fail(QVar(QVal(Group(ls))))
				);
			default : fail(null);
		}
	}
	public function resolve(str:String):QLitDef{
		var fail = (?pos:Pos) -> make(End(__.fault().of(QueryFailure.null_at_record(null,str))));

		return switch(value){
			case Val(Group(ls)) : 
				var value = ls.toArray().map_filter(
					(ls:QLit) -> switch(ls){
						case Label(s) 										 			if(s == str)		: Some(Tap);//exists but not defined
						case Value(PString(s))						 			if(s == str)		: Some(Tap);// ''
						case Group(Cons(Value(PString(s)),xs)) 	if(s == str)		: Some(Val(Group(xs)));//TODO finer
						case Group(Cons(Label(s),xs))      			if(s == str)		: Some(Val(Group(xs)));
						default 																								: None;
					}
				).head();

				return value.is_defined().if_else(
					() -> make(value.toChunk().flatten()),
					() -> fail()
				);
			default : fail();
		}
	}
	public function exists() 	return this.value.fold((_) -> true,		(_) -> false,()		-> true);
	public function extract() return this.value.fold((v) -> Some(v),(_)	-> None, () 	-> None);
	public function lt() 	return Expr._.lt(Ord.Primitive());
	public function eq()	return Expr._.eq(Eq.Primitive());
	public function asQueryableApi() return this;
}
class QLitDefLift{	
  static public function eval(state:QLitDef,v:QExpr):QRExpr{
		var comp = new stx.assert.comparable.term.Expr(Comparable.Primitive());
		var from_bool = (b:Bool) -> b.if_else(()-> QROK, ()->QRNot(QROK));

		return switch(v){
			case QVar(QVal(e)) 				: QRVar(val(e));
			case QUn(EXISTS,e)				: from_bool(eval(state,QVar(e)).exists());
			case QUn(DEFINED,e)				: from_bool(eval(state,QVar(e)).value().is_defined());
			case QBin(EQ,l,r)					: 
				var lhs = deref(state,l);
				var rhs = deref(state,r);
				from_bool(comp.eq().comply(lhs,rhs).ok());
			case QBin(GT,l,r)					: 
				var lhs = deref(state,l);
				var rhs = deref(state,r);
				from_bool(comp.lt().comply(rhs,lhs).ok());
			case QBin(GTEQ,l,r)				: 
				var lhs = deref(state,l);
				var rhs = deref(state,r);
				from_bool(comp.lt().comply(rhs,lhs).ok() || comp.eq().comply(lhs,rhs).ok());

			case QBin(LT,l,r)					: 
				var lhs = deref(state,l);
				var rhs = deref(state,r);
				from_bool(comp.lt().comply(lhs,rhs).ok());
			case QBin(LTEQ,l,r)				: 
				var lhs = deref(state,l);
				var rhs = deref(state,r);
				from_bool(comp.lt().comply(lhs,rhs).ok() || comp.eq().comply(lhs,rhs).ok());

			case QAlt(l,r)						: 
				var lhs = eval(state,l);
				if(!lhs){ eval(state,r); }else{ true }
			case QSeq(l,r)						: 
				eval(state,l) && eval(state,r);
			case QNil									:
				QROK;
		}
	}
	static public function deref(state:QLitDef,e:QVar):QLit{
		return switch(e){
			case QIdx(sel,v) 										: deref(state.at(sel),v);
			case QFld(sel,v) 										: deref(state.resolve(sel),v);
			case QDecl(arr) 										: 
				(Group(LinkedList.fromArray(arr.map(
					(field:Field<QVar>) -> field.map(x -> deref(state,x))
				).map_filter(
					(field) -> field.snd().exists() ? Some(field.map(x -> x.extract())) : None
				).map(
					(field) -> Group(Cons(Label(field.fst()),Cons(field.snd().defv(Empty),Nil)))
				))));
			case QVal(v) 												: v;
		}
	}
}