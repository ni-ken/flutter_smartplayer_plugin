package cn.joyfollow.smartplayernativeview;

import android.content.Context;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.daniulive.smartplayer.SmartPlayerJniV2;
import com.eventhandle.NTSmartEventCallbackV2;
import com.google.gson.Gson;
import com.videoengine.NTRenderer;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

public class SmartPlayerViewController implements PlatformView, MethodChannel.MethodCallHandler,EventChannel.StreamHandler,android.view.SurfaceHolder.Callback {

    private Context context;
    private PluginRegistry.Registrar registrar;
    private View smartView;
    private MethodChannel channel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private SmartPlayerJniV2 libPlayer;
    private long handle_;
    private static final String TAG = "SmartPlayerPlugin";
    private TextView testView;

    SmartPlayerViewController(Context context, PluginRegistry.Registrar registrar, int id) {
        this.context = context;
        this.registrar = registrar;

        channel = new MethodChannel(registrar.messenger(), "smartplayer_plugin_" + id);

        channel.setMethodCallHandler(this);

        eventChannel = new EventChannel(registrar.messenger(), "smartplayer_event_" + id);

        eventChannel.setStreamHandler(this);

        libPlayer = new SmartPlayerJniV2();

        smartView = getSmartPlayerView();
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        int param = 0;//call.argument("intParam");
        int param2 = 0;//call.argument("intParam2");
        String strParam = "";//call.argument("strParam");

        try{
            param = methodCall.argument("intParam");
        }
        catch (Exception e) {
            Log.e(TAG, e.toString());
        }
        try{
            param2 = methodCall.argument("intParam2");
        }
        catch (Exception e) {
            Log.e(TAG, e.toString());
        }
        try{
            strParam = methodCall.argument("strParam");
        }
        catch (Exception e) {
            Log.e(TAG, e.toString());
        }

        int smRet = 0;

        switch(methodCall.method)
        {
            case "dispose":
                libPlayer.SmartPlayerStopPlay(handle_);
                libPlayer.SmartPlayerClose(handle_);
                return;
            case "setVideoDecoderMode":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SetSmartPlayerVideoHWDecoder(handle_,param);
                }
                break;
            case "setAudioOutputType":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetAudioOutputType(handle_,param);
                }
                break;
            case "setBuffer":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetBuffer(handle_,param);
                }
                break;
            case "setMute":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetMute(handle_,param);
                }
                break;
            case "setRTSPTcpMode":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetRTSPTcpMode(handle_,param);
                }
                break;
            case "setFastStartup":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetFastStartup(handle_,param);
                }
                break;
            case "setPlayerLowLatencyMode":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetLowLatencyMode(handle_,param);
                }
                break;
            case "setRotation":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetRotation(handle_,param);
                }
                break;
            case "setReportDownloadSpeed":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetReportDownloadSpeed(handle_,param,param2);
                }
                break;
            case "setSaveImageFlag":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSaveImageFlag(handle_,param);
                }
                break;
            case "saveCurImage":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSaveCurImage(handle_,strParam);
                }
                break;
            case "switchPlaybackUrl":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSwitchPlaybackUrl(handle_,strParam);
                }
                break;
            case "createFileDirectory":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerCreateFileDirectory(strParam);
                }
                break;
            case "setRecorderDirectory":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetRecorderDirectory(handle_,strParam);
                }
                break;
            case "setRecorderFileMaxSize":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetRecorderFileMaxSize(handle_,param);
                }
                break;
            case "setUrl":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerSetUrl(handle_,strParam);
                }
                break;
            case "startPlay":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerStartPlay(handle_);
                }
                break;
            case "stopPlay":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerStopPlay(handle_);
                }
                break;
            case "startRecorder":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerStartRecorder(handle_);
                }
                break;
            case "stopRecorder":
                if(handle_ != 0)
                {
                    smRet = libPlayer.SmartPlayerStopRecorder(handle_);
                }
                break;
            default:
                result.notImplemented();
                return;
        }
        result.success(smRet);
    }

    @Override
    public View getView() {

        return smartView;
    }

    @Override
    public void dispose() {
        Log.i(TAG, "platformview dispose");
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {

    }

    private View getSmartPlayerView(){
        FrameLayout fl;

        handle_ = libPlayer.SmartPlayerOpen(registrar.activeContext());
        libPlayer.SetSmartPlayerEventCallbackV2(handle_,new EventHandleV2());
        final SurfaceView surfaceView = NTRenderer.CreateRenderer(registrar.activeContext(),false);
        Log.i(TAG,"++++++++++++ surfaceView created");
        surfaceView.getHolder().addCallback(this);
        libPlayer.SmartPlayerSetSurface(handle_,surfaceView);
        testView = new TextView(registrar.activeContext());
        testView.setText("hello flutter");
        return surfaceView;
    }

    @Override
    public void surfaceCreated(SurfaceHolder surfaceHolder) {
//        Log.i(TAG, "++++++++++++surfaceCreated");
//        if(smartView != null)
//            libPlayer.SmartPlayerSetSurface(handle_,smartView);
        libPlayer.SmartPlayerUpdateHWRenderSurface(handle_);
    }

    @Override
    public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i1, int i2) {
        Log.i(TAG, "++++++++++++surfaceChanged");
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
        Log.i(TAG, "++++++++++++surfaceDestroyed");
    }

    class EventHandleV2 implements NTSmartEventCallbackV2 {

        @Override
        public void onNTSmartEventCallbackV2(long handle, int id, long param1, long param2, String param3, String param4, Object param5) {
            String flutterMsg = new StringBuilder(String.valueOf(handle)).append(",").append(id).append(",").append(param1).append(",").append(param2).append(",").toString();
            if (param3 != null) {
                flutterMsg = new StringBuilder(String.valueOf(flutterMsg)).append(param3).toString();
            }
            flutterMsg = new StringBuilder(String.valueOf(flutterMsg)).append(",").toString();
            if (param4 != null) {
                flutterMsg = new StringBuilder(String.valueOf(flutterMsg)).append(param4).toString();
            }
            if (handle_ != 0) {
                Map<String,String> event = new HashMap<>();
                event.put("playerObject",String.valueOf(handle_));
                event.put("param", flutterMsg);
                Gson gson = new Gson();
                String json = gson.toJson(event);
                eventSink.success(json);
            }
        }
    }
}
