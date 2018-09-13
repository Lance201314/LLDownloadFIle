//
//  LLFileBaseDownload.h
//  iosnewlearn_2018_cmd
//
//  Created by Lance on 2018/9/5.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLFileCommac.h"

@interface LLFileBaseDownload : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *destPath;

@property (nonatomic, getter=isDownloading, assign) BOOL downloading;

@property (nonatomic, copy) void (^progress)(double progress);
@property (nonatomic, copy) void (^complete)(BOOL succ, NSString *msg);

- (void)start;

- (void)suspend;

- (void)resume;

- (void)complteMethod:(NSString *)error succ:(BOOL)succ;

@end
