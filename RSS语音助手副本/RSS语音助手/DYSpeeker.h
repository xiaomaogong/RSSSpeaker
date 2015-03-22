//
//  DYSpeeker.h
//  订阅号助手
//
//  Created by 龚莎 on 15/2/4.
//  Copyright (c) 2015年 GSClock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYSpeeker : NSObject
-(void)play:(NSString*)content;
-(void)stop;
-(void)pause;
-(void)resume;
-(void)setDelegate:(id) delegate;
@end
