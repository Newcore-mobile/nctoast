///
///Author: YoungChan
///Date: 2019-05-28 19:03:08
///LastEditors: YoungChan
///LastEditTime: 2019-12-10 15:50:50
///Description: 加载对话框
///

import 'package:flutter/material.dart';

enum _NCLoadingStatus { loading, success, fail }

class NCLoadingDialog<T> extends StatefulWidget {
  final Future<T> Function() loadData;
  final void Function(T data, dynamic err) onLoadResult;
  final String text;

  /// 简易模式，不显示成功/失败的状态
  final bool simpleMode;
  NCLoadingDialog(
      {@required this.loadData,
      this.onLoadResult,
      this.text = "正在加载",
      this.simpleMode = false})
      : assert(loadData != null);

  @override
  _NCLoadingDialogState createState() =>
      _NCLoadingDialogState<T>(onLoadResult: onLoadResult);
}

class _NCLoadingDialogState<T> extends State<NCLoadingDialog> {
  final void Function(T data, dynamic err) onLoadResult;
  _NCLoadingDialogState({this.onLoadResult});
  _NCLoadingStatus _loadingStatus = _NCLoadingStatus.loading;

  _load() async {
    var success = true;
    var err;
    var result = await widget.loadData().catchError((e) {
      err = e;
      success = false;
    });
    if (!widget.simpleMode && mounted) {
      setState(() {
        _loadingStatus =
            success ? _NCLoadingStatus.success : _NCLoadingStatus.fail;
      });
    }

    await Future.delayed(Duration(milliseconds: 800));
    if (onLoadResult != null) {
      onLoadResult(result, err);
    }

    return Future.value();
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageChild = Container(
      width: 36,
      height: 36,
      padding: EdgeInsets.all(2),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
        strokeWidth: 1.2,
      ),
    );
    var infoText = widget.text;

    switch (_loadingStatus) {
      case _NCLoadingStatus.loading:
        imageChild = Container(
          width: 36,
          height: 36,
          padding: EdgeInsets.all(2),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 1.2,
          ),
        );
        infoText = widget.text;
        break;
      case _NCLoadingStatus.success:
        imageChild = Image(
          image: loading_success,
          height: 36,
          width: 36,
        );
        infoText = "成功!";
        break;
      case _NCLoadingStatus.fail:
        imageChild = Image(
          image: loading_fail,
          height: 36,
          width: 36,
        );
        infoText = "失败!";
        break;
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 100.0, minHeight: 100),
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: AnimatedSwitcher(
                    child: imageChild,
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        child: ScaleTransition(child: child, scale: animation),
                        opacity: animation,
                      );
                    },
                    switchInCurve: Curves.easeOutBack,
                    switchOutCurve: Curves.easeInBack,
                  ),
                ),
                Text(
                  infoText,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const loading_success = AssetImage('assets/ic_loading_success.png', package: 'nctoast');
const loading_fail = AssetImage('assets/ic_loading_fail.png', package: 'nctoast');
