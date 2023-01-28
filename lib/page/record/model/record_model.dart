class RecordModel {
  var packageId;
  var body;
  var titl;
  var iden;
  var deliveredDate;
  var md5;
  var name;

  @override
  String toString() {
    return "name:$name;body:$body;title:${titl.toString()};iden:$iden;deliveredDate:$deliveredDate;md5:$md5;packageId:$packageId";
  }
}