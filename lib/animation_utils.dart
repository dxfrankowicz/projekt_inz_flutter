import 'package:flutter/material.dart';

class AnimatedLogo extends AnimatedWidget {

  final Widget logo;

  AnimatedLogo(this.logo, {Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: logo,
      ),
    );
  }
}

class LogoAnimationTest extends StatefulWidget {
  final VoidCallback notifyParent;

  const LogoAnimationTest({Key key, this.notifyParent}) : super(key: key);

  _LogoAnimationTestState createState() => _LogoAnimationTestState();
}

class _LogoAnimationTestState extends State<LogoAnimationTest>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  VoidCallback notifyParent;
  FlutterLogo logo = FlutterLogo(size: 24.0);

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween<double>(begin: logo.size, end: logo.size*10.0).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.notifyParent();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(logo, animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
