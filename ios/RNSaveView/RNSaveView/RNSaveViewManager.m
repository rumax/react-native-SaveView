#import "RNSaveViewManager.h"

@implementation RNSaveViewManager

RCT_EXPORT_MODULE(RNSaveView)

RCT_EXPORT_METHOD(saveToPNGBase64: (nonnull NSNumber *)reactTag resolver: (RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *snapshot = [self snapshotReactView: reactTag];
      if (snapshot != nil) {
          NSString* base64Image = [self imageToBase64: snapshot];
          if (base64Image != nil) {
              resolve(base64Image);
          } else {
              reject(RNSV_ERROR_INVALID_BASE_64, RNSV_ERROR_MESSAGE_INVALID_BASE_64, nil);
          }
      } else {
          reject(RNSV_ERROR_INVALID_REACT_TAG, [NSString stringWithFormat: @"ReactTag passed: %@", reactTag], nil);
      }
  });
}

RCT_EXPORT_METHOD(saveToPNG: (nonnull NSNumber *)reactTag filePath: (nonnull NSString *)filePath resolver: (RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *snapshot = [self snapshotReactView: reactTag];
        if (snapshot != nil) {
            [self saveImage: snapshot atFilepath: filePath];
            resolve(nil);
        } else {
            reject(RNSV_ERROR_INVALID_REACT_TAG, [NSString stringWithFormat: @"ReactTag passed: %@", reactTag], nil);
        }
    });
}

- (instancetype)init {
    self = [super init];
    return self;
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (UIImage *)snapshotReactView: (nonnull NSNumber *)reactTag {
    UIView *view = (UIView *)[self.bridge.uiManager viewForReactTag: reactTag];

    UIImage *snapshot;
    if ([view isKindOfClass: [RCTScrollView class]]) {
        RCTScrollView* rctScrollView = (RCTScrollView *)view;
        snapshot = [self snapshotScrollView: rctScrollView.scrollView];
    } else {
        snapshot = [self snapshotView: view withSize: view.frame.size];
    }

    return snapshot;
}

- (UIImage *)snapshotScrollView: (UIScrollView *)scrollView {
    // Store the original frame of the scrollview to restore later
    CGRect originalFrame = scrollView.frame;

    // Set the frame to it's contentSize
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

    UIImage *image = [self snapshotView: scrollView withSize: scrollView.contentSize];

    // Return to the original frame of the scrollview
    scrollView.frame = originalFrame;

    return image;
}

- (UIImage *)snapshotView: (UIView *)view withSize: (CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [view drawViewHierarchyInRect: CGRectMake(0, 0, size.width, size.height) afterScreenUpdates: YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void) saveImage: (UIImage *)image atFilepath: (NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [fileManager createFileAtPath: filePath contents: imageData attributes: nil];
}

- (NSString *)imageToBase64: (UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    return [imageData base64EncodedStringWithOptions: 0];
}

@end
