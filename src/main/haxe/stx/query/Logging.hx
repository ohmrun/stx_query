package stx.query;

using stx.Nano;
using stx.Log;
using stx.Pkg;

class Logging{
  static public function log(wildcard:Wildcard){
    return stx.Log.pkg(__.pkg());
  }
}