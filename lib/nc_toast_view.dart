///
///Author: YoungChan
///Date: 2019-05-28 18:26:40
///LastEditors: YoungChan
///LastEditTime: 2019-05-28 21:31:28
///Description: Toast 提示
///
import 'package:flutter/material.dart';

class NCToast {
  static _ToastView preToast;

  static show(BuildContext context, String msg, {Duration duration}) {
    var overlayState = Overlay.of(context);
    var controllerShowAnim = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var controllerShowOffset = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 350),
    );
    var controllerHide = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var opacityAnim1 =
        new Tween(begin: 0.0, end: 1.0).animate(controllerShowAnim);
    var controllerCurvedShowOffset = new CurvedAnimation(
        parent: controllerShowOffset, curve: Curves.easeOutBack);
    var offsetAnim =
        new Tween(begin: 30.0, end: 0.0).animate(controllerCurvedShowOffset);
    var opacityAnim2 = new Tween(begin: 1.0, end: 0.0).animate(controllerHide);

    OverlayEntry overlayEntry;
    overlayEntry = new OverlayEntry(builder: (context) {
      return _ToastWidget(
        opacityAnim1: opacityAnim1,
        opacityAnim2: opacityAnim2,
        offsetAnim: offsetAnim,
        child: buildToastLayout(msg),
      );
    });
    preToast?.dismiss();
    preToast = null;
    var toastView = _ToastView(
      overlayEntry: overlayEntry,
      controllerShowAnim: controllerShowAnim,
      controllerShowOffset: controllerShowOffset,
      controllerHide: controllerHide,
      overlayState: overlayState,
    );
    if (duration != null) {
      toastView.duration = duration;
    }
    preToast = toastView;
    toastView._show();
  }

  static LayoutBuilder buildToastLayout(String msg) {
    return LayoutBuilder(builder: (context, constraints) {
      return IgnorePointer(
        ignoring: true,
        child: Align(
          child: Material(
            color: Colors.white.withOpacity(0),
            child: Container(
              child: Container(
                child: Text(
                  msg,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              margin: EdgeInsets.only(
                bottom: constraints.biggest.height * 0.1,
                left: constraints.biggest.width * 0.1,
                right: constraints.biggest.width * 0.1,
              ),
            ),
          ),
          alignment: Alignment.bottomCenter,
        ),
      );
    });
  }
}

class _ToastView {
  final OverlayEntry overlayEntry;
  final AnimationController controllerShowAnim;
  final AnimationController controllerShowOffset;
  final AnimationController controllerHide;
  final OverlayState overlayState;
  Duration duration;
  _ToastView(
      {this.overlayEntry,
      this.controllerShowAnim,
      this.controllerShowOffset,
      this.controllerHide,
      this.overlayState,
      this.duration = const Duration(milliseconds: 3500)});

  bool dismissed = false;

  _show() async {
    overlayState.insert(overlayEntry);
    controllerShowAnim.forward();
    controllerShowOffset.forward();
    await Future.delayed(duration);
    this.dismiss();
  }

  dismiss() async {
    if (dismissed) {
      return;
    }
    this.dismissed = true;
    controllerHide.forward();
    await Future.delayed(Duration(milliseconds: 250));
    overlayEntry?.remove();
  }
}

class _ToastWidget extends StatelessWidget {
  final Widget child;
  final Animation<double> opacityAnim1;
  final Animation<double> opacityAnim2;
  final Animation<double> offsetAnim;

  _ToastWidget(
      {this.child, this.offsetAnim, this.opacityAnim1, this.opacityAnim2});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: opacityAnim1,
      child: child,
      builder: (context, child_to_build) {
        return Opacity(
          opacity: opacityAnim1.value,
          child: AnimatedBuilder(
            animation: offsetAnim,
            builder: (context, _) {
              return Transform.translate(
                offset: Offset(0, offsetAnim.value),
                child: AnimatedBuilder(
                  animation: opacityAnim2,
                  builder: (context, _) {
                    return Opacity(
                      opacity: opacityAnim2.value,
                      child: child_to_build,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
