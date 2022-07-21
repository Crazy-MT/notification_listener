import 'dart:io';

import 'package:parse_plist/parse_plist.dart';

import '../model/app_model.dart';

class App {
  /// Application 目录下 app 的信息
  var appList = <AppModel>[];

  /// db 目录下 app 的信息
  Map<String, int> appMap = {};

  /// app 名称与包名的映射
  Map<String, String> packageMap = {};

  List<Map<String, Object?>>? result;

  Future<List<AppModel>> initDB(database) async {
    await allApp(database);
    await appPList();

    appList.sort((a, b) => a.name.compareTo(b.name));
    return appList;
  }

  Future<void> allApp(database) async {
    result = await database?.rawQuery('SELECT * FROM app');
    for (var item in result!) {
      var id = (item['identifier'] as String).trim();
      appMap[id] = item['app_id'] as int;
    }
  }

  appPList() async {
    var applications = Directory("/Applications");
    for (var application in applications.listSync()) {
      if (application.path.endsWith(".app")) {
        var filePath = '${application.path}/Contents/Info.plist';
        var appName = application.path.split("/").last;
        if (await File(filePath).exists()) {
          var plist = await ParsePlist().getPlist(filePath);
          if (plist != null) {
            var id =
                plist['CFBundleIdentifier'].toString().trim().toLowerCase();
            var appModel = AppModel()
              ..name = appName
              ..bundleId = plist['CFBundleIdentifier']
              ..appId = appMap[id] ?? 0;
            appList.add(appModel);
            packageMap[plist['CFBundleIdentifier']] = appName;
          }
        }
      }
    }
  }
}
