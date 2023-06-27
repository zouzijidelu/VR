// Autogenerated from Pigeon (v1.0.19), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@class F2NMessage;
@class N2FMessage;

@interface F2NMessage : NSObject
+ (instancetype)makeWithMsg:(nullable NSString *)msg
    index:(nullable NSNumber *)index
    tempPath:(nullable NSString *)tempPath
    tempThumbnail:(nullable NSString *)tempThumbnail
    relativeCoverPath:(nullable NSString *)relativeCoverPath
    title:(nullable NSString *)title;
@property(nonatomic, copy, nullable) NSString * msg;
@property(nonatomic, strong, nullable) NSNumber * index;
@property(nonatomic, copy, nullable) NSString * tempPath;
@property(nonatomic, copy, nullable) NSString * tempThumbnail;
@property(nonatomic, copy, nullable) NSString * relativeCoverPath;
@property(nonatomic, copy, nullable) NSString * title;
@end

@interface N2FMessage : NSObject
+ (instancetype)makeWithMsg2:(nullable NSString *)msg2;
@property(nonatomic, copy, nullable) NSString * msg2;
@end

/// The codec used by FlutterMessage.
NSObject<FlutterMessageCodec> *FlutterMessageGetCodec(void);

@protocol FlutterMessage
/// @return `nil` only when `error != nil`.
- (void)flutterSendMessageMsg:(F2NMessage *)msg error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FlutterMessageSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FlutterMessage> *_Nullable api);

/// The codec used by NativeMessage.
NSObject<FlutterMessageCodec> *NativeMessageGetCodec(void);

@interface NativeMessage : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)nativeSendMessageMsg:(N2FMessage *)msg completion:(void(^)(NSError *_Nullable))completion;
@end
NS_ASSUME_NONNULL_END
