import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_usb_camera/flutter_usb_camera.dart';
import 'package:flutter_usb_camera/flutter_usb_camera_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class MicroscopeWidget extends StatefulWidget {
  // 이미지 경로 전달 콜백 함수
  final Function(String imagePath)? onImageCaptured;
  const MicroscopeWidget({Key? key, this.onImageCaptured}) : super(key: key);

  @override
  State<MicroscopeWidget> createState() => _MicroscopeWidgetState();
}

class _MicroscopeWidgetState extends State<MicroscopeWidget> {
  String _platformVersion = '알 수 없음';
  final _flutterUsbCameraPlugin = FlutterUsbCamera();
  late StreamSubscription _usbCameraBus;
  int deviceId = 0;
  String logStr = "";
  bool isShowLog = false;
  bool isWorking = false;
  bool isRecord = false;
  bool isTaking = false;
  int zoom = 0;
  bool isOpened = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _usbCameraBus = _flutterUsbCameraPlugin.events.listen((event) {
      if (event.event == USBCameraEvent.onUsbCameraChanged) {
        deviceId = event.count ?? 0;
        if (deviceId == 0) {
          isWorking = false;
          isRecord = false;
          isTaking = false;
          isOpened = false;
          zoom = 0;
        }
        setState(() {});
      } else if (event.event == USBCameraEvent.onLogChanged) {
        setState(() {
          logStr = event.logString ?? "";
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usbCameraBus.cancel();
  }

  // 플랫폼 메시지는 비동기적이므로 비동기 메소드에서 초기화합니다.
  Future<void> initPlatformState() async {
    String platformVersion;
    // 플랫폼 메시지가 실패할 수 있으므로 try/catch PlatformException을 사용합니다.
    // 또한 메시지가 null을 반환할 가능성을 다룹니다.
    try {
      platformVersion =
          await _flutterUsbCameraPlugin.getPlatformVersion() ?? '알 수 없는 플랫폼 버전';
    } on PlatformException {
      platformVersion = '플랫폼 버전을 가져오지 못했습니다.';
    }

    // 위젯이 비어 있을 때 비동기 플랫폼 메시지가 트리에서 제거되었다면 완료된 응답을 폐기하고 상태를 업데이트하지 않고
    // 응답을 폐기하려면 setState를 호출하지 않습니다.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "장치: $deviceId  ${deviceId > 0 ? "연결됨" : "연결되지 않음"}  "),
                    Text(
                      "실행: ${isWorking ? "작동 중" : "작동 중이 아님"}  ",
                      style: TextStyle(
                          color: isWorking ? Colors.red : Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (isWorking) {
                            return;
                          }

                          PermissionStatus status =
                              await Permission.camera.request();
                          if (status == PermissionStatus.granted) {
                            setState(() {
                              isWorking = true;
                            });
                            _flutterUsbCameraPlugin.startPreview(deviceId);
                          }
                        },
                        child: const Text('작동 시작')),
                    TextButton(
                        onPressed: () {
                          if (!isWorking) {
                            return;
                          }
                          setState(() {
                            isWorking = false;
                          });
                          _flutterUsbCameraPlugin.stopPreview(deviceId);
                        },
                        child: const Text('작동 중지')),
                  ],
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 400,
                    color: Colors.red.withOpacity(0.2),
                    child: deviceId > 0
                        ? AndroidView(
                            viewType: deviceId.toString(),
                          )
                        : null,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.camera_alt,
                  ),
                  label: Text('사진촬영'),
                  onPressed: () async {
                    if (isTaking || !isWorking) {
                      return;
                    }
                    bool? isOpened =
                        await _flutterUsbCameraPlugin.isCameraOpened(deviceId);
                    if (isOpened == true) {
                      PermissionStatus status =
                          await Permission.storage.request();

                      if (status == PermissionStatus.granted) {
                        setState(() {
                          isTaking = true;
                        });
                        _flutterUsbCameraPlugin
                            .takePicture(deviceId)
                            .then((value) {
                          if (kDebugMode) {
                            print("사진 촬영 성공: $value");
                          }
                          // 이미지 경로 전달 콜백 함수
                          if (widget.onImageCaptured != null) {
                            widget.onImageCaptured!(value!);
                          }
                        }).catchError((onError) {
                          if (kDebugMode) {
                            print("사진 촬영 실패: ${onError.toString}");
                          }
                        }).whenComplete(() {
                          setState(() {
                            isTaking = false;
                          });
                        });
                      }
                    }
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 10.0, // 아래에서부터의 거리
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[400])),
                  onPressed: () {
                    setState(() {
                      isShowLog = !isShowLog;
                    });
                  },
                  child: Text(
                    isShowLog ? '로그 숨기기' : '로그 표시',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            isShowLog
                ? Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Full width of the screen
                    height: MediaQuery.of(context).size.height *
                        0.8, // 80% of the screen height
                    color: Colors.black.withOpacity(0.5),
                    child: SingleChildScrollView(
                      child: Text(logStr),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
