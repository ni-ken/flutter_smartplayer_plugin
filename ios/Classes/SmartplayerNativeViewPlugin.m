#import "SmartplayerNativeViewPlugin.h"
#import "SmartplayerView.h"

@implementation SmartplayerNativeViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    SmartplayerViewFactory* viewFactory = [[SmartplayerViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:viewFactory withId:@"smartPlayerView"];
}

@end
