import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_usb_camera_method_channel.dart';

abstract class FlutterUsbCameraPlatform extends PlatformInterface {
  /// Constructs a FlutterUsbCameraPlatform.
  FlutterUsbCameraPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterUsbCameraPlatform _instance = MethodChannelFlutterUsbCamera();

  Stream<USBCameraEvent> get events;

  /// The default instance of [FlutterUsbCameraPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterUsbCamera].
  static FlutterUsbCameraPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterUsbCameraPlatform] when
  /// they register themselves.
  static set instance(FlutterUsbCameraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
    _instance.setMessageHandler();
  }

  void setMessageHandler();

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> takePicture(int deviceId) {
    throw UnimplementedError('takePicture() has not been implemented.');
  }

  Future<String?> captureVideoStart(int deviceId) {
    throw UnimplementedError('captureVideoStart() has not been implemented.');
  }

  Future<bool?> captureVideoStop(int deviceId) {
    throw UnimplementedError('captureVideoStop() has not been implemented.');
  }

  Future<bool?> isCameraOpened(int deviceId) {
    throw UnimplementedError('isCameraOpened() has not been implemented.');
  }

  Future<bool?> isRecordVideo(int deviceId) {
    throw UnimplementedError('isRecordVideo() has not been implemented.');
  }

  Future<int?> getZoom(int deviceId) {
    throw UnimplementedError('getZoom() has not been implemented.');
  }

  Future<bool?> setZoom(int deviceId, int zoom) {
    throw UnimplementedError('setZoom() has not been implemented.');
  }

  Future<bool?> startPreview(int deviceId) {
    throw UnimplementedError('startPreview() has not been implemented.');
  }

  Future<bool?> stopPreview(int deviceId) {
    throw UnimplementedError('stopPreview() has not been implemented.');
  }
}

class USBCameraEvent {
  String event;
  int? count;
  String? logString;
  USBCameraEvent(this.event, {this.count, this.logString});

  // 카메라가 변경되었습니다."
  static const String onUsbCameraChanged = "onUsbCameraChanged";
  // 로그가 변경되었습니다
  static const String onLogChanged = "onLogChanged";
}

class USBCameraDevice {}
