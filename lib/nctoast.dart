///
///Author: YoungChan
///Date: 2019-12-10 15:13:10
///LastEditors: YoungChan
///LastEditTime: 2019-12-10 15:52:35
///Description: file content
///
library nctoast;

import 'dart:async';
import 'package:flutter/material.dart';
import 'nc_toast_view.dart';
import 'nc_loading_dialog.dart';

Future Function() globalFunc;
bool dialogRequestFinished = false;

///显示异步加载中UI
/// 参数 f 执行异步的操作
/// 如果使用了 scaffoldKey, 优先使用scaffoldKey
/// 为了防止页面重刷造成context 改变
Future<T> ncShowProgressing<T>(BuildContext context, Future<T> Function() f,
    {String text = "正在加载", bool simpleMode = false}) async {
  if (f != globalFunc) {
    print("Reset global dialog func");
    globalFunc = f;
    dialogRequestFinished = false;
  } else {
    print("global dialog status: $dialogRequestFinished");
    if (!dialogRequestFinished) {
      return Future.error('已经发起请求，请勿重复操作');
    }
  }
  var c = Completer<T>();
  var dismissed = false;
  showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return SafeArea(
          child: NCLoadingDialog<T>(
            loadData: f,
            simpleMode: simpleMode,
            onLoadResult: (data, err) {
              if (!dismissed) {
                Navigator.of(context).pop();
              }
              if (err == null) {
                dialogRequestFinished = true;
                c.complete(data);
              } else {
                c.completeError(err);
              }
            },
            text: text,
          ),
        );
      },
      barrierColor: Colors.black12.withAlpha(1),
      barrierDismissible: true,
      barrierLabel: 'TalkBack',
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (context, animation, secondAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      }).then((_) {
    dismissed = true;
  });
  return c.future;
}

///显示toast
void ncShowToast(BuildContext context, String text) {
  NCToast.show(context, text);
}
