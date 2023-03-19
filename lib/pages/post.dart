import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../utils/config.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({super.key});

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  // 已选中图片列表
  List<AssetEntity> imageList = [];

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

  //添加按钮
  GestureDetector _buildAddBtn(BuildContext context, double width) {
    return GestureDetector(
      onTap: () async {
        final List<AssetEntity>? result = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
              selectedAssets: imageList, maxAssets: maxAssets), //图片已选和图片最大限制
        );
        setState(() {
          imageList = result ?? [];
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
  Container _buildPhotoItem(AssetEntity entity, double width) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: AssetEntityImage(
        entity,
        width: width,
        height: width,
        fit: BoxFit.cover,
        isOriginal: true, //是否原图
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
