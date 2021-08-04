package stx;


typedef Module 					= stx.query.Module;

typedef QueryFailureSum = stx.fail.QueryFailure.QueryFailureSum;
typedef QueryFailure 		= stx.fail.QueryFailure;

typedef QVarDef 				= stx.query.QVar.QVarDef;
typedef QVar 						= stx.query.QVar;

typedef QExprSum 				= stx.query.QExpr.QExprSum;
typedef QExpr 					= stx.query.QExpr;

typedef QBinopSum 		= stx.query.QBinop.QBinopSum;
typedef QBinop 				= stx.query.QBinop;

typedef QAggSum 			= stx.query.QAgg.QAggSum;
typedef QAgg 					= stx.query.QAgg.QAggSum;

typedef QSelSum 			= stx.query.QSel.QSelSum;
typedef QSel 					= stx.query.QSel;

typedef QUnopSum 			= stx.query.QUnop.QUnopSum;
typedef QUnop 				= stx.query.QUnop;

typedef QueryLift 		= stx.query.QueryLift;


class Mixin extends Clazz{}

interface ResolvableApi<T>{
	public function resolve(str:String):T;
}
interface ArrayAccessibleApi<T>{
	public function at(i:Int):T;
}
interface ExtractableApi<T>{
	public function extract():Option<T>;
	public function exists():Bool;
}
interface SourceableApi<T> extends ComparableApi<T> extends ExtractableApi<T>{}

interface QueryableApi<T,X:QueryableApi<T,X>>
	extends SourceableApi<T>
	extends ResolvableApi<X>
	extends ArrayAccessibleApi<X>
{
	public function asQueryableApi():QueryableApi<T,X>;
}
typedef QLit = stx.query.QLit;

typedef QRExprDef = stx.query.QRExpr.QRExprDef;
typedef QRExpr 		= stx.query.QRExpr;

typedef ExtractableRExpr = ExtractableApi<QRExpr>;
class ExtractableRExprCls implements ExtractableRExpr{
	static public var _(default,never) = ExtractableRExprClsLift;
	public var value(default,null):Chunk<QRExpr,QueryFailure>;
	public function new(value){
		this.value = value;
	}
	static public function make(value){ return new ExtractableRExprCls(value); }

	public function exists() 	return this.value.fold((_) 	-> true,(_) 	-> false,()	 	-> true);
	public function extract() return this.value.fold((v)		-> Some(v),(_)		-> None,() 		-> None);
	
	/*
	public function derive(e:QRExpr):ExtractableRExprCls{
		return switch(e){
			case QROK			: make(Tap);
			case QRVar(v) : make(Val(v));
			case QRUn(e)  : make(Val(v));
			case QRBin(op:QBinop,l:QRExpr,r:QRExpr);
		}
	}*/
	// public function apply(self:QExpr){
	// 	return switch(self){
	// 		case QRBin(op,lhs,rhs) 					 	: binop(op)(lhs,rhs);
	// 		case QRUn(op,e)										: unop(op)(e);
	// 		case QAlt(l,r)										: apply(l) || apply(r);
	// 		case QSeq(l,r)										: apply(l) && apply(r);
	// 		case QROK													: true;
	// 		default 													: false;
	// 	}
	// }
	// public function unop(op:QExpr){
	// 	return switch(op){
	// 		case EXISTS 						: (e:QVar) -> QVar._.exists(e);
	// 		case DEFINED						: (e:QVar) -> QVar._.is_defined(e);
	// 		case NOT								: (e:QVar) -> !apply(e);
	// 	}
	// }
	// public function binop(op:QBinop):QLit->QLit->Bool{
	// 	return switch(op){
	// 		case EQ 					: eq;
	// 		case GT  					: gt;
	// 		case GTEQ  				: gteq;
	// 		case LT  					: lt;
	// 		case LTEQ  				: lteq;
	// 	}
	// }
	public function defined() return extract().is_defined(); 

	public function eq(lhs:QLit,rhs:QLit){
		return _.Eq().comply(lhs,rhs).ok();
	}
	public function gt(lhs:QLit,rhs:QLit){
		return lt(rhs,lhs);
	}
	public function gteq(lhs:QLit,rhs:QLit){
		return eq(lhs,rhs) || lt(rhs,lhs);
	}	
	public function lt(lhs:QLit,rhs:QLit){
		return _.Ord().comply(lhs,rhs).ok();
	}
	public function lteq(lhs:QLit,rhs:QLit){
		return lt(lhs,rhs) || eq(lhs,rhs);
	}	
	public function seq(lhs:QLit,rhs:QLit){
		return null;//apply(lhs) && apply(rhs);
	}

	public function alt(lhs:QLit,rhs:QLit){
		return null;//apply(lhs) || apply(rhs);
	}
	
	public function any(op:QLit->QLit->Bool,lhs:QLit,rhs:QLit){
		return switch(lhs){
			case Group(ls) 				: ls.toArray().any(op.bind(_,rhs));
			default 							: false;
		}
	}
	public function all(op:QLit->QLit->Bool,lhs:QLit,rhs:QLit){
		return switch(lhs){
			case Group(ls) 				: ls.toArray().all(op.bind(_,rhs));
			default 							: false;
		}
	}

	public function avg(self:QVar){}
	public function count(self:QRExpr){}
	
	public function min(self:QVar){}
	public function max(self:QVar){}
	public function sum(self:QVar){}

	public function not(self:QVar){}
}
class ExtractableRExprClsLift{
	static public function Eq(){
		return new stx.assert.eq.term.Expr(stx.assert.Eq.Primitive());
	}
	static public function Ord(){
		return new stx.assert.ord.term.Expr(stx.assert.Ord.Primitive());
	}
}