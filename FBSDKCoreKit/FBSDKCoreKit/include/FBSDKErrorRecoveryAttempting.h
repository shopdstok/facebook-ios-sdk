/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A formal protocol very similar to the informal protocol NSErrorRecoveryAttempting
 Internal use only

 @warning UNSAFE - DO NOT USE
 */
NS_SWIFT_NAME(ErrorRecoveryAttempting)
@protocol FBSDKErrorRecoveryAttempting <NSObject>

/**
 Attempt the recovery
 @param error the error
 @param completionHandler the handler called upon completion of error recovery

 Attempt recovery from the error, and call the completion handler. The value passed for didRecover must be YES if error recovery was completely successful, NO otherwise.
 */
- (void)attemptRecoveryFromError:(NSError *)error
               completionHandler:(void (^)(BOOL didRecover))completionHandler;
@end

NS_ASSUME_NONNULL_END
