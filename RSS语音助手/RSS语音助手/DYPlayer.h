//
//  DYPlayer.h
//  订阅号助手
//
//  Created by 龚莎 on 1/20/15.
//  Copyright (c) 2015 GSClock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class DYPlayer;

@protocol DYPlayerDelegate <NSObject>

- (void) player:(DYPlayer*)player willPlayNextContent:(NSString*)content;

- (void) playerDidFinishedPlayContent:(DYPlayer *)player;

@end


@interface DYPlayer : NSObject<AVSpeechSynthesizerDelegate>
@property(nonatomic,retain) id<DYPlayerDelegate> Delegate;
+(instancetype) initWithPlayerDelegate: (id<DYPlayerDelegate>) dyplayerDelegate;
+(DYPlayer *) defaultInstance;
-(void) setCurrentData: (NSArray*) data;
-(void) play;
-(void) play:(int) index;
-(void) stop;
-(void) playNext;
-(void) playPrevious;
@end


