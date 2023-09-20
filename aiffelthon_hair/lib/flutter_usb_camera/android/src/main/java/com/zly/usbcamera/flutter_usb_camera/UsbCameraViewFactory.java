package com.zly.usbcamera.flutter_usb_camera;

import android.content.Context;
import android.content.Intent;
import android.graphics.ImageFormat;
import android.graphics.Rect;
import android.graphics.YuvImage;
import android.hardware.usb.UsbDevice;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.Settings;
import android.provider.SyncStateContract;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.jiangdg.ausbc.MultiCameraClient;
import com.jiangdg.ausbc.callback.ICaptureCallBack;
import com.jiangdg.ausbc.callback.IPreviewDataCallBack;
import com.jiangdg.natives.YUVUtils;
import com.serenegiant.usb.USBMonitor;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;

import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;


public class UsbCameraViewFactory extends PlatformViewFactory {

    private MultiCameraClient.Camera camera;
    public int mViewId;
    private MethodChannel channel;
    private UsbDevice usbDevice;
    public UsbCameraView mUvcCameraView;
    private Context context;
    private byte[] previewData;

    /**
     * @param createArgsCodec the codec used to decode the args parameter of {@link #create}.
     */
    public UsbCameraViewFactory(@Nullable MessageCodec<Object> createArgsCodec, Context context, MethodChannel channel, @Nullable UsbDevice usbDevice) {
        super(createArgsCodec);
        this.channel = channel;
        this.context = context;
        if (null != usbDevice) {
            camera = new MultiCameraClient.Camera(context, usbDevice);
            this.usbDevice = usbDevice;
            IPreviewDataCallBack callBack = new IPreviewDataCallBack() {
                @Override
                public void onPreviewData(@Nullable byte[] bytes, @NonNull DataFormat dataFormat) {
                    previewData = bytes;
                }
            };
            camera.addPreviewDataCallBack(callBack);
        }
    }

    @NonNull
    @Override
    public PlatformView create(@Nullable Context context, int viewId, @Nullable Object args) {
        mViewId = viewId;
        mUvcCameraView = new UsbCameraView(context, channel);
        return mUvcCameraView;
    }

    public void onCameraAttached() {

    }

    public void onCameraDetached() {
        if (null != camera) {
            camera.setUsbControlBlock(null);
        }
    }

    public void onCameraDisConnected(USBMonitor.UsbControlBlock usbControlBlock) {
        camera.setUsbControlBlock(usbControlBlock);
        this.onCameraDisConnected();
    }

    public void onCameraDisConnected() {

    }

    public String getMediaPath(boolean isVideo) {
        String mFile = null;
        if (context == null) {
            return "";
        }
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss-SSS");
        String now = df.format(System.currentTimeMillis());
    
        // 갤러리의 외부 저장소 디렉토리를 가져옵니다.
        File galleryDir;
        if (isVideo) {
            galleryDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES);
        } else {
            galleryDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        }
    
        if (galleryDir == null) {
            return ""; // 외부 저장소가 사용 불가능한 경우
        }
    
        String path = new File(galleryDir, "UsbCamera").getAbsolutePath();
        mFile = new File(path, now + (isVideo ? ".mp4" : ".jpg")).getAbsolutePath();
    
        File filePath = new File(path);
        if (!filePath.exists()) {
            filePath.mkdirs();
        }
        return mFile;
    }
    
    // public String getMediaPath(boolean isVideo) {
    //     String mFile = null;
    //     if (context == null) {
    //         return "";
    //     }
    //     SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss-SSS");
    //     String now = df.format(System.currentTimeMillis());
        
    //     // 앱 전용의 외부 저장소 디렉토리를 가져옵니다.
    //     File appExternalDir = context.getExternalFilesDir(Environment.DIRECTORY_PICTURES);
    //     if (appExternalDir == null) {
    //         return ""; // 외부 저장소가 사용 불가능한 경우
    //     }
        
    //     String path = new File(appExternalDir, "UsbCamera").getAbsolutePath();
    //     mFile = new File(path, now + (isVideo ? "" : ".jpg")).getAbsolutePath();
        
    //     File filePath = new File(path);
    //     if (!filePath.exists()) {
    //         filePath.mkdirs();
    //     }
    //     return mFile;
    // }
   

    // public String getMediaPath(boolean isVideo) {
    //     String mFile = null;
    //     if (context == null) {
    //         return "";
    //     }
    //     SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss-SSS");
    //     String now = df.format(System.currentTimeMillis());
    //     String path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES) + "/UsbCamera";
    //     mFile = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES) + "/UsbCamera/" + now + (isVideo ? "" : ".jpg");
    //     File filePath = new File(path);
    //     if (!filePath.exists()) {
    //         filePath.mkdirs();
    //     }
    //     return mFile;
    // }


    private static final int REQUEST_STORAGE_PERMISSION = 1001;

    public void takePicture(@NonNull MethodChannel.Result result) {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            // ActivityCompat.requestPermissions((Activity) context, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, REQUEST_STORAGE_PERMISSION);
            // Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            // Uri uri = Uri.fromParts("package", context.getPackageName(), null);
            // intent.setData(uri);
            // context.startActivity(intent);
            result.error("100", "사진 촬영 실패", "권한 허가가 제대로 안됨");
            DebugLog.log("사진 촬영 실패" + ": 안드로이드 권한 허가 안됨");
            
            return;
        }
        if (null != camera) {
            DebugLog.log("시작 사진 촬영");
            camera.captureImage(new ICaptureCallBack() {
                @Override
                public void onError(@Nullable String s) {
                    Log.i("info", "사진 촬영 실패" + s);
                    DebugLog.log("사진 촬영 실패" + s);
                    result.error("100", "사진 촬영 실패", s);
                }

                @Override
                public void onComplete(@Nullable String s) {
                    Log.i("info", "사진 촬영 완료" + s);
                    DebugLog.log("사진 촬영 완료: " + s);
                    result.success(s);
                }

                @Override
                public void onBegin() {

                }
            }, getMediaPath(false));
        } 
        else {
            DebugLog.log("시작 사진 촬영, 카메라가 비어 있습니다.");
            result.error("100", "사진 촬영 실패", "카메라가 비어 있습니다.");
        }
    }

    public void captureVideoStart(@NonNull MethodChannel.Result result) {
        if (null != camera) {
            DebugLog.log("비디오 녹화 시작");
            camera.captureVideoStart(new ICaptureCallBack() {
                @Override
                public void onError(@Nullable String s) {
                    Log.i("info", "비디오 녹화 시작 실패" + s);
                    DebugLog.log("비디오 녹화 시작 실패" + s);
                    result.error("100", "비디오 녹화 시작 실패", s);
                }

                @Override
                public void onComplete(@Nullable String s) {
                    Log.i("info", "비디오 녹화 성공" + s);
                    DebugLog.log("비디오 녹화 성공: " + s);
                    result.success(s);
                }

                @Override
                public void onBegin() {

                }
            }, getMediaPath(true), 0L);
        } else {
            DebugLog.log("비디오 녹화 시작 실패, 카메라가 비어 있습니다.");
            result.error("100", "비디오 녹화 시작 실패", "카메라가 비어 있습니다.");
        }
    }

    public void captureVideoStop(@NonNull MethodChannel.Result result) {
        if (null != camera) {
            DebugLog.log("비디오 녹화 종료 성공");
            camera.captureVideoStop();
            result.success(true);
        } else {
            DebugLog.log("비디오 녹화 종료 실패, 카메라가 비어 있습니다.");
            result.error("100", "비디오 녹화 종료 실패", "카메라가 비어 있습니다.");
        }
    }

    public void isCameraOpened(@NonNull MethodChannel.Result result) {
        if (null != camera) {
            DebugLog.log("카메라가 열려 있는지 확인 성공");
            result.success(camera.isCameraOpened());
        } else {
            DebugLog.log("카메라가 열려 있는지 확인 실패, 카메라가 비어 있습니다.");
            result.error("100", "카메라가 열려 있는지 확인 실패", "카메라가 비어 있습니다.");
        }
    }

    public void isRecordVideo(@NonNull MethodChannel.Result result) {
        if (null != camera) {
            DebugLog.log("비디오 녹화 여부 확인 성공");
            result.success(camera.isRecordVideo());
        } else {
            DebugLog.log("비디오 녹화 여부 확인 실패, 카메라가 비어 있습니다.");
            result.error("100", "비디오 녹화 여부 확인 실패", "카메라가 비어 있습니다.");
        }
    }

    public void setZoom(int zoom, @NonNull MethodChannel.Result result) {
        if (null != camera) {
            DebugLog.log("줌 설정 성공");
            camera.setZoom(zoom);
            result.success(true);
        } else {
            DebugLog.log("줌 설정 실패, 카메라가 비어 있습니다.");
            result.error("100", "줌 설정 실패", "카메라가 비어 있습니다.");
        }
    }

    public void getZoom(@NonNull MethodChannel.Result result) {
        if (null != camera) {
            DebugLog.log("줌 비율 가져오기 성공");
            result.success(camera.getZoom());
        } else {
            DebugLog.log("줌 비율 가져오기 실패, 카메라가 비어 있습니다.");
            result.error("100", "줌 비율 가져오기 실패", "카메라가 비어 있습니다.");
        }
    }

    public void startPreview() {
        if (null != camera) {
            camera.openCamera(mUvcCameraView.mUVCCameraView, null);
            DebugLog.log("미리 보기 시작");
        } else {
            DebugLog.log("미리 보기 시작, 카메라가 비어 있습니다.");
        }
    }

    public void stopPreview() {
        if (null != camera) {
            camera.closeCamera();
            DebugLog.log("미리 보기 종료");
        } else {
            DebugLog.log("미리 보기 종료, 카메라가 비어 있습니다.");
        }
    }
}
