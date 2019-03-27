//
//  SmartplayerView.m
//  smartplayer_plugin
//
//  Created by mac on 2019/2/25.
//

#import "SmartplayerView.h"

@implementation SmartplayerViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    SmartplayerViewController* viewController =
    [[SmartplayerViewController alloc] initWithWithFrame:frame
                                     viewIdentifier:viewId
                                    binaryMessenger:_messenger];
    return viewController;
}


@end

@implementation SmartplayerViewController {
    UIView* _glView;
    int64_t _viewId;
    SmartPlayerSDK *_smartPlayerSdk;
    FlutterMethodChannel* _channel;
    FlutterEventChannel * _eventChannel;
    FlutterEventSink _eventSink;
}

- (nonnull UIView *)view {
    return _glView;
}

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        _smartPlayerSdk = [[SmartPlayerSDK alloc] init];
        _smartPlayerSdk.delegate = self;
        [_smartPlayerSdk SmartPlayerInitPlayer];
        [_smartPlayerSdk SmartPlayerSetLowLatencyMode:1];
//        [_smartPlayerSdk SmartPlayerSetBuffer:0];
        [_smartPlayerSdk SmartPlayerSetFastStartup:1];
        [_smartPlayerSdk SmartPlayerSetVideoDecoderMode:1];
        _glView = (__bridge UIView *)([SmartPlayerSDK SmartPlayerCreatePlayView:frame.origin.x y:frame.origin.y width:frame.size.width height:frame.size.height]);
        [_smartPlayerSdk SmartPlayerSetPlayView:(__bridge void *)(_glView)];
        _viewId = viewId;
        
        NSString* channelName = [NSString stringWithFormat:@"smartplayer_plugin_%lld", viewId];
//        NSString* channelName = @"smartplayer_plugin";
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        NSString* eventChannelName = [NSString stringWithFormat:@"smartplayer_event_%lld", viewId];
        _eventChannel = [FlutterEventChannel eventChannelWithName:eventChannelName  binaryMessenger:messenger];
        [_eventChannel setStreamHandler:self];
    }
    return self;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* method = call.method;
//    NSUInteger handle = [call.arguments[@"playerObject"] unsignedIntegerValue];
    NSInteger intParam = [call.arguments[@"intParam"] intValue];
    NSInteger intParam2 = [call.arguments[@"intParam2"] intValue];
    NSString* strParam = call.arguments[@"strParam"];

    typedef void (^CaseBlock)(void);
    
    NSDictionary *methodFunc = @{
                                 @"dispose":
                                     ^{
                                         result([NSNumber numberWithInteger:[self onDispose]]);
                                     },
                                 @"setVideoDecoderMode":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetVideoDecoderMode:intParam]]);
                                     },
                                 @"setBuffer":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetBuffer:intParam]]);
                                     },
                                 @"setMute":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetMute:intParam]]);
                                     },
                                 @"setRTSPTcpMode":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetRTSPTcpMode:intParam]]);
                                     },
                                 @"setFastStartup":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetFastStartup:intParam]]);
                                     },
                                 @"setPlayerLowLatencyMode":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetLowLatencyMode:intParam]]);
                                     },
                                 @"setReportDownloadSpeed":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetReportDownloadSpeed:intParam report_interval:intParam2]]);
                                     },
                                 @"setSaveImageFlag":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSaveImageFlag:intParam]]);
                                     },
                                 @"saveCurImage":
                                     ^{
                                          result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSaveCurImage:strParam]]);
                                     },
                                 @"setRecorderDirectory":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetRecorderDirectory:strParam]]);
                                     },
                                 @"setRecorderFileMaxSize":
                                     ^{
                                          result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetRecorderFileMaxSize:intParam]]);
                                     },
                                 @"setUrl":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerSetPlayURL:strParam]]);
                                     },
                                 @"startPlay":
                                     ^{
                                        result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerStart]]);
                                     },
                                 @"stopPlay":
                                     ^{
                                          result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerStop]]);
                                     },
                                 @"startRecorder":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerStartRecorder]]);
                                     },
                                 @"stopRecorder":
                                     ^{
                                         result([NSNumber numberWithInteger:[self->_smartPlayerSdk SmartPlayerStopRecorder]]);
                                     }
                                 };
    CaseBlock cb = methodFunc[method];
    if(cb) cb();else { result(FlutterMethodNotImplemented); }
}

-(NSInteger)onDispose{
    [_smartPlayerSdk SmartPlayerStop];
    if(_glView != nil){
        [SmartPlayerSDK SmartPlayeReleasePlayView:(__bridge void *)(_glView)];
    }
    [_smartPlayerSdk SmartPlayerUnInitPlayer];
    return 0;
}

- (NSInteger)handleSmartPlayerEvent:(NSInteger)nID param1:(unsigned long long)param1 param2:(unsigned long long)param2 param3:(NSString *)param3 param4:(NSString *)param4 pObj:(void *)pObj {
    if (nID == EVENT_DANIULIVE_ERC_PLAYER_STARTED) {
        NSLog(@"[event]开始播放..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_CONNECTING)
    {
        NSLog(@"[event]连接中..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_CONNECTION_FAILED)
    {
        NSLog(@"[event]连接失败..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_CONNECTED)
    {
        NSLog(@"[event]已连接..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_DISCONNECTED)
    {
        NSLog(@"[event]断开连接..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_STOP)
    {
        NSLog(@"[event]停止播放..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_RESOLUTION_INFO)
    {
        NSLog(@"[event]视频解码分辨率信息..width:%llu, height:%llu", param1, param2);
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_NO_MEDIADATA_RECEIVED)
    {
        NSLog(@"[event]收不到RTMP数据..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_SWITCH_URL)
    {
        NSLog(@"[event]快速切换url..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_CAPTURE_IMAGE)
    {
        if ((int)param1 == 0)
        {
            NSLog(@"[event]快照成功: %@", param3);
        }
        else
        {
            NSLog(@"[event]快照失败: %@", param3);
        }
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_START_BUFFERING)
    {
        //NSLog(@"[event]开始buffer..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_BUFFERING)
    {
        //NSLog(@"[event]buffer百分比: %lld", param1);
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_STOP_BUFFERING)
    {
        //NSLog(@"[event]停止buffer..");
    }
    else if (nID == EVENT_DANIULIVE_ERC_PLAYER_DOWNLOAD_SPEED)
    {
        NSInteger speed_kbps = (NSInteger)param1*8/1000;
        NSInteger speed_KBs = (NSInteger)param1/1024;
        
        NSLog(@"[event]download speed :%ld kbps - %ld KB/s", (long)speed_kbps, (long)speed_KBs);
    }
    else
        NSLog(@"[event]nID:%lx", (long)nID);
    
    NSUInteger handle = (NSUInteger)self;
    NSString* flutter_msg = [NSString stringWithFormat:@"%lu,%ld,%llu,%llu,", handle, (long)nID,param1,param2 ];
    if(param3 != nil) {
        flutter_msg = [flutter_msg stringByAppendingString:param3];
    }
    flutter_msg = [flutter_msg stringByAppendingString:@","];
    if(param4 != nil) {
        flutter_msg = [flutter_msg stringByAppendingString:param4];
    }

    NSMutableDictionary *ret = [@{
                                  @"playerObject":[NSString stringWithFormat:@"%lu",(unsigned long)_smartPlayerSdk],
                                  @"param":flutter_msg
                                  } mutableCopy];
    //转成JSON
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ret options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    if(jsonString != nil)
    {
        _eventSink(jsonString);
    }
    else{
        NSLog(@"event is nil");
    }
    return 0;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    _eventSink = events;
    return nil;
}

@end

