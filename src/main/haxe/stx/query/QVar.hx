package stx.query;

enum QVarDef{
	QNil;
	QIdx(sel:Int,v:QVar);
	QFld(sel:String,v:QVar);

	//QDecl(arr:Array<Field<QVar>>);//implicit EXISTS
	//QLet(key:String,val:QExpr,scope:QExpr);//QGet??
	//QPrm(prm:Primitive);
	QLit(v:Expr<Primitive>);
	//QLst(arr:LispList<QExpr>);
}
abstract QVar(QVarDef) from QVarDef to QVarDef{
	static public var _(default,never) = QVarLift;
	public function toString(){
		
		return switch this {
			//case QLst(arr)							: arr.canonical( _ -> _.toString());
			case QNil											: '<nil>';
			case QIdx(sel, expr)					: '${expr}[${sel}]';
			case QFld(sel, expr)					: 
				var rhs = __.that().alike().comply(expr.prj(),QOK).ok().if_else(
					() -> "",
					() -> '${expr}.'
				);
				'$rhs${sel}';
			// case QDecl(arr)								: 
			// 	var v = (v:QVar) -> __.that().alike().comply(v.prj(),QOK).ok().if_else(() -> "",()->':$v');
			// 	var fn = (ob:Field<QVar>) -> '${ob.key}${v(ob.val)}';
			// 	'{ ' + arr.map(fn).join(" ") +' }';
			//case QLet(key,val,scope)			: 'let($key := $val ($scope))';
			//case QPrm(PString(str))				: '"${str}"';
			case QLit(val)								: Std.string(val);
		}
	}
	@:op(A>B)			public function gt(that:QVar):QExpr						return QBin(GT,self,that);
	
 	@:op(A<B)			public function lt(that:QVar):QExpr						return QBin(LT,self,that);

	@:op(A==B)		public function eq(that:QVar):QExpr						return QBin(EQ,self,that);
	

	@:op(!A)			public function defined():QExpr								return QUn(DEFINED,self);
	public function not():QExpr																	return QUn(NOT,self);

	@:op(A.B)			public function resolve(next:String):QVar			return QFld(next,self);
	@:arrayAccess	public function at(int:Int):QVar							return QIdx(int,self);

	public var self(get,never) : QVar;
	private function get_self():QVar{
		return this;
	}
	public function prj():QVarDef return this;
	
	public function has(that:QExpr,?sel,?op):QExpr								  return QHas(__.option(sel).defv(ANY),__.option(op).defv(EQ),QVal(this),that);
	@:to public function toQExpr():QExpr{
		return QVal(this);
	}
}
class QVarLift{
	static public function exists(self:QVar){
		return true;
	}
	static public function is_defined(self:QVar){
		return self != QNil;
	}
	static public function q(obj:StdMap<String,QVar>):QVar{
		return QDecl(
				obj.keyValueIterator().toIter().map(
					(obj) -> Field.create(obj.key,obj.value)
				).toArray()
			);
	}
}