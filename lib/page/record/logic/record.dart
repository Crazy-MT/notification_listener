import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:parse_plist/parse_plist.dart';
import 'package:sqflite/sqflite.dart';

import '../model/record_model.dart';

class Record {
  var recordList = <RecordModel>[];

  Future<List<RecordModel>> getRecord(Database? database, Map<String, String> packageMap) async {
    List<Map<String, Object?>>? result = await database?.rawQuery('SELECT * FROM record');
    if(result != null) {
      for (var item in result) {
        // print('MTMTMT Record.getRecord ${item} ');
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
    file.writeAsBytesSync(imageByte);
    int date = (item['delivered_date'] as double).toInt()  + 978307200;
    Map? plist = await parsePlist.getPlist(file.path);
    if (plist != null) {
      recordList.add(RecordModel()
        ..packageId = plist['app']
        ..body = plist['req']['body']
        // ..iden = plist['req']['iden']
        ..titl = plist['req']['titl']
        ..name = packageMap[plist['app']]
        ..deliveredDate = formatDate(DateTime.fromMillisecondsSinceEpoch(date * 1000), [yyyy, '年', mm, '月', dd, '日', ' ', HH, ':', nn, ':', ss]));
    }
  }
}
