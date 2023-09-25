import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aiffelthon_hair/flutter_uvc/lib/flutter_uvc.dart';
import 'package:aiffelthon_hair/flutter_uvc/lib/usb_device.dart';

import 'package:permission_handler/permission_handler.dart';

class MicroscopeWidget extends StatefulWidget {
  const MicroscopeWidget({Key? key}) : super(key: key);

  @override
  State<MicroscopeWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MicroscopeWidget> {
  String _platformVersion = 'Unknown';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await FlutterUvc.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

// 권한 확인 및 요청
    final cameraPermissionStatus = await Permission.camera.request();
    if (cameraPermissionStatus.isGranted) {
      // 카메라 권한이 승인되었을 때만 초기화 및 사용 가능한 기능을 활성화합니다.
      // 나머지 코드는 그대로 유지합니다.
    } else {
      // 사용자가 권한을 거부한 경우 처리할 로직을 추가하세요.
    }
    // try {
    //   final String? path = await FlutterUvc.takePicture();
    // } on PlatformException {
    //   platformVersion = 'Failed to get picture path.';
    // }

    // try {
    //   final deviceList = await FlutterUvc.deviceList;
    //   print(deviceList);
    // } on PlatformException {
    //   print("Unable to get device list");
    // }

    // try {
    //   final device = await FlutterUvc.device;
    //   print(device?.productName ?? '');
    // } on PlatformException {
    //   print("Unable to get device.");
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('현미경 촬영'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              const SizedBox(
                width: 640,
                height: 480,
                child: AndroidView(viewType: "flutter_uvc_view"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () async {
                  try {
                    final res = await FlutterUvc.takePicture();
                    setState(() {
                      _imageFile = res;
                    });

                    // 사진을 촬영한 후 analysis_screen으로 돌아가면서 촬영한 사진을 결과로 전달합니다.
                    Navigator.pop(context, _imageFile);
                  } on PlatformException {
                    print("Take picture error");
                  }
                },
                child: const Text("사진 촬영"),
              ),
              const DialogDeviceList(),
              if (_imageFile != null) Image.file(_imageFile!),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogDeviceList extends StatelessWidget {
  const DialogDeviceList({Key? key}) : super(key: key);

  Future<void> handleSelectDevice(context) async {
    try {
      final deviceList = await FlutterUvc.deviceList;
      promptDeviceList(context, deviceList);
    } on PlatformException {
      print("Unable to get devices.");
    }
    return Future.value(null);
  }

  Future<void> promptDeviceList(
    BuildContext context,
    List<UsbDevice> deviceList,
  ) async {
    final selectedDevice = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Select device"),
          children: deviceList
              .map(
                (device) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, device);
                  },
                  child: Column(
                    children: [
                      Text(device.productName ?? ''),
                      Text(device.deviceName),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
    try {
      final res = await FlutterUvc.selectDevice(selectedDevice);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Device selected."),
          ),
        );
      }
    } on PlatformException {
      print("Unable to select devices.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text("Select device"),
      onPressed: () => handleSelectDevice(context),
    );
  }
}
