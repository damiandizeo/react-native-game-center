#import <GameKit/GameKit.h>

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <React/RCTEventEmitter.h>


@interface RNGameCenter : RCTEventEmitter <RCTBridgeModule>

@end
