import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class EVENTID {
  static const EVENT_DANIULIVE_COMMON_SDK = 0x00000000;
  static const EVENT_DANIULIVE_PLAYER_SDK = 0x01000000;
  static const EVENT_DANIULIVE_PUBLISHER_SDK = 0x02000000;

  static const EVENT_DANIULIVE_ERC_PLAYER_STARTED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x1;
  static const EVENT_DANIULIVE_ERC_PLAYER_CONNECTING =
      EVENT_DANIULIVE_PLAYER_SDK | 0x2;
  static const EVENT_DANIULIVE_ERC_PLAYER_CONNECTION_FAILED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x3;
  static const EVENT_DANIULIVE_ERC_PLAYER_CONNECTED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x4;
  static const EVENT_DANIULIVE_ERC_PLAYER_DISCONNECTED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x5;
  static const EVENT_DANIULIVE_ERC_PLAYER_STOP =
      EVENT_DANIULIVE_PLAYER_SDK | 0x6;
  static const EVENT_DANIULIVE_ERC_PLAYER_RESOLUTION_INFO =
      EVENT_DANIULIVE_PLAYER_SDK | 0x7;
  static const EVENT_DANIULIVE_ERC_PLAYER_NO_MEDIADATA_RECEIVED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x8;
  static const EVENT_DANIULIVE_ERC_PLAYER_SWITCH_URL =
      EVENT_DANIULIVE_PLAYER_SDK | 0x9;
  static const EVENT_DANIULIVE_ERC_PLAYER_CAPTURE_IMAGE =
      EVENT_DANIULIVE_PLAYER_SDK | 0xA;

  static const EVENT_DANIULIVE_ERC_PLAYER_RECORDER_START_NEW_FILE =
      EVENT_DANIULIVE_PLAYER_SDK | 0x21; /*录像写入新文件*/
  static const EVENT_DANIULIVE_ERC_PLAYER_ONE_RECORDER_FILE_FINISHED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x22; /*一个录像文件完成*/

  static const EVENT_DANIULIVE_ERC_PLAYER_START_BUFFERING =
      EVENT_DANIULIVE_PLAYER_SDK | 0x81;
  static const EVENT_DANIULIVE_ERC_PLAYER_BUFFERING =
      EVENT_DANIULIVE_PLAYER_SDK | 0x82;
  static const EVENT_DANIULIVE_ERC_PLAYER_STOP_BUFFERING =
      EVENT_DANIULIVE_PLAYER_SDK | 0x83;

  static const EVENT_DANIULIVE_ERC_PLAYER_DOWNLOAD_SPEED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x91;
}

typedef SmartEventCallback = void Function(int, String, String);

class SmartPlayerController {
  MethodChannel _channel;
  EventChannel _eventChannel;
  SmartEventCallback _eventCallback;

  void init(int id) {
    _channel = MethodChannel('smartplayer_plugin_$id');
    _eventChannel = EventChannel('smartplayer_event_$id');
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void setEventCallback(SmartEventCallback callback) {
    _eventCallback = callback;
  }

  void _onEvent(Object event) {
    // print('plugin event:'+event.toString());
    if (event != null) {
      Map valueMap = json.decode(event);
      String param = valueMap['param'];
      onSmartEvent(param);
    }
  }

  void _onError(Object error) {
    // print('android error:'+error);
  }

  Future<dynamic> _smartPlayerCall(String funcName) async {
    var ret = await _channel.invokeMethod(funcName);
    return ret;
  }

  Future<dynamic> _smartPlayerCallInt(String funcName, int param) async {
    var ret = await _channel.invokeMethod(funcName, {
      'intParam': param,
    });
    return ret;
  }

  Future<dynamic> _smartPlayerCallIntInt(
      String funcName, int param1, int param2) async {
    var ret = await _channel.invokeMethod(funcName, {
      'intParam': param1,
      'intParam2': param2,
    });
    return ret;
  }

  Future<dynamic> _smartPlayerCallString(String funcName, String param) async {
    var ret = await _channel.invokeMethod(funcName, {
      'strParam': param,
    });
    return ret;
  }

  /// 设置解码方式 false 软件解码 true 硬件解码 默认为false
  /// </summary>
  /// <param name="isHwDecoder"></param>
  Future<dynamic> setVideoDecoderMode(int isHwDecoder) async {
    return _smartPlayerCallInt('setVideoDecoderMode', isHwDecoder);
  }

  /// <summary>
  /// 设置音频输出模式: if 0: 自动选择; if with 1: audiotrack模式
  /// </summary>
  /// <param name="use_audiotrack"></param>
  Future<dynamic> setAudioOutputType(int useAudiotrack) async {
    return _smartPlayerCallInt('setAudioOutputType', useAudiotrack);
  }

  /// <summary>
  /// 设置播放端缓存大小, 默认200毫秒
  /// </summary>
  /// <param name="buffer"></param>
  Future<dynamic> setBuffer(int buffer) async {
    return _smartPlayerCallInt('setBuffer', buffer);
  }

  /// <summary>
  /// 接口可实时调用：设置是否实时静音，1：静音; 0: 取消静音
  /// </summary>
  /// <param name="is_mute"></param>
  Future<dynamic> setMute(int isMute) async {
    return _smartPlayerCallInt('setMute', isMute);
  }

  /// <summary>
  /// 设置RTSP TCP模式, 1: TCP; 0: UDP
  /// </summary>
  /// <param name="is_using_tcp"></param>
  Future<dynamic> setRTSPTcpMode(int isUsingTcp) async {
    return _smartPlayerCallInt('setRTSPTcpMode', isUsingTcp);
  }

  /// <summary>
  /// 设置快速启动该模式，
  /// </summary>
  /// <param name="is_fast_startup"></param>
  Future<dynamic> setFastStartup(int isFastStartup) async {
    return _smartPlayerCallInt('setFastStartup', isFastStartup);
  }

  /// <summary>
  /// 设置超低延迟模式 false不开启 true开启 默认false
  /// </summary>
  /// <param name="mode"></param>
  Future<dynamic> setPlayerLowLatencyMode(int mode) async {
    return _smartPlayerCallInt('setPlayerLowLatencyMode', mode);
  }

  /// <summary>
  /// 设置顺时针旋转, 注意除了0度之外， 其他角度都会额外消耗性能
  /// degress： 当前支持 0度，90度, 180度, 270度 旋转
  /// </summary>
  /// <param name="degress"></param>
  Future<dynamic> setRotation(int degress) async {
    return _smartPlayerCallInt('setRotation', degress);
  }

  /// <summary>
  /// 设置是否回调下载速度
  /// is_report: if 1: 上报下载速度, 0: 不上报.
  /// report_interval: 上报间隔，以秒为单位，>0.
  /// </summary>
  /// <param name="is_report"></param>
  /// <param name="report_interval"></param>
  Future<dynamic> setReportDownloadSpeed(
      int isReport, int reportInterval) async {
    return _smartPlayerCallIntInt(
        'setReportDownloadSpeed', isReport, reportInterval);
  }

  /// <summary>
  /// 设置是否需要在播放或录像过程中快照
  /// </summary>
  /// <param name="is_save_image"></param>
  Future<dynamic> setSaveImageFlag(int isSaveImage) async {
    return _smartPlayerCallInt('setSaveImageFlag', isSaveImage);
  }

  /// <summary>
  /// 播放或录像过程中快照
  /// </summary>
  /// <param name="imageName"></param>
  Future<dynamic> saveCurImage(String imageName) async {
    return _smartPlayerCallString('saveCurImage', imageName);
  }

  /// <summary>
  /// 播放或录像过程中，快速切换url
  /// </summary>
  /// <param name="uri"></param>
  Future<dynamic> switchPlaybackUrl(String uri) async {
    return _smartPlayerCallString('switchPlaybackUrl', uri);
  }

  /// <summary>
  /// 创建录像存储路径
  /// </summary>
  /// <param name="path"></param>
  Future<dynamic> createFileDirectory(String path) async {
    return _smartPlayerCallString('createFileDirectory', path);
  }

  /// <summary>
  /// 设置录像存储路径
  /// </summary>
  /// <param name="path"></param>
  Future<dynamic> setRecorderDirectory(String path) async {
    return _smartPlayerCallString('setRecorderDirectory', path);
  }

  /// <summary>
  /// 设置单个录像文件大小
  /// </summary>
  /// <param name="size"></param>
  Future<dynamic> setRecorderFileMaxSize(int size) async {
    return _smartPlayerCallInt('setRecorderFileMaxSize', size);
  }

  /// <summary>
  /// 设置播放路径
  /// </summary>
  Future<dynamic> setUrl(String url) async {
    return _smartPlayerCallString('setUrl', url);
  }

  /// <summary>
  /// 开始播放
  /// </summary>
  Future<dynamic> startPlay() async {
    return _smartPlayerCall('startPlay');
  }

  /// <summary>
  /// 停止播放
  /// </summary>
  Future<dynamic> stopPlay() async {
    return _smartPlayerCall('stopPlay');
  }

  /// <summary>
  /// 开始录像
  /// </summary>
  Future<dynamic> startRecorder() async {
    return _smartPlayerCall('startRecorder');
  }

  /// <summary>
  /// 停止录像
  /// </summary>
  Future<dynamic> stopRecorder() async {
    return _smartPlayerCall('stopRecorder');
  }

  /// <summary>
  /// 关闭播放
  /// </summary>
  Future<dynamic> dispose() async {
    return await _channel.invokeMethod('dispose');
  }

  void onSmartEvent(String param) {
    if (!param.contains(",")) {
      print("[onNTSmartEvent] android传递参数错误");
      return;
    }

    List<String> strs = param.split(',');

    // String player_handle = strs[0];
    String code = strs[1];
    String param1 = strs[2];
    String param2 = strs[3];
    String param3 = strs[4];
    String param4 = strs[5];

    int evCode = int.parse(code);
    // print("[onNTSmartEvent] code: 0x" + evCode.toRadixString(16));
    var p1, p2;
    switch (evCode) {
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_STARTED:
        // print("开始。。");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_CONNECTING:
        // print("连接中。。");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_CONNECTION_FAILED:
        // print("连接失败。。");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_CONNECTED:
        // print("连接成功。。");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_DISCONNECTED:
        // print("连接断开。。");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_STOP:
        // print("停止播放。。");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_RESOLUTION_INFO:
        // print("分辨率信息: width: " + param1 + ", height: " + param2);
        p1 = param1;
        p2 = param2;
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_NO_MEDIADATA_RECEIVED:
        // print("收不到媒体数据，可能是url错误。。");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_SWITCH_URL:
        // print("切换播放URL。。");
        break;

      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_CAPTURE_IMAGE:
        // print("快照: " + param1 + " 路径：" + param3);

        if (int.parse(param1) == 0) {
          // print("截取快照成功。.");
        } else {
          // print("截取快照失败。.");
        }
        p1 = param1;
        p2 = param3;
        break;

      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_RECORDER_START_NEW_FILE:
        // print("[record]开始一个新的录像文件 : " + param3);
        p1 = param3;
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_ONE_RECORDER_FILE_FINISHED:
        // print("[record]已生成一个录像文件 : " + param3);
        p1 = param3;
        break;

      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_START_BUFFERING:
        // print("Start_Buffering");
        break;

      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_BUFFERING:
        // print("Buffering: " + param1);
        p1 = param1;
        break;

      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_STOP_BUFFERING:
        // print("Stop_Buffering");
        break;

      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_DOWNLOAD_SPEED:
        // print("download_speed:" +
        //     param1 +
        //     "Byte/s" +
        //     ", " +
        //     (double.parse(param1) * 8 / 1000).toString() +
        //     "kbps" +
        //     ", " +
        //     (double.parse(param1) / 1024).toString() +
        //     "KB/s");
        p1 = param1;
        break;
    }
    if (_eventCallback != null) {
      _eventCallback(evCode, p1, p2);
    }
  }
}
