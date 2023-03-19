import 'package:flutter/material.dart';

/// 动画隐藏显示 appbar
class SlideAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const SlideAppBarWidget({
    super.key,
    required this.child,
    required this.controller,
    required this.visible,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward(); //动画反转与播放

    // 动画组件
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, -1),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
  }
}
