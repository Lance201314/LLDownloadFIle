//
//  LLFileSingleDownload.m
//  iosnewlearn_2018_cmd
//
//  Created by Lance on 2018/9/5.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import "LLFileSingleDownload.h"

@interface LLFileSingleDownload () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation LLFileSingleDownload


- (void)filePathCheck:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        NSError *error = NULL;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            [self complteMethod:error.localizedDescription succ:NO];
            
            return;
        }
    }
}

- (void)start {
    if (self.url && self.url.length > 0 && [self.url containsString:@"http"]) {
        if (self.destPath && self.destPath.length > 0) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
            if (request) {
                NSString *value = [NSString stringWithFormat:@"bytes=0-%lld", self.size];
                [request setValue:value forHTTPHeaderField:@"Range"];
                
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
                self.downloadTask = [session downloadTaskWithRequest:request];
                [self.downloadTask resume];
                
                self.downloading = YES;
            } else {
                [self complteMethod:@"init request faild" succ:NO];
            }
        } else {
            [self complteMethod:@"destPath is not valide" succ:NO];
        }
    } else {
        [self complteMethod:@"url is not valide" succ:NO];
    }
}

- (void)suspend {
    if (self.downloadTask) {
        [self.downloadTask suspend];
    }
    self.downloading = NO;
}

- (void)resume {
    if (self.downloadTask) {
        [self.downloadTask resume];
        
        self.downloading = YES;
    }
}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (self.progress) {
        self.progress(totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    
    // 判断保存的目录是否存在，如果不存在，则新建
    [self filePathCheck:self.destPath];
    
    NSString *fielPath = [NSString stringWithFormat:@"%@/%@", self.destPath, downloadTask.response.suggestedFilename];
    
    NSError *error = NULL;
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:fielPath error:&error];
    if (error) {
        [self complteMethod:error.localizedDescription succ:NO];
    } else {
        [self complteMethod:fielPath succ:YES];
    }
}

@end
