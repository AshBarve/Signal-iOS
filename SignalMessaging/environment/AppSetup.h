//
//  Copyright (c) 2021 Open Whisper Systems. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@protocol MobileCoinHelper;
@protocol PaymentsEvents;

// This is _NOT_ a singleton and will be instantiated each time that the SAE is used.
@interface AppSetup : NSObject

+ (void)setupEnvironmentWithAppSpecificSingletonBlock:(dispatch_block_t)appSpecificSingletonBlock
                                       paymentsEvents:(id<PaymentsEvents>)paymentsEvents
                                     mobileCoinHelper:(id<MobileCoinHelper>)mobileCoinHelper
                                  migrationCompletion:(void (^)(NSError *_Nullable error))migrationCompletion;

@end

NS_ASSUME_NONNULL_END
