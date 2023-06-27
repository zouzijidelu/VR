import 'package:flutter/foundation.dart';
import 'package:theta_client_flutter/utils/convert_utils.dart';

import 'theta_client_flutter_platform_interface.dart';
import 'dart:async';

/// Handle Theta web APIs.
class ThetaClientFlutter {
  Future<String?> getPlatformVersion() {
    return ThetaClientFlutterPlatform.instance.getPlatformVersion();
  }

  /// Initialize object.
  /// 
  /// * @param [endpoint] URL of Theta web API endpoint.
  /// * @param config Configuration of initialize. If null, get from THETA.
  /// * @param timeout Timeout of HTTP call.
  /// * @throws If an error occurs in THETA.
  Future<void> initialize([String endpoint = 'http://192.168.1.1:80/', ThetaConfig? config, ThetaTimeout? timeout]) {
    return ThetaClientFlutterPlatform.instance.initialize(endpoint, config, timeout);
  }

  /// Returns whether it is initialized or not.
  /// 
  /// * @return Whether it is initialized or not.
  /// * @throws If an error occurs in THETA.
  Future<bool> isInitialized() {
    return ThetaClientFlutterPlatform.instance.isInitialized();
  }

  /// Restore setting to THETA
  /// 
  /// * @throws If an error occurs in THETA.
  Future<void> restoreSettings() {
    return ThetaClientFlutterPlatform.instance.restoreSettings();
  }

  /// Get basic information about Theta.
  /// 
  /// * @return Static attributes of Theta.
  /// * @throws If an error occurs in THETA.
  Future<ThetaInfo> getThetaInfo() {
    return ThetaClientFlutterPlatform.instance.getThetaInfo();
  }

  /// Get current state of Theta.
  /// 
  /// * @return Mutable values representing Theta status.
  /// * @throws If an error occurs in THETA.
  Future<ThetaState> getThetaState() {
    return ThetaClientFlutterPlatform.instance.getThetaState();
  }

  /// Start live preview as motion JPEG.
  /// 
  /// * @param [frameHandler] Called for each JPEG frame.
  /// * @throws Command is currently disabled; for example, the camera is shooting a video.
  Future<void> getLivePreview(bool Function(Uint8List) frameHandler) {
    return ThetaClientFlutterPlatform.instance.getLivePreview(frameHandler);
  }

  /// Lists information of images and videos in Theta.
  /// 
  /// * @param [fileType] Type of the files to be listed.
  /// * @param [entryCount] Desired number of entries to return.
  /// If [entryCount] is more than the number of remaining files, just return entries of actual remaining files.
  /// * @param [startPosition] The position of the first file to be returned in the list. 0 represents the first file.
  /// If [startPosition] is larger than the position of the last file, an empty list is returned.
  /// * @return A list of file information.
  /// * @throws If an error occurs in THETA.
  Future<List<FileInfo>> listFiles(FileTypeEnum fileType, int entryCount, [int startPosition = 0]) {
    return ThetaClientFlutterPlatform.instance.listFiles(fileType, entryCount, startPosition);
  }

  /// Delete files in Theta.
  /// 
  /// * @param [fileUrls] URLs of the file to be deleted.
  /// * @throws Some of [fileUrls] don't exist.  All specified files cannot be deleted.
  Future<void> deleteFiles(List<String> fileUrls) {
    return ThetaClientFlutterPlatform.instance.deleteFiles(fileUrls);
  }

  /// Delete all files in Theta.
  /// 
  /// * @throws If an error occurs in THETA.
  Future<void> deleteAllFiles() {
    return ThetaClientFlutterPlatform.instance.deleteAllFiles();
  }

  /// Delete all image files in Theta.
  /// 
  /// * @throws If an error occurs in THETA.
  Future<void> deleteAllImageFiles() {
    return ThetaClientFlutterPlatform.instance.deleteAllImageFiles();
  }

  /// Delete all video files in Theta.
  /// 
  /// * @throws If an error occurs in THETA.
  Future<void> deleteAllVideoFiles() {
    return ThetaClientFlutterPlatform.instance.deleteAllVideoFiles();
  }

  /// Get PhotoCapture.Builder for take a picture.
  PhotoCaptureBuilder getPhotoCaptureBuilder() {
    ThetaClientFlutterPlatform.instance.getPhotoCaptureBuilder();
    return PhotoCaptureBuilder();
  }

  /// Get PhotoCapture.Builder for capture video.
  VideoCaptureBuilder getVideoCaptureBuilder() {
    ThetaClientFlutterPlatform.instance.getVideoCaptureBuilder();
    return VideoCaptureBuilder();
  }

  /// Acquires the properties and property support specifications for shooting, the camera, etc.
  /// 
  /// Refer to the [options category](https://github.com/ricohapi/theta-api-specs/blob/main/theta-web-api-v2.1/options.md)
  /// of API v2.1 reference for details on properties that can be acquired.
  /// 
  /// * @param optionNames List of [OptionNameEnum].
  /// * @return [Options] acquired
  Future<Options> getOptions(List<OptionNameEnum> optionNames) {
    return ThetaClientFlutterPlatform.instance.getOptions(optionNames);
  }

  /// Property settings for shooting, the camera, etc.
  /// 
  /// Check the properties that can be set and specifications by the API v2.1 reference options
  /// category or [camera.getOptions](https://github.com/ricohapi/theta-api-specs/blob/main/theta-web-api-v2.1/options.md).
  /// 
  /// * @param options Camera setting options.
  /// * @throws When an invalid option is specified.
  Future<void> setOptions(Options options) {
    return ThetaClientFlutterPlatform.instance.setOptions(options);
  }

  /// Get metadata of a still image
  /// 
  /// This command cannot be executed during video recording.
  /// RICOH THETA V firmware v2.00.2 or later
  /// 
  /// * @param[fileUrl] URL of a still image file
  /// * @return Exif and [photo sphere XMP](https://developers.google.com/streetview/spherical-metadata/)
  /// * @throws Command is currently disabled; for example, the camera is shooting a video.
  Future<Metadata> getMetadata(String fileUrl) {
    return ThetaClientFlutterPlatform.instance.getMetadata(fileUrl);
  }

  /// Reset all device settings and capture settings.
  /// After reset, the camera will be restarted.
  /// 
  /// * @throws If an error occurs in THETA.
  Future<void> reset() {
    return ThetaClientFlutterPlatform.instance.reset();
  }

  /// Stop running self-timer.
  /// 
  /// * @throws If an error occurs in THETA.
  Future<void> stopSelfTimer() {
    return ThetaClientFlutterPlatform.instance.stopSelfTimer();
  }

  /// Converts the movie format of a saved movie.
  /// 
  /// Theta S and Theta SC don't support this functionality, so always [fileUrl] is returned.
  /// 
  /// * @param fileUrl URL of a saved movie file.
  /// * @param toLowResolution If true generates lower resolution video, otherwise same resolution.
  /// * @param applyTopBottomCorrection apply Top/bottom correction. This parameter is ignored on Theta X.
  /// * @return URL of a converted movie file.
  /// * @throws Command is currently disabled.
  Future<String> convertVideoFormats(String fileUrl, bool toLowResolution, [bool applyTopBottomCorrection = true]) {
    return ThetaClientFlutterPlatform.instance.convertVideoFormats(fileUrl, toLowResolution, applyTopBottomCorrection);
  }

  /// Cancels the movie format conversion.
  /// 
  /// * @throws When convertVideoFormats is not started.
  Future<void> cancelVideoConvert() {
    return ThetaClientFlutterPlatform.instance.cancelVideoConvert();
  }

  /// Turns the wireless LAN off.
  /// 
  /// * @throws If an error occurs in THETA.
  Future<void> finishWlan() {
    return ThetaClientFlutterPlatform.instance.finishWlan();
  }

  /// Acquires the access point list used in client mode.
  /// 
  /// For RICOH THETA X, only the access points registered with [setAccessPoint] can be acquired.
  /// (The access points automatically detected with the camera UI cannot be acquired with this API.)
  /// 
  /// * @return Lists the access points stored on the camera and the access points detected by the camera.
  /// * @throws If an error occurs in THETA.
  Future<List<AccessPoint>> listAccessPoints() {
    return ThetaClientFlutterPlatform.instance.listAccessPoints();
  }

  /// Set access point. IP address is set dynamically.
  /// 
  /// * @param ssid SSID of the access point.
  /// * @param ssidStealth True if SSID stealth is enabled.
  /// * @param authMode Authentication mode.
  /// * @param password Password. If [authMode] is "[none]", pass empty String.
  /// * @param connectionPriority Connection priority 1 to 5. Theta X fixes to 1 (The access point registered later has a higher priority.)
  /// * @throws If an error occurs in THETA.
  Future<void> setAccessPointDynamically(
    String ssid,
    {
      bool ssidStealth = false,
      AuthModeEnum authMode = AuthModeEnum.none,
      String password = '',
      int connectionPriority = 1
    }
  ) {
    return ThetaClientFlutterPlatform.instance.setAccessPointDynamically(ssid, ssidStealth, authMode, password, connectionPriority);
  }

  /// Set access point. IP address is set statically.
  /// 
  /// * @param ssid SSID of the access point.
  /// * @param ssidStealth True if SSID stealth is enabled.
  /// * @param authMode Authentication mode.
  /// * @param password Password. If [authMode] is "[none]", pass empty String.
  /// * @param connectionPriority Connection priority 1 to 5. Theta X fixes to 1 (The access point registered later has a higher priority.)
  /// * @param ipAddress IP address assigns to Theta.
  /// * @param subnetMask Subnet mask.
  /// * @param defaultGateway Default gateway.
  /// * @throws If an error occurs in THETA.
  Future<void> setAccessPointStatically(
    String ssid,
    {
      bool ssidStealth = false,
      AuthModeEnum authMode = AuthModeEnum.none,
      String password = '',
      int connectionPriority = 1,
      required String ipAddress,
      required String subnetMask,
      required String defaultGateway
    }
  ) {
    return ThetaClientFlutterPlatform.instance.setAccessPointStatically(ssid, ssidStealth, authMode, password, connectionPriority, ipAddress, subnetMask, defaultGateway);
  }

  /// Deletes access point information used in client mode.
  /// Only the access points registered with [setAccessPoint] can be deleted.
  /// 
  /// * @param ssid SSID of the access point.
  /// * @throws If an error occurs in THETA.
  Future<void> deleteAccessPoint(String ssid) {
    return ThetaClientFlutterPlatform.instance.deleteAccessPoint(ssid);
  }
}

/// Static attributes of Theta.
class ThetaInfo {
  /// Theta model name.
  final String model;

  /// Theta serial number.
  final String serialNumber;

  /// Theta firmware version.
  final String firmwareVersion;

  /// True if Theta has GPS.
  final bool hasGps;

  /// True if Theta has Gyroscope.
  final bool hasGyro;

  /// Number of seconds since Theta boot.
  final int uptime;

  ThetaInfo(this.model, this.serialNumber, this.firmwareVersion, this.hasGps, this.hasGyro, this.uptime);
}

/// File type in Theta.
enum FileTypeEnum {
  /// All files.
  all('ALL'),

  /// Still image files.
  image('IMAGE'),

  /// Video files.
  video('VIDEO');

  final String rawValue;
  const FileTypeEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }
}

/// File information in Theta.
class FileInfo {
  /// File name.
  final String name;

  /// File size in bytes.
  final int size;

  /// File creation time in the format "YYYY:MM:DD HH:MM:SS".
  final String dateTime;

  /// You can get a file using HTTP GET to [fileUrl].
  final String fileUrl;

  /// You can get a thumbnail image using HTTP GET to [thumbnailUrl].
  final String thumbnailUrl;

  FileInfo(this.name, this.size, this.dateTime, this.fileUrl, this.thumbnailUrl);
}

/// Battery charging state
enum ChargingStateEnum {
  /// Battery charging state. Charging
  charging('CHARGING'),

  /// Battery charging state. Charging completed
  completed('COMPLETED'),

  /// Battery charging state. Not charging
  notCharging('NOT_CHARGING');

  final String rawValue;
  const ChargingStateEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static ChargingStateEnum? getValue(String rawValue) {
    return ChargingStateEnum.values.cast<ChargingStateEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Mutable values representing Theta status.
class ThetaState {
  /// Fingerprint (unique identifier) of the current camera state
  String fingerprint;

  /// Battery level between 0.0 and 1.0
  double batteryLevel;

  /// Charging state
  ChargingStateEnum chargingState;

  /// True if record to SD card
  bool isSdCard;

  /// Recorded time of movie (seconds)
  int recordedTime;

  /// Recordable time of movie (seconds)
  int recordableTime;

  /// URL of the last saved file
  String latestFileUrl;

  ThetaState(this.fingerprint, this.batteryLevel, this.chargingState, this.isSdCard, this.recordedTime, this.recordableTime, this.latestFileUrl);
}

/// Exif metadata of a still image.
class Exif {
  /// EXIF Support version
  String exifVersion;

  /// File created or updated date and time
  String dateTime;

  /// Image width (pixel). Theta X returns null.
  int? imageWidth;

  /// Image height (pixel). Theta X returns null.
  int? imageLength;

  /// GPS latitude if exists.
  double? gpsLatitude;

  /// GPS longitude if exists.
  double? gpsLongitude;

  Exif(this.exifVersion, this.dateTime, this.imageWidth, this.imageLength, this.gpsLatitude, this.gpsLongitude);
}

/// Photo sphere XMP metadata of a still image.
class Xmp {
  /// Compass heading, for the center the image. Theta X returns null.
  double? poseHeadingDegrees;

  /// Image width (pixel).
  int fullPanoWidthPixels;

  /// Image height (pixel).
  int fullPanoHeightPixels;

  Xmp(this.poseHeadingDegrees, this.fullPanoWidthPixels, this.fullPanoHeightPixels);
}

/// Metadata of a still image
class Metadata {
  /// Exif metadata of a still image.
  Exif exif;

  /// Photo sphere XMP metadata of a still image.
  Xmp xmp;
  Metadata(this.exif, this.xmp);
}

/// Enum for authentication mode.
enum AuthModeEnum {
  /// Authentication mode. none
  none('NONE'),

  /// Authentication mode. WEP
  wep('WEP'),

  /// Authentication mode. WPA/WPA2 PSK
  wpa('WPA');

  final String rawValue;
  const AuthModeEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static AuthModeEnum? getValue(String rawValue) {
    return AuthModeEnum.values.cast<AuthModeEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Access point information.
class AccessPoint {
  /// SSID of the access point.
  String ssid;

  /// True if SSID stealth is enabled.
  bool ssidStealth;

  /// Authentication mode.
  AuthModeEnum authMode;

  /// Connection priority 1 to 5. Theta X fixes to 1 (The access point registered later has a higher priority.)
  int connectionPriority = 1;

  /// Using DHCP or not. This can be acquired when SSID is registered as an enable access point.
  bool usingDhcp;

  /// IP address assigned to camera. This setting can be acquired when “usingDhcp” is false.
  String? ipAddress;

  /// Subnet Mask. This setting can be acquired when “usingDhcp” is false.
  String? subnetMask;

  /// Default Gateway. This setting can be acquired when “usingDhcp” is false.
  String? defaultGateway;

  AccessPoint(this.ssid, this.ssidStealth, this.authMode, this.connectionPriority, this.usingDhcp, this.ipAddress, this.subnetMask, this.defaultGateway);
}

/// Camera setting options name.
/// 
/// [options name](https://github.com/ricohapi/theta-api-specs/blob/main/theta-web-api-v2.1/options.md)
enum OptionNameEnum {
  /// Option name aperture
  aperture('Aperture', ApertureEnum),

  /// Option name captureMode
  captureMode('CaptureMode', CaptureModeEnum),

  /// Option name _colorTemperature
  colorTemperature('ColorTemperature', int),

  /// Option name dateTimeZone
  dateTimeZone('DateTimeZone', String),

  /// Option name exposureCompensation
  exposureCompensation('ExposureCompensation', ExposureCompensationEnum),

  /// Option name exposureDelay
  exposureDelay('ExposureDelay', ExposureDelayEnum),

  /// Option name exposureProgram
  exposureProgram('ExposureProgram', ExposureProgramEnum),

  /// Option name fileFormat
  fileFormat('FileFormat', FileFormatEnum),

  /// Option name _filter
  filter('Filter', FilterEnum),

  /// Option name gpsInfo
  gpsInfo('GpsInfo', GpsInfo),

  /// Option name _gpsTagRecording
  /// 
  /// For RICOH THETA X or later
  isGpsOn('IsGpsOn', bool),

  /// Option name iso
  iso('Iso', IsoEnum),

  /// Option name isoAutoHighLimit
  isoAutoHighLimit('IsoAutoHighLimit', IsoAutoHighLimitEnum),

  /// Option name _language
  language('Language', LanguageEnum),

  /// Option name _maxRecordableTime
  maxRecordableTime('MaxRecordableTime', MaxRecordableTimeEnum),

  /// Option name offDelay
  offDelay('OffDelay', OffDelayEnum),

  /// Option name sleepDelay
  sleepDelay('SleepDelay', SleepDelayEnum),

  /// Option name remainingPictures
  remainingPictures('RemainingPictures', int),

  /// Option name remainingVideoSeconds
  remainingVideoSeconds('RemainingVideoSeconds', int),

  /// Option name remainingSpace
  remainingSpace('RemainingSpace', int),

  /// Option name totalSpace
  totalSpace('TotalSpace', int),

  /// Option name _shutterVolume
  shutterVolume('ShutterVolume', int),

  /// Option name whiteBalance
  whiteBalance('WhiteBalance', WhiteBalanceEnum);

  final String rawValue;
  final dynamic valueType;
  const OptionNameEnum(this.rawValue, this.valueType);

  @override
  String toString() {
    return rawValue;
  }

  static OptionNameEnum? getValue(String rawValue) {
    return OptionNameEnum.values.cast<OptionNameEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Aperture value.
enum ApertureEnum {
  /// Aperture AUTO(0).
  apertureAuto('APERTURE_AUTO'),

  /// Aperture 2.0F.
  /// 
  /// RICOH THETA V or prior
  aperture_2_0('APERTURE_2_0'),

  /// Aperture 2.1F.
  /// 
  /// RICOH THETA Z1 and the exposure program [exposureProgram] is set to Manual or Aperture Priority
  aperture_2_1('APERTURE_2_1'),

  /// Aperture 2.4F.
  /// 
  /// RICOH THETA X or later
  aperture_2_4('APERTURE_2_4'),

  /// Aperture 3.5F.
  /// 
  /// RICOH THETA Z1 and the exposure program [exposureProgram] is set to Manual or Aperture Priority
  aperture_3_5('APERTURE_3_5'),

  /// Aperture 5.6F.
  /// 
  /// RICOH THETA Z1 and the exposure program [exposureProgram] is set to Manual or Aperture Priority
  aperture_5_6('APERTURE_5_6');

  final String rawValue;
  const ApertureEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static ApertureEnum? getValue(String rawValue) {
    return ApertureEnum.values.cast<ApertureEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Shooting mode.
enum CaptureModeEnum {
  /// Shooting mode. Still image capture mode
  image('IMAGE'),

  /// Shooting mode. Video capture mode
  video('VIDEO');

  final String rawValue;
  const CaptureModeEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static CaptureModeEnum? getValue(String rawValue) {
    return CaptureModeEnum.values.cast<CaptureModeEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Exposure compensation (EV).
enum ExposureCompensationEnum {
  /// Exposure compensation -2.0
  m2_0('M2_0'),

  /// Exposure compensation -1.7
  m1_7('M1_7'),

  /// Exposure compensation -1.3
  m1_3('M1_3'),

  /// Exposure compensation -1.0
  m1_0('M1_0'),

  /// Exposure compensation -0.7
  m0_7('M0_7'),

  /// Exposure compensation -0.3
  m0_3('M0_3'),

  /// Exposure compensation 0.0
  zero('ZERO'),

  /// Exposure compensation 0.3
  p0_3('P0_3'),

  /// Exposure compensation 0.7
  p0_7('P0_7'),

  /// Exposure compensation 1.0
  p1_0('P1_0'),

  /// Exposure compensation 1.3
  p1_3('P1_3'),

  /// Exposure compensation 1.7
  p1_7('P1_7'),

  /// Exposure compensation 2.0
  p2_0('P2_0');

  final String rawValue;
  const ExposureCompensationEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static ExposureCompensationEnum? getValue(String rawValue) {
    return ExposureCompensationEnum.values.cast<ExposureCompensationEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Operating time (sec.) of the self-timer.
enum ExposureDelayEnum {
  /// Disable self-timer.
  delayOff('DELAY_OFF'),

  /// Self-timer time. 1sec.
  delay1('DELAY_1'),

  /// Self-timer time. 2sec.
  delay2('DELAY_2'),

  /// Self-timer time. 3sec.
  delay3('DELAY_3'),

  /// Self-timer time. 4sec.
  delay4('DELAY_4'),

  /// Self-timer time. 5sec.
  delay5('DELAY_5'),

  /// Self-timer time. 6sec.
  delay6('DELAY_6'),

  /// Self-timer time. 7sec.
  delay7('DELAY_7'),

  /// Self-timer time. 8sec.
  delay8('DELAY_8'),

  /// Self-timer time. 9sec.
  delay9('DELAY_9'),

  /// Self-timer time. 10sec.
  delay10('DELAY_10');

  final String rawValue;
  const ExposureDelayEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static ExposureDelayEnum? getValue(String rawValue) {
    return ExposureDelayEnum.values.cast<ExposureDelayEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Exposure program. The exposure settings that take priority can be selected.
/// 
/// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
/// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
enum ExposureProgramEnum {
  /// Manual program
  /// 
  /// Manually set the ISO sensitivity (iso) setting, shutter speed (shutterSpeed) and aperture (aperture, RICOH THETA Z1).
  manual('MANUAL'),

  /// Normal program
  /// 
  /// Exposure settings are all set automatically.
  normalProgram('NORMAL_PROGRAM'),

  /// Aperture priority program
  /// 
  /// Manually set the aperture (aperture).
  /// (RICOH THETA Z1)
  aperturePriority('APERTURE_PRIORITY'),

  /// Shutter priority program
  /// 
  /// Manually set the shutter speed (shutterSpeed).
  shutterPriority('SHUTTER_PRIORITY'),

  /// ISO priority program
  /// 
  /// Manually set the ISO sensitivity (iso) setting.
  isoPriority('ISO_PRIORITY');

  final String rawValue;
  const ExposureProgramEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static ExposureProgramEnum? getValue(String rawValue) {
    return ExposureProgramEnum.values.cast<ExposureProgramEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// File format used in shooting.
enum FileFormatEnum {
  /// Image File format.
  /// type: jpeg
  /// size: 2048 x 1024
  /// 
  /// For RICOH THETA S or SC
  image_2K('IMAGE_2K'),

  /// Image File format.
  /// type: jpeg
  /// size: 5376 x 2688
  /// 
  /// For RICOH THETA V or S or SC
  image_5K('IMAGE_5K'),

  /// Image File format.
  /// type: jpeg
  /// size: 6720 x 3360
  /// 
  /// For RICOH THETA Z1
  image_6_7K('IMAGE_6_7K'),

  /// Image File format.
  /// type: raw+
  /// size: 6720 x 3360
  /// 
  /// For RICOH THETA Z1
  rawP_6_7K('RAW_P_6_7K'),

  /// Image File format.
  /// type: jpeg
  /// size: 5504 x 2752
  /// 
  /// For RICOH THETA X or later
  image_5_5K('IMAGE_5_5K'),

  /// Image File format.
  /// type: jpeg
  /// size: 11008 x 5504
  /// 
  /// For RICOH THETA X or later
  image_11K('IMAGE_11K'),

  /// Video File format.
  /// type: mp4
  /// size: 1280 x 570
  /// 
  /// For RICOH THETA S or SC
  videoHD('VIDEO_HD'),

  /// Video File format.
  /// type: mp4
  /// size: 1920 x 1080
  /// 
  /// For RICOH THETA S or SC
  videoFullHD('VIDEO_FULL_HD'),

  /// Video File format.
  /// type: mp4
  /// size: 1920 x 960
  /// codec: H.264/MPEG-4 AVC
  /// 
  /// For RICOH THETA Z1 or V
  video_2K('VIDEO_2K'),

  /// Video File format.
  /// type: mp4
  /// size: 3840 x 1920
  /// codec: H.264/MPEG-4 AVC
  /// 
  /// For RICOH THETA Z1 or V
  video_4K('VIDEO_4K'),

  /// Video File format.
  /// type: mp4
  /// size: 1920 x 960
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 30
  /// 
  /// For RICOH THETA X or later
  video_2K_30F('VIDEO_2K_30F'),

  /// Video File format.
  /// type: mp4
  /// size: 1920 x 960
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 60
  /// 
  /// For RICOH THETA X or later
  video_2K_60F('VIDEO_2K_60F'),

  /// Video File format.
  /// type: mp4
  /// size: 3840 x 1920
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 30
  /// 
  /// For RICOH THETA X or later
  video_4K_30F('VIDEO_4K_30F'),

  /// Video File format.
  /// type: mp4
  /// size: 3840 x 1920
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 60
  /// 
  /// For RICOH THETA X or later
  video_4K_60F('VIDEO_4K_60F'),

  /// Video File format.
  /// type: mp4
  /// size: 5760 x 2880
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 2
  /// 
  /// For RICOH THETA X or later
  video_5_7K_2F('VIDEO_5_7K_2F'),

  /// Video File format.
  /// type: mp4
  /// size: 5760 x 2880
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 5
  /// 
  /// For RICOH THETA X or later
  video_5_7K_5F('VIDEO_5_7K_5F'),

  /// Video File format.
  /// type: mp4
  /// size: 5760 x 2880
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 30
  /// 
  /// For RICOH THETA X or later
  video_5_7K_30F('VIDEO_5_7K_30F'),

  /// Video File format.
  /// type: mp4
  /// size: 7680 x 3840
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 2
  /// 
  /// For RICOH THETA X or later
  video_7K_2F('VIDEO_7K_2F'),

  /// Video File format.
  /// type: mp4
  /// size: 7680 x 3840
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 5
  /// 
  /// For RICOH THETA X or later
  video_7K_5F('VIDEO_7K_5F'),

  /// Video File format.
  /// type: mp4
  /// size: 7680 x 3840
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 10
  /// 
  /// For RICOH THETA X or later
  video_7K_10F('VIDEO_7K_10F');

  final String rawValue;
  const FileFormatEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static FileFormatEnum? getValue(String rawValue) {
    return FileFormatEnum.values.cast<FileFormatEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Image processing filter.
enum FilterEnum {
  /// Image processing filter. No filter.
  off('OFF'),

  /// Image processing filter. Noise reduction.
  noiseReduction('NOISE_REDUCTION'),

  /// Image processing filter. HDR.
  hdr('HDR');

  final String rawValue;
  const FilterEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static FilterEnum? getValue(String rawValue) {
    return FilterEnum.values.cast<FilterEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// ISO sensitivity.
/// 
/// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
/// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
/// 
/// When the exposure program [exposureProgram] is set to Manual or ISO Priority
enum IsoEnum {
  /// ISO sensitivity. AUTO (0)
  isoAuto('ISO_AUTO'),

  /// ISO sensitivity. ISO 50
  /// 
  /// For RICOH THETA X or later
  iso50('ISO_50'),

  /// ISO sensitivity. ISO 64
  /// 
  /// For RICOH THETA V or X or later
  iso64('ISO_64'),

  /// ISO sensitivity. ISO 80
  /// 
  /// For RICOH THETA V or Z1 or X or later
  iso80('ISO_80'),

  /// ISO sensitivity. ISO 100
  iso100('ISO_100'),

  /// ISO sensitivity. ISO 125
  iso125('ISO_125'),

  /// ISO sensitivity. ISO 160
  iso160('ISO_160'),

  /// ISO sensitivity. ISO 200
  iso200('ISO_200'),

  /// ISO sensitivity. ISO 250
  iso250('ISO_250'),

  /// ISO sensitivity. ISO 320
  iso320('ISO_320'),

  /// ISO sensitivity. ISO 400
  iso400('ISO_400'),

  /// ISO sensitivity. ISO 500
  iso500('ISO_500'),

  /// ISO sensitivity. ISO 640
  iso640('ISO_640'),

  /// ISO sensitivity. ISO 800
  iso800('ISO_800'),

  /// ISO sensitivity. ISO 1000
  iso1000('ISO_1000'),

  /// ISO sensitivity. ISO 1250
  iso1250('ISO_1250'),

  /// ISO sensitivity. ISO 1600
  iso1600('ISO_1600'),

  /// ISO sensitivity. ISO 2000
  /// 
  /// For RICOH THETA V or Z1 or X or later
  iso2000('ISO_2000'),

  /// ISO sensitivity. ISO 2500
  /// 
  /// For RICOH THETA V or Z1 or X or later
  iso2500('ISO_2500'),

  /// ISO sensitivity. ISO 3200
  /// 
  /// For RICOH THETA V or Z1 or X or later
  iso3200('ISO_3200'),

  /// ISO sensitivity. ISO 4000
  /// 
  /// For RICOH THETA Z1
  /// For RICOH THETA V, Available in video shooting mode.
  iso4000('ISO_4000'),

  /// ISO sensitivity. ISO 5000
  /// 
  /// For RICOH THETA Z1
  /// For RICOH THETA V, Available in video shooting mode.
  iso5000('ISO_5000'),

  /// ISO sensitivity. ISO 6400
  /// 
  /// For RICOH THETA Z1
  /// For RICOH THETA V, Available in video shooting mode.
  iso6400('ISO_6400');

  final String rawValue;
  const IsoEnum(this.rawValue);
  @override

  String toString() {
    return rawValue;
  }

  static IsoEnum? getValue(String rawValue) {
    return IsoEnum.values.cast<IsoEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
/// 
/// 100*1, 125*1, 160*1, 200, 250, 320, 400, 500, 640, 800, 1000, 1250, 1600, 2000, 2500, 3200, 4000*2, 5000*2, 6400*2
/// *1 Enabled only with RICOH THETA X.
/// *2 Enabled with RICOH THETA Z1's image shooting mode and video shooting mode, and with RICOH THETA V's video shooting mode.
enum IsoAutoHighLimitEnum {
  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 100
  /// 
  /// Enabled only with RICOH THETA X.
  iso100('ISO_100'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 125
  /// 
  /// Enabled only with RICOH THETA X.
  iso125('ISO_125'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 160
  /// 
  /// Enabled only with RICOH THETA X.
  iso160('ISO_160'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 200
  iso200('ISO_200'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 250
  iso250('ISO_250'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 320
  iso320('ISO_320'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 400
  iso400('ISO_400'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 500
  iso500('ISO_500'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 640
  iso640('ISO_640'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 800
  iso800('ISO_800'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 1000
  iso1000('ISO_1000'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 1250
  iso1250('ISO_1250'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 1600
  iso1600('ISO_1600'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 2000
  iso2000('ISO_2000'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 2500
  iso2500('ISO_2500'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 3200
  iso3200('ISO_3200'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 4000
  /// 
  /// Enabled with RICOH THETA Z1's image shooting mode and video shooting mode, and with RICOH THETA V's video shooting mode.
  iso4000('ISO_4000'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 5000
  /// 
  /// Enabled with RICOH THETA Z1's image shooting mode and video shooting mode, and with RICOH THETA V's video shooting mode.
  iso5000('ISO_5000'),

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  /// ISO 6400
  /// 
  /// Enabled with RICOH THETA Z1's image shooting mode and video shooting mode, and with RICOH THETA V's video shooting mode.
  iso6400('ISO_6400');

  final String rawValue;
  const IsoAutoHighLimitEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static IsoAutoHighLimitEnum? getValue(String rawValue) {
    return IsoAutoHighLimitEnum.values.cast<IsoAutoHighLimitEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Language used in camera OS.
enum LanguageEnum {
  /// Language used in camera OS.
  /// de
  de('DE'),

  /// Language used in camera OS.
  /// en-GB
  enGB('EN_GB'),

  /// Language used in camera OS.
  /// en-US
  enUS('EN_US'),

  /// Language used in camera OS.
  /// fr
  fr('FR'),

  /// Language used in camera OS.
  /// it
  it('IT'),

  /// Language used in camera OS.
  /// ja
  ja('JA'),

  /// Language used in camera OS.
  /// ko
  ko('KO'),

  /// Language used in camera OS.
  /// zh-CN
  zhCN('ZH_CN'),

  /// Language used in camera OS.
  /// zh-TW
  zhTW('ZH_TW');

  final String rawValue;
  const LanguageEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static LanguageEnum? getValue(String rawValue) {
    return LanguageEnum.values.cast<LanguageEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Maximum recordable time (in seconds) of the camera.
enum MaxRecordableTimeEnum {
  /// Maximum recordable time. 180sec for SC2 only.
  time_180('RECORDABLE_TIME_180'),

  /// Maximum recordable time. 300sec for other than SC2.
  time_300('RECORDABLE_TIME_300'),

  /// Maximum recordable time. 1500sec for other than SC2.
  time_1500('RECORDABLE_TIME_1500');

  final String rawValue;
  const MaxRecordableTimeEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static MaxRecordableTimeEnum? getValue(String rawValue) {
    return MaxRecordableTimeEnum.values.cast<MaxRecordableTimeEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Length of standby time before the camera automatically powers OFF.
/// 
/// For RICOH THETA V or later
enum OffDelayEnum {
  /// Do not turn power off.
  disable('DISABLE', 65535),

  /// Power off after 5 minutes.(300sec)
  offDelay_5m('OFF_DELAY_5M', 300),

  /// Power off after 10 minutes.(600sec)
  offDelay_10m('OFF_DELAY_10M', 600),

  /// Power off after 15 minutes.(900sec)
  offDelay_15m('OFF_DELAY_15M', 900),

  /// Power off after 30 minutes.(1,800sec)
  offDelay_30m('OFF_DELAY_30M', 1800);

  final String rawValue;
  final int sec;
  const OffDelayEnum(this.rawValue, this.sec);
  @override
  String toString() {
    return rawValue;
  }
  static OffDelayEnum? getValueWithSec(int sec) {
    return OffDelayEnum.values.cast<OffDelayEnum?>().firstWhere((element) => element?.sec == sec, orElse: () => null);
  }

  static OffDelayEnum? getValue(String rawValue) {
    return OffDelayEnum.values.cast<OffDelayEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Length of standby time before the camera enters the sleep mode.
enum SleepDelayEnum {
  /// Do not turn sleep mode.
  disable('DISABLE', 65535),

  /// Sleep mode after 3 minutes.(180sec)
  sleepDelay_3m('SLEEP_DELAY_3M', 180),

  /// Sleep mode after 5 minutes.(300sec)
  sleepDelay_5m('SLEEP_DELAY_5M', 300),

  /// Sleep mode after 7 minutes.(420sec)
  sleepDelay_7m('SLEEP_DELAY_7M', 420),

  /// Sleep mode after 10 minutes.(600sec)
  sleepDelay_10m('SLEEP_DELAY_10M', 600);

  final String rawValue;
  final int sec;
  const SleepDelayEnum(this.rawValue, this.sec);
  @override
  String toString() {
    return rawValue;
  }
  static SleepDelayEnum? getValueWithSec(int sec) {
    return SleepDelayEnum.values.cast<SleepDelayEnum?>().firstWhere((element) => element?.sec == sec, orElse: () => null);
  }

  static SleepDelayEnum? getValue(String rawValue) {
    return SleepDelayEnum.values.cast<SleepDelayEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// White balance.
/// 
/// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
/// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
enum WhiteBalanceEnum {
  /// White balance.
  /// Automatic
  auto('AUTO'),

  /// White balance.
  /// Outdoor
  daylight('DAYLIGHT'),

  /// White balance.
  /// Shade
  sade('SHADE'),

  /// White balance.
  /// Cloudy
  cloudyDaylight('CLOUDY_DAYLIGHT'),

  /// White balance.
  /// Incandescent light 1
  incandescent('INCANDESCENT'),

  /// White balance.
  /// Incandescent light 2
  warmWhiteFluorescent('WARM_WHITE_FLUORESCENT'),

  /// White balance.
  /// Fluorescent light 1 (daylight)
  daylightFluorescent('DAYLIGHT_FLUORESCENT'),

  /// White balance.
  /// Fluorescent light 2 (natural white)
  daywhiteFluorescent('DAYWHITE_FLUORESCENT'),

  /// White balance.
  /// Fluorescent light 3 (white)
  fluorescent('FLUORESCENT'),

  /// White balance.
  /// Fluorescent light 4 (light bulb color)
  bulbFluorescent('BULB_FLUORESCENT'),

  /// White balance.
  /// CT settings (specified by the _colorTemperature option)
  /// 
  /// RICOH THETA S firmware v01.82 or later and RICOH THETA SC firmware v01.10 or later
  colorTemperature('COLOR_TEMPERATURE'),

  /// White balance.
  /// Underwater
  /// 
  /// RICOH THETA V firmware v3.21.1 or later
  underwater('UNDERWATER');

  final String rawValue;
  const WhiteBalanceEnum(this.rawValue);

  @override
  String toString() {
    return rawValue;
  }

  static WhiteBalanceEnum? getValue(String rawValue) {
    return WhiteBalanceEnum.values.cast<WhiteBalanceEnum?>().firstWhere((element) => element?.rawValue == rawValue, orElse: () => null);
  }
}

/// Turns position information assigning ON/OFF.
/// 
/// For RICOH THETA X
enum GpsTagRecordingEnum {
  /// Position information assigning ON.
  on('ON'), 

  /// Position information assigning OFF.
  off('OFF');

  final String rawValue;
  const GpsTagRecordingEnum(this.rawValue);
  @override
  String toString() {
    return rawValue;
  }
}

/// Photo image format used in PhotoCapture.
enum PhotoFileFormatEnum {
  /// Image File format.
  /// type: jpeg
  /// size: 2048 x 1024
  /// 
  /// For RICOH THETA S or SC
  image_2K('IMAGE_2K'),

  /// Image File format.
  /// type: jpeg
  /// size: 5376 x 2688
  /// 
  /// For RICOH THETA V or S or SC
  image_5K('IMAGE_5K'),

  /// Image File format.
  /// type: jpeg
  /// size: 6720 x 3360
  /// 
  /// For RICOH THETA Z1
  image_6_7K('IMAGE_6_7K'),

  /// Image File format.
  /// type: raw+
  /// size: 6720 x 3360
  /// 
  /// For RICOH THETA Z1
  rawP_6_7K('RAW_P_6_7K'),

  /// Image File format.
  /// type: jpeg
  /// size: 5504 x 2752
  /// 
  /// For RICOH THETA X or later
  image_5_5K('IMAGE_5_5K'),

  /// Image File format.
  /// type: jpeg
  /// size: 11008 x 5504
  /// 
  /// For RICOH THETA X or later
  image_11K('IMAGE_11K');

  final String rawValue;
  const PhotoFileFormatEnum(this.rawValue);
  @override
  String toString() {
    return rawValue;
  }
}

/// Video image format used in VideoCapture.
enum VideoFileFormatEnum {
  /// Video File format.
  /// type: mp4
  /// size: 1280 x 570
  /// 
  /// For RICOH THETA S or SC
  videoHD('VIDEO_HD'),

  /// Video File format.
  /// type: mp4
  /// size: 1920 x 1080
  /// 
  /// For RICOH THETA S or SC
  videoFullHD('VIDEO_FULL_HD'),

  /// Video File format.
  /// type: mp4
  /// size: 1920 x 960
  /// codec: H.264/MPEG-4 AVC
  /// 
  /// For RICOH THETA Z1 or V
  video_2K('VIDEO_2K'),

  /// Video File format.
  /// type: mp4
  /// size: 3840 x 1920
  /// codec: H.264/MPEG-4 AVC
  /// 
  /// For RICOH THETA Z1 or V
  video_4K('VIDEO_4K'),

  /// Video File format.
  /// type: mp4
  /// size: 1920 x 960
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 30
  /// 
  /// For RICOH THETA X or later
  video_2K_30F('VIDEO_2K_30F'),

  /// Video File format.
  /// type: mp4
  /// size: 1920 x 960
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 60
  /// 
  /// For RICOH THETA X or later
  video_2K_60F('VIDEO_2K_60F'),

  /// Video File format.
  /// type: mp4
  /// size: 3840 x 1920
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 30
  /// 
  /// For RICOH THETA X or later
  video_4K_30F('VIDEO_4K_30F'),

  /// Video File format.
  /// type: mp4
  /// size: 3840 x 1920
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 60
  /// 
  /// For RICOH THETA X or later
  video_4K_60F('VIDEO_4K_60F'),

  /// Video File format.
  /// type: mp4
  /// size: 5760 x 2880
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 2
  /// 
  /// For RICOH THETA X or later
  video_5_7K_2F('VIDEO_5_7K_2F'),

  /// Video File format.
  /// type: mp4
  /// size: 5760 x 2880
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 5
  /// 
  /// For RICOH THETA X or later
  video_5_7K_5F('VIDEO_5_7K_5F'),

  /// Video File format.
  /// type: mp4
  /// size: 5760 x 2880
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 30
  /// 
  /// For RICOH THETA X or later
  video_5_7K_30F('VIDEO_5_7K_30F'),

  /// Video File format.
  /// type: mp4
  /// size: 7680 x 3840
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 2
  /// 
  /// For RICOH THETA X or later
  video_7K_2F('VIDEO_7K_2F'),

  /// Video File format.
  /// type: mp4
  /// size: 7680 x 3840
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 5
  /// 
  /// For RICOH THETA X or later
  video_7K_5F('VIDEO_7K_5F'),

  /// Video File format.
  /// type: mp4
  /// size: 7680 x 3840
  /// codec: H.264/MPEG-4 AVC
  /// frame rate: 10
  /// 
  /// For RICOH THETA X or later
  video_7K_10F('VIDEO_7K_10F');

  final String rawValue;
  const VideoFileFormatEnum(this.rawValue);
  @override
  String toString() {
    return rawValue;
  }
}

/// GPS information.
/// 65535 is set for latitude and longitude when disabling the GPS setting at
/// RICOH THETA Z1 and prior.
/// 
/// For RICOH THETA X, ON/OFF for assigning position information is
/// set at [Options.isGpsOn]
class GpsInfo {

  /// Latitude (-90.000000 – 90.000000)
  /// When GPS is disabled: 65535
  double latitude;

  /// Longitude (-180.000000 – 180.000000)
  /// When GPS is disabled: 65535
  double longitude;

  /// Altitude (meters)
  /// When GPS is disabled: 0
  double altitude;

  /// Location information acquisition time
  /// YYYY:MM:DD hh:mm:ss+(-)hh:mm
  /// hh is in 24-hour time, +(-)hh:mm is the time zone
  /// when GPS is disabled: ""(null characters)
  String dateTimeZone;

  GpsInfo(this.latitude, this.longitude, this.altitude, this.dateTimeZone);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
  
  @override
  int get hashCode => Object.hashAll([latitude, longitude, altitude, dateTimeZone]);
}

/// Camera setting options.
/// 
/// Refer to the [options category](https://github.com/ricohapi/theta-api-specs/blob/main/theta-web-api-v2.1/options.md)
class Options {
  /// Aperture value.
  ApertureEnum? aperture;

  /// Shooting mode.
  CaptureModeEnum? captureMode;

  /// Color temperature of the camera (Kelvin).
  /// 
  /// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
  /// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
  /// 
  /// Support value
  /// 2500 to 10000. In 100-Kelvin units.
  int? colorTemperature;

  /// Current system time of RICOH THETA. Setting another options will result in an error.
  /// 
  /// With RICOH THETA X camera.setOptions can be changed only when Date/time setting is AUTO in menu UI.
  /// 
  /// Time format
  /// YYYY:MM:DD hh:mm:ss+(-)hh:mm
  /// hh is in 24-hour time, +(-)hh:mm is the time zone.
  /// e.g. 2014:05:18 01:04:29+08:00
  String? dateTimeZone;

  /// Exposure compensation (EV).
  /// 
  /// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
  /// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
  ExposureCompensationEnum? exposureCompensation;

  /// Operating time (sec.) of the self-timer.
  /// 
  /// If exposureDelay is enabled, self-timer is used by shooting.
  /// If exposureDelay is disabled, use _latestEnabledExposureDelayTime to
  /// get the operating time of the self-timer stored in the camera.
  ExposureDelayEnum? exposureDelay;

  /// Exposure program. The exposure settings that take priority can be selected.
  /// 
  /// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
  /// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
  ExposureProgramEnum? exposureProgram;

  /// Image format used in shooting.
  /// 
  /// The supported value depends on the shooting mode [captureMode].
  FileFormatEnum? fileFormat;

  /// Image processing filter.
  /// 
  /// Configured the filter will be applied while in still image shooting mode.
  /// However, it is disabled during interval shooting, interval composite group shooting,
  /// multi bracket shooting or continuous shooting.
  /// 
  /// When filter is enabled, it takes priority over the exposure program [exposureProgram].
  /// Also, when filter is enabled, the exposure program is set to the Normal program.
  /// 
  /// The condition below will result in an error.
  /// [fileFormat] is raw+ and _filter is Noise reduction, HDR or Handheld HDR
  /// shootingMethod is except for Normal shooting and [filter] is enabled
  /// Access during video capture mode
  FilterEnum? filter;

  /// GPS location information.
  /// 
  /// In order to append the location information, this property should be specified by the client.
  GpsInfo? gpsInfo;

  /// Turns position information assigning ON/OFF.
  /// For THETA X
  bool? isGpsOn;

  /// Turns position information assigning ON/OFF.
  /// 
  /// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
  /// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
  /// 
  /// When the exposure program [exposureProgram] is set to Manual or ISO Priority
  IsoEnum? iso;

  /// ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  IsoAutoHighLimitEnum? isoAutoHighLimit;

  /// Language used in camera OS.
  LanguageEnum? language;

  /// Maximum recordable time (in seconds) of the camera.
  MaxRecordableTimeEnum? maxRecordableTime;

  /// Length of standby time before the camera automatically powers OFF.
  /// 
  /// Specify [OffDelayEnum]
  OffDelayEnum? offDelay;

  /// Length of standby time before the camera enters the sleep mode.
  SleepDelayEnum? sleepDelay;

  /// The estimated remaining number of shots for the current shooting settings.
  int? remainingPictures;

  /// The estimated remaining shooting time (sec.) for the current video shooting settings.
  int? remainingVideoSeconds;

  /// Remaining usable storage space (byte).
  int? remainingSpace;

  /// Total storage space (byte).
  int? totalSpace;

  /// Shutter volume.
  /// 
  /// Support value
  /// 0: Minimum volume (minShutterVolume)
  /// 100: Maximum volume (maxShutterVolume)
  int? shutterVolume;

  /// White balance.
  /// 
  /// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
  /// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
  WhiteBalanceEnum? whiteBalance;

  /// Get Option value.
  T? getValue<T>(OptionNameEnum name) {
    switch (name) {
      case OptionNameEnum.aperture:
        return aperture as T;
      case OptionNameEnum.captureMode:
        return captureMode as T;
      case OptionNameEnum.colorTemperature:
        return colorTemperature as T;
      case OptionNameEnum.dateTimeZone:
        return dateTimeZone as T;
      case OptionNameEnum.exposureCompensation:
        return exposureCompensation as T;
      case OptionNameEnum.exposureDelay:
        return exposureDelay as T;
      case OptionNameEnum.exposureProgram:
        return exposureProgram as T;
      case OptionNameEnum.fileFormat:
        return fileFormat as T;
      case OptionNameEnum.filter:
        return filter as T;
      case OptionNameEnum.gpsInfo:
        return gpsInfo as T;
      case OptionNameEnum.isGpsOn:
        return isGpsOn as T;
      case OptionNameEnum.iso:
        return iso as T;
      case OptionNameEnum.isoAutoHighLimit:
        return isoAutoHighLimit as T;
      case OptionNameEnum.language:
        return language as T;
      case OptionNameEnum.maxRecordableTime:
        return maxRecordableTime as T;
      case OptionNameEnum.offDelay:
        return offDelay as T;
      case OptionNameEnum.sleepDelay:
        return sleepDelay as T;
      case OptionNameEnum.remainingPictures:
        return remainingPictures as T;
      case OptionNameEnum.remainingVideoSeconds:
        return remainingVideoSeconds as T;
      case OptionNameEnum.remainingSpace:
        return remainingSpace as T;
      case OptionNameEnum.totalSpace:
        return totalSpace as T;
      case OptionNameEnum.shutterVolume:
        return shutterVolume as T;
      case OptionNameEnum.whiteBalance:
        return whiteBalance as T;
    }
  }

  /// Set option value.
  setValue(OptionNameEnum name, dynamic value) {
    if (name.valueType != value.runtimeType) {
      throw Exception('Invalid value type');
    }

    switch (name) {
      case OptionNameEnum.aperture:
        aperture = value;
        break;
      case OptionNameEnum.captureMode:
        captureMode = value;
        break;
      case OptionNameEnum.colorTemperature:
        colorTemperature = value;
        break;
      case OptionNameEnum.dateTimeZone:
        dateTimeZone = value;
        break;
      case OptionNameEnum.exposureCompensation:
        exposureCompensation = value;
        break;
      case OptionNameEnum.exposureDelay:
        exposureDelay = value;
        break;
      case OptionNameEnum.exposureProgram:
        exposureProgram = value;
        break;
      case OptionNameEnum.fileFormat:
        fileFormat = value;
        break;
      case OptionNameEnum.filter:
        filter = value;
        break;
      case OptionNameEnum.gpsInfo:
        gpsInfo = value;
        break;
      case OptionNameEnum.isGpsOn:
        isGpsOn = value;
        break;
      case OptionNameEnum.iso:
        iso = value;
        break;
      case OptionNameEnum.isoAutoHighLimit:
        isoAutoHighLimit = value;
        break;
      case OptionNameEnum.language:
        language = value;
        break;
      case OptionNameEnum.maxRecordableTime:
        maxRecordableTime = value;
        break;
      case OptionNameEnum.offDelay:
        offDelay = value;
        break;
      case OptionNameEnum.sleepDelay:
        sleepDelay = value;
        break;
      case OptionNameEnum.remainingPictures:
        remainingPictures = value;
        break;
      case OptionNameEnum.remainingVideoSeconds:
        remainingVideoSeconds = value;
        break;
      case OptionNameEnum.remainingSpace:
        remainingSpace = value;
        break;
      case OptionNameEnum.totalSpace:
        totalSpace = value;
        break;
      case OptionNameEnum.shutterVolume:
        shutterVolume = value;
        break;
      case OptionNameEnum.whiteBalance:
        whiteBalance = value;
        break;
    }
  }
}

/// Capture
class Capture {
  /// options of capture
  final Map<String, dynamic> _options;

  /// Get aperture value.
  ApertureEnum? getAperture() => _options[OptionNameEnum.aperture.rawValue];

  /// Get color temperature of the camera (Kelvin).
  int? getColorTemperature() => _options[OptionNameEnum.colorTemperature.rawValue];

  /// Get exposure compensation (EV).
  ExposureCompensationEnum? getExposureCompensation() => _options[OptionNameEnum.exposureCompensation.rawValue];

  /// Get operating time (sec.) of the self-timer.
  ExposureDelayEnum? getExposureDelay() => _options[OptionNameEnum.exposureDelay.rawValue];

  /// Get exposure program.
  ExposureProgramEnum? getExposureProgram() => _options[OptionNameEnum.exposureProgram.rawValue];

  /// Get GPS information.
  GpsInfo? getGpsInfo() => _options[OptionNameEnum.gpsInfo.rawValue];

  /// Get turns position information assigning ON/OFF.
  GpsTagRecordingEnum? getGpsTagRecording() => _options[TagNameEnum.gpsTagRecording.rawValue];

  /// Set ISO sensitivity.
  /// 
  /// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
  /// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
  /// 
  /// When the exposure program (exposureProgram) is set to Manual or ISO Priority
  IsoEnum? getIso() => _options[OptionNameEnum.iso.rawValue];

  /// Get ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  IsoAutoHighLimitEnum? getIsoAutoHighLimit() => _options[OptionNameEnum.isoAutoHighLimit.rawValue];

  /// Get white balance.
  WhiteBalanceEnum? getWhiteBalance() => _options[OptionNameEnum.whiteBalance.rawValue];

  Capture(this._options);
}

/// Builder
class CaptureBuilder<T> {
  /// options of capture
  final Map<String, dynamic> _options = {};

  /// Set aperture value.
  T setAperture(ApertureEnum aperture) {
    _options[OptionNameEnum.aperture.rawValue] = aperture;
    return this as T;
  }

  /// Set color temperature of the camera (Kelvin).
  /// 
  /// 2500 to 10000. In 100-Kelvin units.
  T setColorTemperature(int kelvin) {
    _options[OptionNameEnum.colorTemperature.rawValue] = kelvin;
    return this as T;
  }

  /// Set exposure compensation (EV).
  T setExposureCompensation(ExposureCompensationEnum value) {
    _options[OptionNameEnum.exposureCompensation.rawValue] = value;
    return this as T;
  }

  /// Set operating time (sec.) of the self-timer.
  T setExposureDelay(ExposureDelayEnum value) {
    _options[OptionNameEnum.exposureDelay.rawValue] = value;
    return this as T;
  }

  /// Set exposure program. The exposure settings that take priority can be selected.
  T setExposureProgram(ExposureProgramEnum program) {
    _options[OptionNameEnum.exposureProgram.rawValue] = program;
    return this as T;
  }

  /// Set GPS information.
  T setGpsInfo(GpsInfo gpsInfo) {
    _options[OptionNameEnum.gpsInfo.rawValue] = gpsInfo;
    return this as T;
  }

  /// Set turns position information assigning ON/OFF.
  /// 
  /// For RICOH THETA X
  T setGpsTagRecording(GpsTagRecordingEnum value) {
    _options[TagNameEnum.gpsTagRecording.rawValue] = value;
    return this as T;
  }

  /// Set ISO sensitivity.
  /// 
  /// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
  /// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
  /// 
  /// When the exposure program (exposureProgram) is set to Manual or ISO Priority
  T setIso(IsoEnum iso) {
    _options[OptionNameEnum.iso.rawValue] = iso;
    return this as T;
  }

  /// Set ISO sensitivity upper limit when ISO sensitivity is set to automatic.
  T setIsoAutoHighLimit(IsoAutoHighLimitEnum iso) {
    _options[OptionNameEnum.isoAutoHighLimit.rawValue] = iso;
    return this as T;
  }

  /// Set white balance.
  /// 
  /// It can be set for video shooting mode at RICOH THETA V firmware v3.00.1 or later.
  /// Shooting settings are retained separately for both the Still image shooting mode and Video shooting mode.
  T setWhiteBalance(WhiteBalanceEnum whiteBalance) {
    _options[OptionNameEnum.whiteBalance.rawValue] = whiteBalance;
    return this as T;
  }
}

/// Capturing
abstract class Capturing {
  /// Stops capture.
  void stopCapture();
}

/// Builder of [PhotoCapture]
class PhotoCaptureBuilder extends CaptureBuilder<PhotoCaptureBuilder> {
  /// Set photo file format.
  PhotoCaptureBuilder setFileFormat(PhotoFileFormatEnum fileFormat) {
    _options[TagNameEnum.photoFileFormat.rawValue] = fileFormat;
    return this;
  }

  /// Set image processing filter.
  PhotoCaptureBuilder setFilter(FilterEnum filter) {
    _options[OptionNameEnum.filter.rawValue] = filter;
    return this;
  }

  /// Builds an instance of a PhotoCapture that has all the combined parameters of the Options that have been added to the Builder.
  Future<PhotoCapture> build() async {
    var completer = Completer<PhotoCapture>();
    try {
      await ThetaClientFlutterPlatform.instance.buildPhotoCapture(_options);
      completer.complete(PhotoCapture(_options));
    } catch(e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}

/// Capture of Photo
class PhotoCapture extends Capture {
  PhotoCapture(super.options);

  /// Get image processing filter.
  FilterEnum? getFilter() {
    return _options[OptionNameEnum.filter.rawValue];
  }

  /// Get photo file format.
  PhotoFileFormatEnum? getFileFormat() {
    return _options[TagNameEnum.photoFileFormat.rawValue];
  }

  /// Take a picture.
  void takePicture(void Function(String fileUrl) onSuccess, void Function(Exception exception) onError) {
    ThetaClientFlutterPlatform.instance.takePicture()
      .then((value) => onSuccess(value!))
      .onError((error, stackTrace) => onError(error as Exception));
  }
}

/// Builder of VideoCapture
class VideoCaptureBuilder extends CaptureBuilder<VideoCaptureBuilder> {
  /// Set video file format.
  VideoCaptureBuilder setFileFormat(VideoFileFormatEnum fileFormat) {
    _options[TagNameEnum.videoFileFormat.rawValue] = fileFormat;
    return this;
  }

  /// Set maximum recordable time (in seconds) of the camera.
  VideoCaptureBuilder setMaxRecordableTime(MaxRecordableTimeEnum time) {
    _options[OptionNameEnum.maxRecordableTime.rawValue] = time;
    return this;
  }

  /// Builds an instance of a VideoCapture that has all the combined parameters of the Options that have been added to the Builder.
  Future<VideoCapture> build() async {
    var completer = Completer<VideoCapture>();
    try {
      await ThetaClientFlutterPlatform.instance.buildVideoCapture(_options);
      completer.complete(VideoCapture(_options));
    } catch(e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}

/// VideoCapturing
class VideoCapturing extends Capturing {
  /// Stops video capture.
  ///  When call stopCapture() then call property callback.
  @override
  void stopCapture() {
    ThetaClientFlutterPlatform.instance.stopVideoCapture();
  }
}

/// Capture of Video
class VideoCapture extends Capture {
  VideoCapture(super.options);

  /// Get maximum recordable time (in seconds) of the camera.
  MaxRecordableTimeEnum? getMaxRecordableTime() {
    return _options[OptionNameEnum.maxRecordableTime.rawValue];
  }

  /// Get video file format.
  VideoFileFormatEnum? getFileFormat() {
    return _options[TagNameEnum.videoFileFormat.rawValue];
  }

  /// Starts video capture.
  VideoCapturing startCapture(void Function(String fileUrl) onSuccess, void Function(Exception exception) onError) {
    ThetaClientFlutterPlatform.instance.startVideoCapture()
      .then((value) => onSuccess(value!))
      .onError((error, stackTrace) => onError(error as Exception));
    return VideoCapturing();
  }
}

/// Configuration of THETA
class ThetaConfig {
  String? dateTime;
  LanguageEnum? language;
  OffDelayEnum? offDelay;
  SleepDelayEnum? sleepDelay;
  int? shutterVolume;
}

/// Timeout of HTTP call.
class ThetaTimeout {
  /// Specifies a time period (in milliseconds) in
  /// which a client should establish a connection with a server.
  int connectTimeout = 20000;

  /// Specifies a time period (in milliseconds) required to process an HTTP call:
  /// from sending a request to receiving first response bytes.
  /// To disable this timeout, set its value to 0.
  int requestTimeout = 20000;

  /// Specifies a maximum time (in milliseconds) of inactivity between two data packets
  /// when exchanging data with a server.
  int socketTimeout = 20000;
}
