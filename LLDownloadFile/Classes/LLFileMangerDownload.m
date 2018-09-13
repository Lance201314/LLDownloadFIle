//
//  LLFileMangerDownload.m
//  iosnewlearn_2018_cmd
//
//  Created by Lance on 2018/9/5.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import "LLFileMangerDownload.h"

#import "LLFileSingleDownload.h"
#import "LLFileMultiDownload.h"

#import "LLFileCommac.h"

@interface LLFileMangerDownload ()


@end

static LLFileMangerDownload *instance;

@implementation LLFileMangerDownload

+ (LLFileMangerDownload *)shareInstance {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[LLFileMangerDownload alloc] init];
        });
    }
    return instance;
}

- (NSString *)downloadPath {
    if (!_downloadPath) {
        _downloadPath = [NSString stringWithFormat:@"%@/download", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, yearMask) lastObject]];
    }
    return _downloadPath;
}

/**
 获取文件大小

 @param path 文件路径
 @param block 获取之后回调
 */
- (void)getFileSize:(NSString *)path block:(void (^)(LLFileHeaderInfo *headerInfo, NSString *error))block {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = @"HEAD";
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode == 200) {
                    LLFileHeaderInfo *headerInfo = [[LLFileHeaderInfo alloc] init];
                    headerInfo.length = response.expectedContentLength;
                    headerInfo.name = response.suggestedFilename;
                    headerInfo.mimeType = response.MIMEType;
                    block(headerInfo, nil);
                } else {
                    block(nil, [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]);
                }
            } else {
                LLFileHeaderInfo *headerInfo = [[LLFileHeaderInfo alloc] init];
                headerInfo.length = response.expectedContentLength;
                headerInfo.name = response.suggestedFilename;
                headerInfo.mimeType = response.MIMEType;
                block(headerInfo, nil);
            }
        } else {
            block(nil, [NSString stringWithFormat:@"获取文件size失败%@", error]);
        }
    }] resume];
}

- (void)startSingleDownload:(NSString *)url complete:(void (^)(BOOL succ, NSString *msg))complete {
    [self startSingleDownload:url complete:complete progress:nil];
}

- (void)startSingleDownload:(NSString *)url complete:(void (^)(BOOL succ, NSString *msg))complete progress:(void (^)(CGFloat value))progress {
    [self getFileSize:url block:^(LLFileHeaderInfo *headerInfo, NSString *error) {
        if (!error) {
            // NSLog(@"文件大小为: %.2fM, 名称： %@， 类型： %@", headerInfo.length * 1.0 / 1024 / 1024, headerInfo.name, headerInfo.mimeType);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", self.downloadPath, headerInfo.name]]) {
                if (complete) {
                    complete(NO, @"文件已存在");
                }
            } else {
                LLFileSingleDownload *singleDownload = [[LLFileSingleDownload alloc] init];
                singleDownload.size = headerInfo.length;
                singleDownload.url = url;
                singleDownload.destPath = self.downloadPath;
                singleDownload.progress = ^(double value) {
                    if (progress) {
                        progress(value);
                    }
                };
                singleDownload.complete = ^(BOOL succ, NSString *msg) {
                    if (complete) {
                        complete(succ, msg);
                    }
                };
                [singleDownload start];
            }
        } else {
            if (complete) {
                complete(NO, error);
            }
        }
    }];
}


- (void)startMulitDownload:(NSString *)url complete:(void (^)(BOOL succ, NSString *msg))complete {
    [self startMulitDownload:url complete:complete progress:nil];
}

- (void)startMulitDownload:(NSString *)url complete:(void (^)(BOOL succ, NSString *msg))complete progress:(void (^)(CGFloat value))progress {
    [self getFileSize:url block:^(LLFileHeaderInfo *headerInfo, NSString *error) {
        if (!error) {
            // NSLog(@"文件大小为: %.2fM, 名称： %@， 类型： %@", headerInfo.length * 1.0 / 1024 / 1024, headerInfo.name, headerInfo.mimeType);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", self.downloadPath, headerInfo.name]]) {
                if (complete) {
                    complete(NO, @"文件已存在");
                }
            } else {
                LLFileMultiDownload *multiDownload = [[LLFileMultiDownload alloc] init];
                multiDownload.size = headerInfo.length;
                multiDownload.url = url;
                multiDownload.destPath = self.downloadPath;
                multiDownload.name = headerInfo.name;
                multiDownload.progress = ^(double value) {
                    if (progress) {
                        progress(value);
                    }
                };
                multiDownload.complete = ^(BOOL succ, NSString *msg) {
                    if (complete) {
                        complete(succ, msg);
                    }
                };
                [multiDownload start];
            }
        } else {
            if (complete) {
                complete(NO, error);
            }
        }
    }];
}

@end

@implementation LLFileHeaderInfo


@end
