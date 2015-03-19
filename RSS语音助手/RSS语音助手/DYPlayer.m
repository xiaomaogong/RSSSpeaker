//
//  DYPlayer.m
//  订阅号助手
//
//  Created by 龚莎 on 1/20/15.
//  Copyright (c) 2015 GSClock. All rights reserved.
//

#import "DYPlayer.h"
#import "DYSpeeker.h"
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    Initialized,
    Playing,
    Paused,
    Finished
} DYPlayerState;


@implementation DYPlayer
{
    NSArray* currentArticle;
    int currentPlayingIndex;
    DYSpeeker* speeker;
    DYPlayerState state;
}
@synthesize Delegate = notifier;

+(instancetype) initWithPlayerDelegate: (id<DYPlayerDelegate>) dyplayerDelegate{
    DYPlayer* player = [DYPlayer new];
    player.Delegate = dyplayerDelegate;
    return  player;
}

+(DYPlayer *) defaultInstance{
    static DYPlayer* singleton;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate , ^
                  {
                      singleton = [DYPlayer new];
                  });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        speeker = [DYSpeeker new];
        [speeker setDelegate:self];
    }
    return self;
}

-(void) setCurrentData: (NSArray*) data{
    currentArticle = data;
    state = Initialized;
}

-(void) play{
    [self play:currentPlayingIndex];
}

-(void) play:(int) index{
    
    if(currentArticle != nil && index < [currentArticle count])
    {
        if (state == Playing) {
            [speeker stop];
        }
        currentPlayingIndex = index + 1;
        NSString* content = currentArticle[index];
        if(notifier != nil)
            [notifier player:self willPlayNextContent:content];
        [speeker play:content];
        state = Playing;
    }else if (currentArticle != nil && index == [currentArticle count]){
        state = Finished;
        if(notifier != nil)
            [notifier playerDidFinishedPlayContent:self];
    }
}

-(void) stop{
    if(currentArticle != nil){
        [speeker stop];
        state = Paused;
    }
}

-(void) playNext{
    [self play:currentPlayingIndex +1];
}

-(void) playPrevious{
    [self play:currentPlayingIndex -2];
}

#pragma AVSpeechUtterance Delegate methods
-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    [self play];
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    state = Paused;
}
@end
