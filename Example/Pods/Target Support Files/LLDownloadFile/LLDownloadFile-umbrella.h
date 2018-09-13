#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LLFileBaseDownload.h"
#import "LLFileCommac.h"
#import "LLFileMangerDownload.h"
#import "LLFileMultiBaseDownload.h"
#import "LLFileMultiDownload.h"
#import "LLFileSingleDownload.h"

FOUNDATION_EXPORT double LLDownloadFileVersionNumber;
FOUNDATION_EXPORT const unsigned char LLDownloadFileVersionString[];

