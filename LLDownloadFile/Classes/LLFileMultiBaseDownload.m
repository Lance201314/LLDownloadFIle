//
//  LLFileMultiBaseDownload.m
//  iosnewlearn_2018_cmd
//
//  Created by Lance on 2018/9/6.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import "LLFileMultiBaseDownload.h"

@interface LLFileMultiBaseDownload () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation LLFileMultiBaseDownload

- (void)start {
    if (self.url && self.url.length > 0 && [self.url containsString:@"http"]) {
        if (self.destPath && self.destPath.length > 0) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
            if (request) {
                [request setValue:[NSString stringWithFormat:@"bytes=%lld-%lld", self.begin, self.end] forHTTPHeaderField:@"Range"];
                
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];;
                self.downloadTask = [session downloadTaskWithRequest:request];
                [self.downloadTask resume];
                
                self.downloading = YES;
            } else {
                [self complteMethod:@"init request failed" succ:NO];
            }
        } else {
            [self complteMethod:@"destPath is not valide" succ:NO];
        }
    } else {
        [self complteMethod:@"url is not valide" succ:NO];
    }
}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    if (self.didDownload) {
        self.didDownload([NSData dataWithContentsOfURL:location], self.begin, self.end);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (self.progress) {
        self.progress(totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
    }
}

@end


