/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import <Foundation/Foundation.h>
#import "TTransport.h"

typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface THTTPClient : NSObject <TTransport> {
  NSURL * mURL;
  NSMutableURLRequest * mRequest;
  NSMutableData * mRequestData;
  NSData * mResponseData;
  int mResponseDataOffset;
  NSString * mUserAgent;
  int mTimeout;
}

@property (nonatomic,copy) ProgressBlock uploadBlock;
@property (nonatomic,copy) ProgressBlock downloadBlock;

/**
 The operation queue which manages operations enqueued by the HTTP client.
 */
@property (nonatomic,readonly) NSOperationQueue* operationQueue;

- (id) initWithURL: (NSURL *) aURL;

- (id) initWithURL: (NSURL *) aURL
         userAgent: (NSString *) userAgent
           timeout: (int) timeout;

- (void) setURL: (NSURL *) aURL;

- (void) cancel;

@end

