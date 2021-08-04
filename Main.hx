import haxe.macro.Expr.Binop;

import stx.query.Module.*;

using stx.Nano;
using stx.Query;
using stx.Log;


class Main {
	static var q  = __.query();
	static var _  = q._;

	static function main() {
		first();
		second();
		third();
		fourth();
		fifth();
		//sixth();
	}
	static function first(){
		var q = __.query();
		var _ = q._;
		var query =
			[
				"four" => _,
				'dopt' => _,
				"tubE" => [
					"ingrain" => _,
					"Sc%=sd"	=> _,
					'JAGGED' 	=> [
						'to' 	=> _,
						'fu'	=> _
					].q(),
					"SNUUU" => _.first.has(q.v(3) > _.a.b.c)
				].q()
			].q();
		trace(query);
		// trace(__.show(query));
	}
	static function second(){
		//var a = _.first[_.i > 2];
		var a = _.first.has(_.i);
		var a : QExpr = _.first.has(q.v(3) > _.a.b.c);
		///trace(__.show(a));
		trace(a.toString());
	}
	static function third(){
		var a = q.v(3);
		trace(a);
	}
	static function fourth(){
		var hmm = ([
			"tubE" => ([
				"ingrain" => _,
				"Sc%=sd" => _,
				'JAGGED' => (['to' => _,'fu' => _]).q()
			]).q()
		]).q();
		trace(hmm);
	}
	static function fifth(){
		var a = _.a.b;
		trace(a);
		var b = (a == __.query().v("hello"));
		trace(b);
		//var c = 
		//__.that().equals().fire("a.b",a.toString());
	}
	// static function sixth(){
	// 	var data = [
	// 		{},
	// 		{},
	// 		{
	// 			sub_arr : [

	// 			]
	// 		}
	// 	];
	// 	var expr = _.sub_arr.has(
	// 		(_.test).not(),ALL
	// 	);
	// 	function fun(y:Y<QExpr,Void>){
	// 		return (expr:QExpr) -> {
	// 			var f = y(fun);
	// 			trace(expr);
	// 			switch(expr){
	// 				case QOK					: 
	// 				case QVal(v)			: switch(v){
	// 					case QIdx(sel,expr)				:
	// 					case QFld(sel,expr) 			: 	
	// 					case QDecl(arr)						:
	// 					//case QLet(key,val,scope) 	: 
	// 					case QLit(prm) 						: 
	// 					case QNil 								:
	// 				}
	// 				case QUn(op,e)							: 
	// 				case QBin(op,l,r)						: 
	// 				case QAlt(l,r)							:
	// 				case QSeq(l,r)							:
	// 				case QHas(sel,op,lhs,rhs)		:
	// 			}
	// 			f(expr);
	// 		}
	// 	}
	// 	var y = Y.lift(fun);
	// 	QExpr._.traverse().reverse(y)(expr);
	// }
}
class LiftStringMapQExprToQExpr{
	
}
