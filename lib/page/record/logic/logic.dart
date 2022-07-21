import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../../util/exec_shell.dart';
import 'app.dart';
import '../model/app_model.dart';
import '../model/record_model.dart';
import 'record.dart';

class NotificationLogic extends GetxController {
  Database? database;

  var appLike = <String, bool>{};
  var appList = <AppModel>[].obs;
  var dbAppList = <Map>[].obs;
  var recordList = <RecordModel>[].obs;
  var app = App();

  NotificationLogic() {
    initDB();
  }

  Future<void> initDB() async {
    List<ProcessResult>? result = await ExecShell().execShell('''
    getconf DARWIN_USER_DIR
     ''');
    var notificationPath = "";
    if (result != null && result.isNotEmpty) {
      notificationPath = result.first.stdout.trim();
    }
    print('MTMTMT BuildApkLogic.initDB ${notificationPath} ');
    database = await openDatabase("${notificationPath}com.apple.notificationcenter/db2/db");
    await appFromDB();

    Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      print('MTMTMT NotificationLogic.initDB ${timer} ');
      if(database != null) {
        await notificationFromDB();
      }
    });
  }

  notificationFromDB() async {
    recordList.value = await Record().getRecord(database, app.packageMap);
  }

  appFromDB() async {
    appList.value = await app.initDB(database);
    for(var item in appList.value) {
      appLike[item.name] = false;
    }
    dbAppList.value = app.result!;
  }

  updateAppList() {
    for(var item in appList.value) {
      item.isLike = appLike[item.name] ?? false;
    }
    appList.refresh();
    recordList.refresh();
  }
}
