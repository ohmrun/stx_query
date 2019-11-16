package stx.query.head.data;

/*
enum Range{
  At(i:List<Int>);
  In(start:Int,end:Int);
}
*/
enum QRange{
  QROne(i:Int);
  QRMany(l:Int,h:Int);
}