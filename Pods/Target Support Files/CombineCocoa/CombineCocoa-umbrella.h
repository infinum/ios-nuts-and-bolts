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

#import "CombineCocoa.h"
#import "ObjcDelegateProxy.h"

FOUNDATION_EXPORT double CombineCocoaVersionNumber;
FOUNDATION_EXPORT const unsigned char CombineCocoaVersionString[];

