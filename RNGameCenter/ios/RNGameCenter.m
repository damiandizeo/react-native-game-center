//
//  RNGameCenter.m
//  StockShot
//
//  Created by vyga on 9/18/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RNGameCenter.h"
#import <GameKit/GameKit.h>
#import <React/RCTUtils.h>
#import <React/RCTConvert.h>
#import <React/RCTLog.h>

// Global Defaults
NSString *_leaderboardIdentifier;
NSString *_achievementIdentifier;
UIViewController *_loginVC;

@implementation RNGameCenter

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"onPlayerAuthenticated",
    ];
}

RCT_EXPORT_METHOD(initialize:(NSDictionary *)options) {
    if( options[@"leaderboardIdentifier"] ) {
        _leaderboardIdentifier = options[@"leaderboardIdentifier"];
    }
    if( options[@"achievementIdentifier"] ) {
        _achievementIdentifier = options[@"achievementIdentifier"];
    }
        
    UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *gcViewController, NSError *error) {
        if( gcViewController != nil ) {
            _loginVC = gcViewController;
        } else {
            if( [GKLocalPlayer localPlayer].authenticated ) {
                _loginVC = nil;
            }
        }
        [self sendEventWithName:@"onPlayerAuthenticated" body:@{ @"authenticated": @([GKLocalPlayer localPlayer].authenticated) }];
    };
};

RCT_EXPORT_METHOD(getPlayer:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    if( [GKLocalPlayer localPlayer].authenticated ) {
        @try {
            GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
            NSDictionary* user = @{
                @"alias":localPlayer.alias,
                @"displayName":localPlayer.displayName,
                @"playerID":localPlayer.playerID,
                @"alias":localPlayer.alias
            };
            resolve(user);
        } @catch (NSError * e) {
            reject(@"Error", @"Error getting user.", e);
        }
    }
}

RCT_EXPORT_METHOD(openLeaderboardModal:(NSDictionary *)options) {
    if( [GKLocalPlayer localPlayer].authenticated ) {
        UIViewController *rnView = [UIApplication sharedApplication].keyWindow.rootViewController;
        GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];
        if( leaderboardController != NULL ) {
            leaderboardController.leaderboardIdentifier = _leaderboardIdentifier;
            leaderboardController.viewState = GKGameCenterViewControllerStateLeaderboards;
            leaderboardController.gameCenterDelegate = self;
            [rnView presentViewController: leaderboardController animated: YES completion:nil];
        }
    } else {
        if( _loginVC != nil ) {
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_loginVC animated:YES completion:nil];
        }
    }
}

RCT_EXPORT_METHOD(submitLeaderboardScore:(int64_t)score options:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    if( [GKLocalPlayer localPlayer].authenticated ) {
        @try {
            GKScore *scoreSubmitter = [[GKScore alloc] initWithLeaderboardIdentifier: _leaderboardIdentifier];
            scoreSubmitter.value = score;
            scoreSubmitter.context = 0;
            [GKScore reportScores:@[scoreSubmitter] withCompletionHandler:^(NSError *error) {
                if( error ) {
                    reject(@"Error", @"Error submitting score", error);
                } else {
                    resolve(@"Successfully submitted score");
                }
            }];
        } @catch (NSError * e) {
            reject(@"Error", @"Error submitting score.", e);
        }
    } else {
        reject(@"Error", @"User not authenticated", [[NSError alloc] initWithDomain:@"User not authenticated" code:0 userInfo:nil]);
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)gameCenterViewControllerDidCancel:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

@end

