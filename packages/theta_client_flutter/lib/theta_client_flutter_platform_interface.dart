import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:theta_client_flutter/theta_client_flutter.dart';

import 'theta_client_flutter_method_channel.dart';

abstract class ThetaClientFlutterPlatform extends PlatformInterface {
  /// Constructs a ThetaClientPlatform.
  ThetaClientFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ThetaClientFlutterPlatform _instance = MethodChannelThetaClientFlutter();

  /// The default instance of [ThetaClientFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelThetaClientFlutter].
  static ThetaClientFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ThetaClientFlutterPlatform] when
  /// they register themselves.
  static set instance(ThetaClientFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initialize(String endpoint, ThetaConfig? config, ThetaTimeout? timeout) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<bool> isInitialized() {
    throw UnimplementedError('isInitialized() has not been implemented.');
  }

  Future<void> restoreSettings() {
    throw UnimplementedError('restoreSettings() has not been implemented.');
  }

  Future<ThetaInfo> getThetaInfo() {
    throw UnimplementedError('getThetaInfo() has not been implemented.');
  }

  Future<ThetaState> getThetaState() {
    throw UnimplementedError('getThetaInfo() has not been implemented.');
  }

  Future<void> getLivePreview(bool Function(Uint8List) frameHandler) {
    throw UnimplementedError('getLivePreview() has not been implemented.');
  }

  Future<List<FileInfo>> listFiles(FileTypeEnum fileType, int entryCount, int startPosition) {
    throw UnimplementedError('listFiles() has not been implemented.');
  }

  Future<void> deleteFiles(List<String> fileUrls) {
    throw UnimplementedError('deleteFiles() has not been implemented.');
  }

  /// Delete all files in Theta.
  Future<void> deleteAllFiles() {
    throw UnimplementedError('deleteAllFiles() has not been implemented.');
  }

  /// Delete all image files in Theta.
  Future<void> deleteAllImageFiles() {
    throw UnimplementedError('deleteAllImageFiles() has not been implemented.');
  }

  /// Delete all video files in Theta.
  Future<void> deleteAllVideoFiles() {
    throw UnimplementedError('deleteAllVideoFiles() has not been implemented.');
  }

  Future<void> getPhotoCaptureBuilder() {
    throw UnimplementedError('getPhotoCaptureBuilder() has not been implemented.');
  }

  Future<void> buildPhotoCapture(Map<String, dynamic> options) {
    throw UnimplementedError('buildPhotoCapture() has not been implemented.');
  }

  Future<String?> takePicture() {
    throw UnimplementedError('takePicture() has not been implemented.');
  }

  Future<void> getVideoCaptureBuilder() {
    throw UnimplementedError('getVideoCaptureBuilder() has not been implemented.');
  }

  Future<void> buildVideoCapture(Map<String, dynamic> options) {
    throw UnimplementedError('buildVideoCapture() has not been implemented.');
  }

  Future<String?> startVideoCapture() {
    throw UnimplementedError('startVideoCapture() has not been implemented.');
  }

  Future<void> stopVideoCapture() {
    throw UnimplementedError('stopVideoCapture() has not been implemented.');
  }

  Future<Options> getOptions(List<OptionNameEnum> optionNames) {
    throw UnimplementedError('getOptions() has not been implemented.');
  }

  Future<void> setOptions(Options options) {
    throw UnimplementedError('setOptions() has not been implemented.');
  }

  Future<Metadata> getMetadata(String fileUrl) {
    throw UnimplementedError('getMetadata() has not been implemented.');
  }

  Future<void> reset() {
    throw UnimplementedError('reset() has not been implemented.');
  }

  Future<void> stopSelfTimer() {
    throw UnimplementedError('stopSelfTimer() has not been implemented.');
  }

  Future<String> convertVideoFormats(String fileUrl, bool toLowResolution, bool applyTopBottomCorrection) {
    throw UnimplementedError('convertVideoFormats() has not been implemented.');
  }

  Future<void> cancelVideoConvert() {
    throw UnimplementedError('cancelVideoConvert() has not been implemented.');
  }

  Future<void> finishWlan() {
    throw UnimplementedError('finishWlan() has not been implemented.');
  }

  Future<List<AccessPoint>> listAccessPoints() {
    throw UnimplementedError('listAccessPoints() has not been implemented.');
  }

  Future<void> setAccessPointDynamically(
    String ssid,
    bool ssidStealth,
    AuthModeEnum authMode,
    String password,
    int connectionPriority
  ) {
    throw UnimplementedError('setAccessPointDynamically() has not been implemented.');
  }

  Future<void> setAccessPointStatically(
    String ssid,
    bool ssidStealth,
    AuthModeEnum authMode,
    String password,
    int connectionPriority,
    String ipAddress,
    String subnetMask,
    String defaultGateway    
  ) {
    throw UnimplementedError('setAccessPointStatically() has not been implemented.');
  }

  Future<void> deleteAccessPoint(String ssid) {
    throw UnimplementedError('deleteAccessPoint() has not been implemented.');
  }
}
