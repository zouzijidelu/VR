import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

VRLaunch() {

  Future<void> vlaunchUrl(String url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
