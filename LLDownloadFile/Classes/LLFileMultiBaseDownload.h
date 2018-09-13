//
//  LLFileMultiBaseDownload.h
//  iosnewlearn_2018_cmd
//
//  Created by Lance on 2018/9/6.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import "LLFileBaseDownload.h"

@interface LLFileMultiBaseDownload : LLFileBaseDownload

@property (nonatomic, assign) long long begin;
@property (nonatomic, assign) long long end;

@property (nonatomic, copy) void (^didDownload)(NSData *data, long long begin, long long end);

@end
