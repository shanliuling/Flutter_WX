import 'package:flutter/material.dart';
import 'package:flutter_application_wx/widgets/gallery.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../utils/config.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({super.key});

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  // 已选中图片的列表
  List<AssetEntity> imageList = [];
  //是否开启拖拽
  bool isDraggable = false;
  // 是否将要删除
  bool isWillDelete = false;
  // 图片列表
  Widget _buildImageList() {
    return Padding(
      padding: const EdgeInsets.all(spacing),
      // LayoutBuilder用于获取父组件的宽度
      child: LayoutBuilder(builder: (context, constraints) {
        // width = (父组件宽度 - 间距) / 3
        final double width = (constraints.maxWidth - spacing * 2) / 3;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final entity in imageList)
              _buildPhotoItem(entity, width), //图片item

            if (imageList.length < maxAssets)
              _buildAddBtn(context, width) //添加图片按钮
          ],
        );
      }),
    );
  }

  //添加图片按钮
  GestureDetector _buildAddBtn(BuildContext context, double width) {
    return GestureDetector(
      onTap: () async {
        final List<AssetEntity>? result = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
              selectedAssets: imageList, maxAssets: maxAssets), //图片已选和图片最大限制
        );
        if (result == null) {
          return;
        }
        setState(() {
          imageList = result;
        });
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
        ),
        child: SizedBox(
          width: width,
          height: width,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  //图片item
  Widget _buildPhotoItem(AssetEntity entity, double width) {
    // Draggable 拖拽
    return Draggable<AssetEntity>(
      data: entity,
      //当可拖动对象开始被拖动时调用。
      onDragStarted: () {
        setState(() {
          isDraggable = true;
        });
      },
      //当可拖动对象被放下时调用。
      onDragEnd: (details) {
        setState(() {
          isDraggable = false;
        });
      },
      onDragCompleted: () {},
      feedback: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: AssetEntityImage(
          entity,
          width: width,
          height: width,
          fit: BoxFit.cover,
          isOriginal: false, //是否原图
        ),
      ),
      childWhenDragging: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: AssetEntityImage(
          entity,
          width: width,
          height: width,
          fit: BoxFit.cover,
          isOriginal: false, //是否原图
          opacity: const AlwaysStoppedAnimation(0.2), //透明度
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              //引入图形浏览器
              return GalleryWidget(
                initialIndex: imageList.indexOf(entity), //选中为第几张图片
                imageList: imageList, //这是引入,不是复制,复制要add什么的
              );
            }),
          );
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: AssetEntityImage(
            entity,
            width: width,
            height: width,
            fit: BoxFit.cover,
            isOriginal: false, //是否原图
          ),
        ),
      ),
    );
  }

  // 主视图
  Widget _mainView() {
    return Column(
      children: [
        // 图片列表
        _buildImageList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布动态'),
      ),
      body: _mainView(),
    );
  }
}
