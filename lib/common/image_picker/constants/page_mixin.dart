// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:bruno/bruno.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:testt/utils/vr_utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show
        AssetEntity,
        DefaultAssetPickerProvider,
        DefaultAssetPickerBuilderDelegate;

import '../../../utils/channel/vr_boost_channel.dart';
import '../../global/global.dart';
import '../widgets/method_list_view.dart';
import '../widgets/selected_assets_list_view.dart';
import 'picker_method.dart';

@optionalTypeArgs
mixin ExamplePageMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);

  VoidCallback? removeListener;

  @override
  void initState() {
    // TODO: implement initState

    if (Platform.isIOS) {
      removeListener = BoostChannel.instance
          .addEventListener(ChannelKey.vobsupload, (key, arguments) {
        Map<dynamic, dynamic> arg = arguments;
        String status = arg['status'] ?? '';
        if (status == "success") {
          BrnToast.show('文件上传成功', context);
        } else if (status == "failed") {
          ///失效状态
          BrnToast.show('文件上传失败', context);
        }
        Future<dynamic> init() async {}
        return init();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    isDisplayingDetail.dispose();
    removeListener?.call();
    super.dispose();
  }

  int get maxAssetsCount;

  List<AssetEntity> assets = <AssetEntity>[];

  int get assetsLength => assets.length;

  List<PickMethod> get pickMethods;

  /// These fields are for the keep scroll position feature.
  late DefaultAssetPickerProvider keepScrollProvider =
      DefaultAssetPickerProvider();
  DefaultAssetPickerBuilderDelegate? keepScrollDelegate;

  File? _file;

  Future<void> selectAssets(PickMethod model) async {
    final List<AssetEntity>? result = await model.method(context, assets);
    if (result != null) {
      assets = result.toList();
      AssetEntity assetEntity = assets[0];
      File? file = await assetEntity.file;
      _file = file;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void removeAsset(int index) {
    assets.removeAt(index);
    if (assets.isEmpty) {
      isDisplayingDetail.value = false;
    }
    setState(() {});
  }

  void onResult(List<AssetEntity>? result) {
    if (result != null && result != assets) {
      assets = result.toList();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: MethodListView(
            pickMethods: pickMethods,
            onSelectMethod: selectAssets,
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            child: BrnBigMainButton(
              title: '上传户型图',
              isEnable: true,
              onTap: () {
                if (assets.isEmpty) {
                  BrnToast.show('请至少选择1张户型图进行上传', context);
                  return;
                } else {
                  Map<String, Object> parms = {
                    'localPath': _file?.path.toString() ?? '',
                    'inputPath': Global.inputFlies ?? ''
                  };
                  if (Platform.isIOS) {
                    BoostChannel.instance.sendEventToNative(
                        ChannelKey.vobsupload,
                        {ChannelKey.vobsupload: jsonEncode(parms)});
                  } else if (Platform.isAndroid) {
                    VChannel().obsUpload(parms).then((value) {
                      BrnToast.show(value.toString(), context);
                    });
                  }
                }
              },
            )),
        if (assets.isNotEmpty)
          SelectedAssetsListView(
            assets: assets,
            isDisplayingDetail: isDisplayingDetail,
            onResult: onResult,
            onRemoveAsset: removeAsset,
          ),
      ],
    );
  }
}
