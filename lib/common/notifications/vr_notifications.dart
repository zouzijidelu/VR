import 'package:flutter/material.dart';

class VRNotKey {
  static String knotf = 'knotf';
}

class VRNotification extends Notification {
  VRNotification(this.value);

  final String value;
}