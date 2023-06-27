import 'dart:io';
import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:testt/utils/vr_utils.dart';
import '../../generated/assets.dart';
import '../../utils/image_untils/vr_imgae_utils.dart';
import '../global/global.dart';
import '../UI/res_color.dart';
import 'package:image/image.dart' as img;

/// /// /// /// /// /// /// /// /// /
/// 创建时间: 2023/05/04.
/// 作者: bill
/// 描述: 上展示的常用 房源卡片
/// /// /// /// /// /// /// /// /// /
enum VRHouseCardType {
  ///默认的数据没有底部信息
  normal,

  ///上传按钮
  upload,

  ///更多按钮
  more,

  ///删除信息
  delete,

  ///修改房源id
  fixHouseId,

  ///催进度
  quick,
}

enum VRHouseCardErrorType {
  ///默认的数据没有底部信息
  normal,

  /// - 请尽快上传，否则将被他人上传
  upload,

  /// - 未在有效期内上传，已被他人拍摄
  unupload,

  ///房源失效
  loseEfficacy
}

enum VRHouseTListype {
  ///未拍摄
  uncap,

  /// 未上传
  unupload,

  ///已上传
  finish,
}

class VRHouseCard extends StatefulWidget {
  final VRHouseTListype? listType;

  // 房源图片 url
  final String? imageURL;

  //"西三旗小区
  final String? title;

  final String? houseId;

  //'西三旗 100000347549234/西三旗 100000347549234'
  final String? detail;

  final String? errorMsg;

  final VRHouseCardErrorType? errorType;

  final List? bottomSource;

  final String? statusTag;

  final String? status;

  //该卡片被点击时候的回调
  final VoidCallback? itemClicked;

  //该卡片被点击时候的回调
  final VoidCallback? moreClicked;

  final VoidCallback? deleteClicked;

  final VoidCallback? fixHouseClicked;

  //该卡片被点击时候的回调
  final VoidCallback? uploadClicked;

  //该卡片被点击时候的回调
  final VoidCallback? quickClicked;

  const VRHouseCard(
      {this.title = '',
      this.detail = '--',
      this.listType = VRHouseTListype.uncap,
      this.errorMsg = '',
      this.houseId = '',
      this.errorType = VRHouseCardErrorType.normal,
      this.imageURL = '',
      this.statusTag = '',
      this.bottomSource,
      this.status,
      this.itemClicked,
      this.moreClicked,
      this.deleteClicked,
      this.fixHouseClicked,
      this.quickClicked,
      this.uploadClicked});

  @override
  VRHouseCardState createState() => VRHouseCardState();
}

class VRHouseCardState extends State<VRHouseCard> {
  @override
  late void Function()? itemClicked = null;

  void initState() {
    // TODO: implement initState
    super.initState();
    itemClicked = widget.itemClicked;
  }

  @override
  Widget build(BuildContext context) {
    Center ctn = Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            border: widget.listType == VRHouseTListype.uncap
                ? Border(bottom: BorderSide(width: 1, color: Color(0xffeeeeee)))
                : Border()),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (widget.itemClicked != null) {
              widget.itemClicked!();
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_buildleftImage(context), _buildRightInfo()],
          ),
        ),
      ),
    );
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            // color: Colors.blue,
            border: widget.listType == VRHouseTListype.finish
                ? const Border(
                    bottom: BorderSide(width: 1, color: Color(0xffeeeeee)))
                : const Border()),
        padding: EdgeInsets.only(
            bottom: widget.listType == VRHouseTListype.finish ? 16 : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ctn, _buildBottomActions(context)],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    bool _bottomVisibility = true;
    if (widget.listType == VRHouseTListype.uncap) {
      _bottomVisibility = false;
    }

    if (widget.listType == VRHouseTListype.finish) {
      return _buildButtonList();
    }

    return _buildUnupload(bottomVisibility: _bottomVisibility);
  }

  Widget _buildUnupload({bool? bottomVisibility}) {
    List<String> secondaryButtonNameList = [];
    String uploadStr = '';
    widget.bottomSource?.forEach((type) {
      if (type == VRHouseCardType.fixHouseId) {
        secondaryButtonNameList.add('修改房源ID');
      }

      if (type == VRHouseCardType.delete) {
        secondaryButtonNameList.add('删除');
      }
      if (type == VRHouseCardType.more) {
        secondaryButtonNameList.add('更多信息');
      }
      if (type == VRHouseCardType.upload) {
        uploadStr = '上传';
      }
    });

    return Visibility(
      visible: bottomVisibility ?? false,
      child: Container(
        child: BrnButtonPanel(
          mainButtonName: uploadStr ?? '',
          mainButtonOnTap: () {
            if (widget.uploadClicked != null) {
              widget.uploadClicked!();
            }
            // BrnToast.show('上传按钮点击', context);
          },
          secondaryButtonNameList: secondaryButtonNameList,
          secondaryButtonOnTap: (index) {
            if (VRHouseCardType.delete == widget.bottomSource?[index]) {
              if (widget.deleteClicked != null) {
                widget.deleteClicked!();
              }
            }

            if (VRHouseCardType.fixHouseId == widget.bottomSource?[index]) {
              if (widget.fixHouseClicked != null) {
                widget.fixHouseClicked!();
              }
            }

            if (VRHouseCardType.more == widget.bottomSource?[index]) {
              if (widget.moreClicked != null) {
                widget.moreClicked!();
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildButtonList() {
    List<String> secondaryButtonNameList = [];
    widget.bottomSource?.forEach((type) {
      if (type == VRHouseCardType.upload) {
        secondaryButtonNameList.add('上传户型图');
      }
      if (type == VRHouseCardType.more) {
        secondaryButtonNameList.add('更多信息');
      }
      if (type == VRHouseCardType.quick) {
        secondaryButtonNameList.add('催进度');
      }
    });

    List<Widget> children = [];
    secondaryButtonNameList.forEach((element) {
      children.add(Container(
        padding: EdgeInsets.only(right: 10),
        child: BrnSmallOutlineButton(
          width: 100,
          title: element,
          onTap: () {
            if (element == '更多信息') {
              if (widget.moreClicked != null) {
                widget.moreClicked!();
              }
            }

            if (element == '上传户型图') {
              if (widget.uploadClicked != null) {
                widget.uploadClicked!();
              }
            }

            if (element == '催进度') {
              if (widget.quickClicked != null) {
                widget.quickClicked!();
              }
            }
            if (element == '删除') {
              if (widget.deleteClicked != null) {
                widget.deleteClicked!();
              }
            }
          },
        ),
      ));
    });

    return Container(
      // padding: EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
    );
  }

  ///图片位置信息
  Widget _buildleftImage(BuildContext context) {
    return Container(
      child: Stack(
        children: [_buildHouseImage(context)],
      ),
    );
  }

  Widget _buildHouseImage(BuildContext context) {
    return Container(
        // color: Color(0xff0000ff),
        padding: EdgeInsets.only(right: 10),
        height: 132,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [_getImagewidget(), _buildCopyItem(context)],
          ),
        ));
  }

  Widget _getImagewidget() {
    Widget placeWidget = Container(
      width: 100,
      height: 100,
      color: Colors.grey,
      child: Image(
        image: AssetImage(Assets.imageHousePlaceHolder),
        fit: BoxFit.fill,
      ),
    );

    Widget loseWidget = Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.only(left: 14, right: 14, top: 5),
      color: GlobalColor.color_7FFFFFFF,
      child: Center(
        child: Image(
          image: AssetImage(Assets.iconsIconCapLose),
          fit: BoxFit.fill,
        ),
      ),
    );

    if (widget.listType == VRHouseTListype.unupload) {
      Widget fileImageWidget = Container(
        height: 100,
        width: 100,
        child: _buildFileImage(widget.imageURL ?? ''),
      );

      Widget stackLoseEfficacy = Stack(
        children: [
          fileImageWidget,
          Visibility(
            child: loseWidget,
            visible: (widget.status == '-1'),
          ),
        ],
      );

      return stackLoseEfficacy;
    } else if (widget.imageURL == '') {
      return placeWidget;
    } else {
      Widget cacheImage = CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: ImageUtils.thumbnailFromUrl(widget.imageURL ?? '') ?? '',
          imageBuilder: (context, imageProvider) => Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          errorWidget: (BuildContext context, String url, error) {
            return placeWidget;
          },
          placeholder: (BuildContext context, String url) {
            return placeWidget;
          });
      return cacheImage;
    }
  }

  // _buildFileImage()
  ///copy内容信息
  Widget _buildCopyItem(BuildContext context) {
    String? houseID = widget.houseId;
    int maxLen = 10;
    if ((widget.houseId?.length ?? 0) > maxLen) {
      houseID = '${widget.houseId?.substring(0, (maxLen - 1))}..';
    }
    return Positioned(
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: widget.houseId));
          BrnToast.show('复制成功', context);
        },
        child: Container(
          padding: const EdgeInsets.only(top: 2),
          height: 16,
          width: 100,
          color: GlobalColor.color_222222,
          child: Padding(
            padding: const EdgeInsets.only(left: 1, right: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID',
                  style: TextStyle(
                      color: GlobalColor.color_white,
                      fontSize: 10,
                      fontWeight: GlobalFontWeight.font_regular),
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  (' ${omitCharacter(houseID ?? '', 11)}'),
                  style: TextStyle(
                      color: GlobalColor.color_white,
                      fontSize: 10,
                      fontWeight: GlobalFontWeight.font_regular),
                ),
                Container(
                  width: 10,
                  height: 12,
                  child: Image(
                    image: AssetImage(Assets.iconsCapCopy),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///右边内容
  Widget _buildRightInfo() {
    bool _tagVisibility = false;
    if (widget.listType == VRHouseTListype.finish) {
      _tagVisibility = true;
    }

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 16, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_buildTitle(), _buildDetail()],
              ),
            ),
          ),
          Visibility(
            visible: _tagVisibility,
            child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: BrnStateTag(
                tagText: widget.statusTag ?? '',
                textColor: GlobalColor.color_FAAD14,
                backgroundColor: GlobalColor.color_19FAAD14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///详情页功能标题 - 二手/公园1872富力城C区 2期富力城
  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Text(
        widget.title ?? '',
        maxLines: 2,
        style: TextStyle(
            fontWeight: GlobalFontWeight.font_medium,
            fontSize: 18,
            color: GlobalColor.color_222222),
      ),
    );
  }

  ///详情页功能标题  2室1厅 124.11㎡ 5/25层
  Widget _buildDetail() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        widget.detail ?? '',
        style: TextStyle(
            fontWeight: GlobalFontWeight.font_regular,
            fontSize: 12,
            color: GlobalColor.color_666666),
      ),
    );
  }

  ///详情页功能标题  2室1厅 124.11㎡ 5/25层
  Widget _buildError() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 12,
            width: 12,
            color: Colors.red,
          ),
          Text(
            _getError(widget.errorType ?? VRHouseCardErrorType.normal),
            style: TextStyle(
                fontWeight: GlobalFontWeight.font_regular,
                fontSize: 12,
                color: GlobalColor.color_666666),
          ),
        ],
      ),
    );
  }

  String _getError(VRHouseCardErrorType errorType) {
    if (widget.errorMsg != null && widget.errorMsg != '') {
      return widget.errorMsg ?? '';
    }
    switch (errorType) {
      case VRHouseCardErrorType.normal:
        {
          return '';
        }
        break;

      ///尽快上传
      case VRHouseCardErrorType.upload:
        {
          return '请尽快上传，否则将被他人上传';
        }
        break;

      ///未上传
      case VRHouseCardErrorType.unupload:
        {
          return '未在有效期内上传，已被他人拍摄';
        }
        break;

      ///房源失效
      case VRHouseCardErrorType.loseEfficacy:
        {
          return '房源已失效';
        }
        break;
      default:
        {
          return '';
        }
        break;
    }
  }

  String omitCharacter(String char, int lengths) {
    if (char.runtimeType != String) {
      return '';
    }
    if (lengths.runtimeType != int) {
      return '';
    }
    if (char.length > lengths) {
      print('${char.substring(0, lengths - 1)}...');
      return '${char.substring(0, lengths - 1)}...';
    } else {
      return char;
    }
  }

  Widget _buildFileImage(String filePath) {
    if (validateEmpty(filePath)) {
      return Image(
        image: AssetImage(Assets.imageHousePlaceHolder),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } else {
      return FutureBuilder<File?>(
        future: compressFile(File(filePath ?? '')),
        builder: (_, AsyncSnapshot<File?> s) {
          if (!s.hasData) {
            return Container();
          }
          return Image.file(fit: BoxFit.cover, s.data!);
        },
      );
    }
  }

  Future<File> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 70, percentage: 70, targetHeight: 100, targetWidth: 100);
    return compressedFile;
  }
}
