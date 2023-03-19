import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_wx/widgets/appbar.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

//图形浏览器
class GalleryWidget extends StatefulWidget {
  const GalleryWidget(
      {super.key,
      required this.initialIndex,
      required this.imageList,
      this.isBarVisible});
  final int initialIndex; //初始图片索引
  final List<AssetEntity> imageList; //图片列表
  final bool? isBarVisible; //是否显示bar
  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget>
    with SingleTickerProviderStateMixin {
  //SingleTickerProviderStateMixin 用于页面销毁销毁动画
  bool visible = true;
  // 动画控制器
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    visible = widget.isBarVisible ?? true;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), //动画持续时间
    );
  }

  Widget _buildImageView() {
    return ExtendedImageGesturePageView.builder(
      controller: ExtendedPageController(initialPage: widget.initialIndex),
      itemCount: widget.imageList.length,
      itemBuilder: (BuildContext context, int index) {
        final AssetEntity item = widget.imageList[index];
        return ExtendedImage(
          image: AssetEntityImageProvider(item, isOriginal: true),
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: ((state) {
            return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: true, //是否使用ExtendedImageGesturePageView展示图片
              initialAlignment: InitialAlignment.center,
            );
          }),
        );
      },
    );
  }

  Widget _mainView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, //不允许事件穿透 点击空白处隐藏bar
      // onTap: () => Navigator.pop(context),
      onTap: () {
        setState(() {
          visible = !visible;
        });
      },
      child: Scaffold(
        //箭头动画
        appBar: SlideAppBarWidget(
            controller: controller,
            visible: visible,
            child: AppBar(backgroundColor: Colors.transparent, elevation: 0)),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: _buildImageView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
