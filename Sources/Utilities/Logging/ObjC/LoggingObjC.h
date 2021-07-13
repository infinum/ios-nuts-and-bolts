//
//  LoggingObjC.h
//  Logging
//
//  Created by Ivana Mršić on 24.05.2021..
//

// MARK: - Verbose

// Default condiguration for macros

/// log something generally unimportant (lowest priority)
#define LVerbose(fmt, ...) \
[Logger objc_verbose:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
             options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                           line:__LINE__ \
                                                       category:LogCategoryNone]];

// Categorised verbose
/// log something generally unimportant (lowest priority).
///
/// Can set custom category.
#define LCVerbose(fmt, cat, ...) \
[Logger objc_verbose:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
             options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                           line:__LINE__ \
                                                       category:cat]];

// MARK: - Debug

/// log something which help during debugging (low priority)
#define LDebug(fmt, ...)  \
[Logger objc_debug:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
           options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                         line:__LINE__ \
                                                     category:LogCategoryNone]];

// Categorised debug
/// log something which help during debugging (low priority)
///
/// Can set custom category.
#define LCDebug(fmt, cat, ...)\
[Logger objc_debug:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
           options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                         line:__LINE__ \
                                                     category:cat]];

// MARK: - Info

/// log something which you are really interested but which is not an issue or error (normal priority)
#define LInfo(fmt, ...)  \
[Logger objc_info:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
          options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                        line:__LINE__ \
                                                    category:LogCategoryNone]];

// Categorised info
/// log something which you are really interested but which is not an issue or error (normal priority)
///
/// Can set custom category.
#define LCInfo(fmt, cat, ...) \
[Logger objc_info:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
          options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                        line:__LINE__ \
                                                    category:cat]];

// MARK: - Warning

/// log something which may cause big trouble soon (high priority)
#define LWarning(fmt, ...) \
[Logger objc_warning:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
             options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                           line:__LINE__ \
                                                       category:LogCategoryNone]];

// Categorised warning
/// log something which may cause big trouble soon (high priority)
///
/// Can set custom category.
#define LCWarning(fmt, cat, ...) \
[Logger objc_warning:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
             options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                           line:__LINE__ \
                                                       category:cat]];

// MARK: - Error

/// log something which will keep you awake at night (highest priority)
#define LError(fmt, ...) \
[Logger objc_error:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
           options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                         line:__LINE__ \
                                                     category:LogCategoryNone]];

// Categorised error
/// log something which will keep you awake at night (highest priority)
///
/// Can set custom category.
#define LCError(fmt, cat, ...) \
[Logger objc_error:[NSString stringWithFormat:fmt, ##__VA_ARGS__] \
           options:[LoggingOptions defaultOptionsWithFunction:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
                                                         line:__LINE__ \
                                                     category:cat]];
