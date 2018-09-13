//
//  LLFileMangerDownload.h
//  iosnewlearn_2018_cmd
//
//  Created by Lance on 2018/9/5.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LLFileHeaderInfo;

@interface LLFileMangerDownload : NSObject

/**
 单例操作
 */
+ (LLFileMangerDownload *)shareInstance;


/**
 默认是cache目录下面的/download
 */
@property (nonatomic, strong) NSString *downloadPath;

/**
 获取文件大小
 
 @param path 文件路径
 @param block 获取之后回调
 */
- (void)getFileSize:(NSString *)path block:(void (^)(LLFileHeaderInfo *headerInfo, NSString *error))block;

- (void)startSingleDownload:(NSString *)url complete:(void (^)(BOOL succ, NSString *msg))complete;

- (void)startSingleDownload:(NSString *)url complete:(void (^)(BOOL succ, NSString *msg))complete progress:(void (^)(CGFloat value))progress;

- (void)startMulitDownload:(NSString *)url complete:(void (^)(BOOL succ, NSString *msg))complete;

- (void)startMulitDownload:(NSString *)url complete:(void (^)(BOOL succ, NSString *msg))complete progress:(void (^)(CGFloat value))progress;


@end

@interface LLFileHeaderInfo: NSObject

@property (nonatomic, assign) long long length;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mimeType;

@end
