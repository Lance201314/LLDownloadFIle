//
//  LLFileMultiDownload.h
//  iosnewlearn_2018_cmd
//
//  Created by Lance on 2018/9/6.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import "LLFileBaseDownload.h"

@interface LLFileMultiDownload : LLFileBaseDownload

@property (nonatomic, assign) long long size;

/**
 线程数量 默认3个
 */
@property (nonatomic, assign) NSInteger msize;

@property (nonatomic, strong) NSString *name;

@end
