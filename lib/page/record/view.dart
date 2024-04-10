import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_listener/page/record/logic/push_provider.dart';

import '../../util/S.dart';
import 'logic/logic.dart';

class NotificationPage extends StatelessWidget {
  final logic = Get.put(NotificationLogic());

  NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                // Expanded(child: buildApp()),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, top: 18),
                    child: buildAppInfo(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 18, top: 18),
              child: buildRecord(),
            ),
          ),
        ],
      ),
    );
  }

  Obx buildAppInfo() {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              // SizedBox(width: 100, child: SelectableText('id')),
              SizedBox(width: 200, child: SelectableText('应用名',style: S.textStyles.title)),
            ],
          ),
          Expanded(
            child: ListView(
                controller: ScrollController(),
                shrinkWrap: true,
                children: logic.appList.map((element) {
                  var style = S.textStyles.black;
                  if(element.isLike) {
                    style = S.textStyles.red;
                  }
                  return Row(
                    children: [
/*                      SizedBox(
                          width: 100,
                          child: SelectableText(element.appId.toString(),
                              style: style)),*/
                      SizedBox(
                          width: 200,
                          child: SelectableText(element.name.toString(),
                              style: style)),
                      const SizedBox(width: 20),
                      // SizedBox(
                      //     width: 200,
                      //     child:
                      //         SelectableText(element.bundleId, style: style)),
                      TextButton(onPressed: () {
                        logic.appLike[element.name] = !(logic.appLike[element.name] ?? false);
                        logic.updateAppList();
                      }, child: element.isLike ? Text("取消关注", style: style,) : Text("特别关注", style: style,)),

                    ],
                  );
                }).toList()),
          ),
        ],
      );
    });
  }

  Obx buildApp() {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: const [
              SizedBox(width: 100, child: SelectableText('app_id')),
              SizedBox(width: 20),
              SizedBox(width: 200, child: SelectableText('identifier')),
            ],
          ),
          Expanded(
            child: ListView(
                controller: ScrollController(),
                shrinkWrap: true,
                children: logic.dbAppList.map((element) {
                  var style = S.textStyles.black;
                  return Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: SelectableText(element["app_id"].toString(),
                              style: style)),
                      SizedBox(
                          // width: 200,
                          child: SelectableText(
                              element["identifier"].toString(),
                              style: style)),
                      const SizedBox(width: 20),
                    ],
                  );
                }).toList()),
          ),
        ],
      );
    });
  }

  Obx buildRecord() {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              SizedBox(width: 100, child: Text('应用名', style: S.textStyles.title,)),
              SizedBox(width: 100, child: SelectableText('标题', style: S.textStyles.title)),
              SizedBox(width: 200, child: SelectableText('内容', style: S.textStyles.title)),
              SizedBox(width: 200, child: SelectableText('包名', style: S.textStyles.title)),
              SizedBox(width: 100, child: SelectableText('接收时间', style: S.textStyles.title))
            ],
          ),
          Expanded(
            child: ListView(
                controller: ScrollController(),
                shrinkWrap: true,
                children: logic.recordList.map((element) {
                  var style = S.textStyles.black;
                  if(logic.appLike[element.name] ?? false) {
                    style = S.textStyles.red;
                    // print('MTMTMT NotificationPage.buildRecord ${element.toString()} ');
                    // PushProvider().push(element.md5, "${element.deliveredDate}  ${element.name}   ${element.titl}   ${element.body}");
                  }
                  return Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: SelectableText(element.name ?? "",
                              style: style)),
                      SizedBox(
                          width: 100,
                          child:
                              SelectableText((element.titl ?? "").toString(), style: style)),
                      SizedBox(
                          width: 200,
                          child: SelectableText((element.body.toString()) ?? "无",
                              style: style)),
                      SizedBox(
                          width: 200,
                          child: SelectableText(element.packageId.toString(),
                              style: style)),
                      // SizedBox(
                      //     width: 100,
                      //     child: SelectableText(element.iden.toString(),
                      //         style: style)),
                      SizedBox(
                          // width: 100,
                          child: SelectableText(
                              element.deliveredDate.toString(),
                              style: style))
                    ],
                  );
                }).toList()),
          ),
        ],
      );
    });
  }
}
