//
//  LLFileMultiDownload.m
//  iosnewlearn_2018_cmd
//
//  Created by Lance on 2018/9/6.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import "LLFileMultiDownload.h"

#import "LLFileMultiBaseDownload.h"

@interface LLFileMultiDownload ()

@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, assign) long long currentLength;

@end

@implementation LLFileMultiDownload

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentLength = 0;
        self.msize = 3;
    }
    return self;
}

- (void)setMsize:(NSInteger)msize {
    _msize = msize;
    if (msize > 5) {
        _msize = 3;
    }
}

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

- (void)saveFile:(NSData *)data offset:(long long)offset {
    if (data && offset >= 0) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", self.destPath, self.name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [_fileHandle seekToFileOffset:offset];
        [_fileHandle writeData:data];
        [_fileHandle closeFile];
    }
}

- (void)start {
    if (self.url && self.url.length > 0 && [self.url containsString:@"http"]) {
        if (self.destPath && self.destPath.length > 0) {
            if (self.msize <= self.size && self.msize > 0 && self.size > 0) {
                
                [self filePathCheck:self.destPath];
                long psize = self.size / self.msize;
                long begin = 0;
                long end = 0;
                dispatch_queue_t queue = dispatch_queue_create("saveFIle", DISPATCH_QUEUE_SERIAL);
                for (NSInteger i = 0; i < self.msize; i ++) {
                    if (i == self.msize - 1) {
                        begin = i * psize;
                        end = self.size;
                    } else {
                        begin = i * psize;
                        end = begin + psize;
                    }
                    LLFileMultiBaseDownload *baseDownload = [[LLFileMultiBaseDownload alloc] init];
                    baseDownload.begin = begin;
                    baseDownload.end = end;
                    baseDownload.url = self.url;
                    baseDownload.destPath = self.destPath;
                    baseDownload.didDownload = ^(NSData *data, long long b, long long e) {
                        self.currentLength += e - b;
                        if (self.progress) {
                            self.progress(self.currentLength * 1.0 / self.size);
                        }
                        if (self.currentLength == self.size) {
                            [self complteMethod:self.destPath succ:YES];
                        }
                        dispatch_async(queue, ^{
                            [self saveFile:data offset:b];
                        });
                    };
                    [baseDownload start];
                }
            } else {
                [self complteMethod:@"msize size 错误" succ:NO];
            }
        } else {
            [self complteMethod:@"destPath is not valide" succ:NO];
        }
    } else {
        [self complteMethod:@"url is not valide" succ:NO];
    }
}

@end
