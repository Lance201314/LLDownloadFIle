//
//  LLFileBaseDownload.m
//  iosnewlearn_2018_cmd
//
//  Created by Lance on 2018/9/5.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import "LLFileBaseDownload.h"

@implementation LLFileBaseDownload

- (void)start {
}

- (void)suspend {
    
}

- (void)resume {
    
}

- (void)complteMethod:(NSString *)error succ:(BOOL)succ {
    if (self.complete) {
        self.complete(succ, error);
    }
}

@end
