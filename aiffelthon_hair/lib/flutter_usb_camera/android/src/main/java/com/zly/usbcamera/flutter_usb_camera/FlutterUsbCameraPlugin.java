package com.zly.usbcamera.flutter_usb_camera;

import android.content.Context;
import android.hardware.usb.UsbDevice;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.jiangdg.ausbc.MultiCameraClient;
import com.jiangdg.ausbc.callback.IDeviceConnectCallBack;
import com.serenegiant.usb.USBMonitor;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.StandardMessageCodec;

/** FlutterUsbCameraPlugin */
public class FlutterUsbCameraPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private MultiCameraClient mCameraClient;
  private Context context;
  private FlutterPluginBinding flutterPluginBinding;
  private final Map<Integer, UsbCameraViewFactory> mFactoryMap = new HashMap<>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_usb_camera");
    DebugLog.channel = channel;
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    IDeviceConnectCallBack callback = new IDeviceConnectCallBack() {
      @Override
      public void onAttachDev(@Nullable UsbDevice usbDevice) {
        if (usbDevice == null) {
          return;
        }
        DebugLog.log("장치 발견:" + usbDevice.getDeviceId() + usbDevice.getDeviceName());
        if (!mFactoryMap.containsKey(usbDevice.getDeviceId())) {
          Boolean hasPermission = mCameraClient.requestPermission(usbDevice);
          DebugLog.log("권한 요청:" + hasPermission);
          if (Boolean.TRUE.equals(hasPermission)) {
            UsbCameraViewFactory factory = new UsbCameraViewFactory(StandardMessageCodec.INSTANCE, context, channel, usbDevice);
            mFactoryMap.put(usbDevice.getDeviceId(), factory);
            flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(String.valueOf(usbDevice.getDeviceId()), factory);
            factory.onCameraAttached();
            channel.invokeMethod("onUsbCameraChanged", usbDevice.getDeviceId());
          }
        } else {
          DebugLog.log("장치가 추가됨:" + usbDevice.getDeviceId());
        }
      }

      @Override
      public void onDetachDec(@Nullable UsbDevice usbDevice) {
        if (null != usbDevice) {
          UsbCameraViewFactory factory = mFactoryMap.remove(usbDevice.getDeviceId());
          if (null != factory) {
            factory.onCameraDetached();
            channel.invokeMethod("onUsbCameraChanged", mFactoryMap.size());
          }
        }
      }

      @Override
      public void onConnectDev(@Nullable UsbDevice usbDevice, @Nullable USBMonitor.UsbControlBlock usbControlBlock) {
        if (null == usbDevice || null == usbControlBlock) {
          return;
        }
        UsbCameraViewFactory factory = mFactoryMap.get(usbDevice.getDeviceId());
        if (null != factory) {
          factory.onCameraDisConnected(usbControlBlock);
        }
      }

      @Override
      public void onDisConnectDec(@Nullable UsbDevice usbDevice, @Nullable USBMonitor.UsbControlBlock usbControlBlock) {
        if (null == usbDevice) {
          return;
        }
        UsbCameraViewFactory factory = mFactoryMap.get(usbDevice.getDeviceId());
        if (null != factory) {
          factory.onCameraDisConnected();
        }
      }

      @Override
      public void onCancelDev(@Nullable UsbDevice usbDevice) {
        if (null == usbDevice) {
          return;
        }
        UsbCameraViewFactory factory = mFactoryMap.get(usbDevice.getDeviceId());
        if (null != factory) {
          factory.onCameraDisConnected();
        }
      }
    };
    mCameraClient = new MultiCameraClient(context, callback);
    mCameraClient.register();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("takePicture")) {
      int deviceId = (int) call.arguments;
      UsbCameraViewFactory factory =  mFactoryMap.get(deviceId);
      if (null != factory) {
        factory.takePicture(result);
      } else {
        result.error("100", "사진 촬영 실패", "초기화 실패");
      }
    } else if (call.method.equals("captureVideoStart")) {
      int deviceId = (int) call.arguments;
      UsbCameraViewFactory factory =  mFactoryMap.get(deviceId);
      if (null != factory) {
        factory.captureVideoStart(result);
      } else {
        result.error("100", "비디오 녹화를 시작하지 못했습니다.", "초기화 실패");
      }
    } else if (call.method.equals("captureVideoStop")) {
      int deviceId = (int) call.arguments;
      UsbCameraViewFactory factory =  mFactoryMap.get(deviceId);
      if (null != factory) {
        factory.captureVideoStop(result);
      } else {
        result.error("100", "비디오 녹화 중지 실패", "초기화 실패");
      }
    } else if (call.method.equals("isCameraOpened")) {
      int deviceId = (int) call.arguments;
      UsbCameraViewFactory factory =  mFactoryMap.get(deviceId);
      if (null != factory) {
        factory.isCameraOpened(result);
      } else {
        result.error("100", "카메라가 열려 있는지 확인하는 데 실패했습니다.", "초기화 실패");
      }
    } else if (call.method.equals("isRecordVideo")) {
      int deviceId = (int) call.arguments;
      UsbCameraViewFactory factory =  mFactoryMap.get(deviceId);
      if (null != factory) {
        factory.isRecordVideo(result);
      } else {
        result.error("100", "비디오 녹화 여부 확인 실패", "초기화 실패");
      }
    } else if (call.method.equals("getZoom")) {
      int deviceId = (int) call.arguments;
      UsbCameraViewFactory factory =  mFactoryMap.get(deviceId);
      if (null != factory) {
        factory.getZoom(result);
      } else {
        result.error("100", "확대/축소 비율 가져오기 실패", "초기화 실패");
      }
    } else if (call.method.equals("setZoom")) {
      Map argus = (Map) call.arguments;
      int deviceId = (int) argus.get("deviceId");
      int zoom = (int) argus.get("zoom");
      UsbCameraViewFactory factory =  mFactoryMap.get(deviceId);
      if (null != factory) {
        factory.setZoom(zoom, result);
      } else {
        result.error("100", "확대/축소 비율 설정 실패", "초기화 실패");
      }
    } else if (call.method.equals("startPreview")) {
      int deviceId = (int) call.arguments;
      UsbCameraViewFactory factory =  mFactoryMap.get(deviceId);
      if (null != factory) {
        factory.startPreview();
        result.success(true);
      } else {
        result.success(false);
      }
    } else if (call.method.equals("stopPreview")) {
      int deviceId = (int) call.arguments;
      UsbCameraViewFactory factory =  mFactoryMap.get(deviceId);
      if (null != factory) {
        factory.stopPreview();
        result.success(true);
      } else {
        result.success(false);
      }
    } else if (call.method.equals("clearLog")) {
      DebugLog.clearLog();
      result.success(true);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    mCameraClient.unRegister();
    mCameraClient.destroy();
    mCameraClient = null;
  }
}
