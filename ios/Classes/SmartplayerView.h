//
//  SmartplayerView.h
//  smartplayer_plugin
//
//  Created by mac on 2019/2/25.
//

#ifndef SmartplayerView_h
#define SmartplayerView_h
#import <Flutter/Flutter.h>
#import "daniuliveSDK/include/SmartPlayerSDK.h"


@interface SmartplayerViewController : NSObject <FlutterPlatformView,SmartPlayerDelegate,FlutterStreamHandler>

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;

@end

@interface SmartplayerViewFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

#endif /* SmartplayerView_h */
