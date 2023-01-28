import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:get/get.dart';
import 'package:notification_listener/util/string_extensions.dart';
import 'package:parse_plist/parse_plist.dart';
import 'package:sqflite/sqflite.dart';

import '../model/record_model.dart';

class Record {
  var recordList = <RecordModel>[];

  Future<List<RecordModel>> getRecord(Database? database, Map<String, String> packageMap) async {
    List<Map<String, Object?>>? result = await database?.rawQuery('SELECT * FROM record ORDER BY delivered_date DESC');
    if(result != null) {
      for (var item in result) {
        await parsePList(item, packageMap);
      }
    }
    return recordList;
  }

  parsePList(item, Map<String, String> packageMap) async {
    var imageByte = item['data'] as Uint8List;
    final parsePlist = ParsePlist();
    var tempDir = await parsePlist.getDocumentPath();
    var file = await File('$tempDir/a.plist').create();
    file.writeAsBytesSync(imageByte, flush: true);
    int date = ((item['delivered_date'] ?? 0.0) as double).toInt()  + 978307200;
    Map? plist = await parsePlist.getPlist(file.path);
    if (plist != null) {
      // if(!(plist['req']['titl'] is String)) {
        // print('MTMTMT titl  ${plist['req']['titl']} ${plist['app']}');
      // }
      recordList.add(RecordModel()
        ..packageId = plist['app']
        ..body = plist['req']['body']
        // ..iden = plist['req']['iden']
        ..titl = plist['req']['titl']
        ..name = packageMap[plist['app']]
        ..md5 = (date.toString() + '_' + (plist['req']['body'].toString())).toMD5()
        ..deliveredDate = formatDate(DateTime.fromMillisecondsSinceEpoch(date * 1000), [yyyy, '年', mm, '月', dd, '日', ' ', HH, ':', nn, ':', ss]));
    }
  }
}
