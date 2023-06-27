import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:testt/utils/vr_utils.dart';
import '../../common/bean/house_edit_back_bean.dart';
import '../../common/global/global.dart';
import '../../common/UI/res_color.dart';
import '../../generated/assets.dart';

class VRHouseEditImagePage extends StatefulWidget {
  final VRHouseEditBackBean? bean;
  final VoidCallback? deleteOnTap;
  final VoidCallback? previewOnTap;

  const VRHouseEditImagePage(
      {Key? key, this.bean, this.deleteOnTap, this.previewOnTap})
      : super(key: key);

  @override
  _house_edit_image_pageState createState() {
    return _house_edit_image_pageState();
  }
}

class _house_edit_image_pageState extends State<VRHouseEditImagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: _imageValueNotifier,
            builder: (BuildContext context, String value, Widget? child) {
              return GestureDetector(
                child: _buildImage(context, value, child),
                onTap: widget.previewOnTap,
              );
            },
          ),
          _builDeleteItem(context)
        ],
      ),
    );
  }

  ///delete 内容信息
  Widget _builDeleteItem(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        padding: EdgeInsets.only(top: 2),
        height: 16,
        width: 90,
        decoration: BoxDecoration(
          color: GlobalColor.color_21000000,
        ),
        child: GestureDetector(
          onTap: () {
            if (widget.deleteOnTap != null) {
              widget.deleteOnTap!();
            }
          },
          child: Image(image: AssetImage(Assets.iconsIconCapDelete)),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Image(
      image: AssetImage(Assets.imageHousePlaceHolder),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  ValueNotifier<String> _imageValueNotifier = ValueNotifier('');

  Widget _buildImage(BuildContext context, String value, Widget? child) {
    VRUtils.pathToRealPath(widget.bean?.tempThumbnail ?? '').then((pvalue) {
      _imageValueNotifier.value = pvalue;
    });

    if (validateEmpty(_imageValueNotifier.value)) {
      return _placeholder();
    } else {
      return FutureBuilder<File?>(
        future: compressFile(File(_imageValueNotifier.value)),
        builder: (_, AsyncSnapshot<File?> s) {
          if (!s.hasData) {
            return _placeholder();
          }
          return Image.file(fit: BoxFit.cover, s.data!);
        },
      );
    }
  }

  Future<File> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 30, percentage: 30, targetHeight: 100, targetWidth: 100);
    return compressedFile;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
