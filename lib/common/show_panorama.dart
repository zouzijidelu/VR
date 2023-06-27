import 'dart:io' show File, Platform;
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:panorama/panorama.dart';

class ShowPanorama extends StatefulWidget {
  final String title;
  final String filePath;
  
  const ShowPanorama({
    Key? key,
    required this.title,
    required this.filePath,
    //required this.callBack,
  }) : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<ShowPanorama> {
  late FToast fToast;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black,
            child: Center(
                child: Panorama(
              child: Image.file(
                File(widget.filePath),
                color: Colors.black,
              ),
                  minZoom: 0.1,
                  zoom: 0.5,
                  maxZoom: 3,
                  sensitivity: 3.0,
            )),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 75,
              child: AppBar(
                title: Text(widget.title.isEmpty ? '' : widget.title),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Image(
                        image: AssetImage("images/icon-navbar-return.png"),
                      ),
                      //  tooltip: 'Increase volume by 10',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
