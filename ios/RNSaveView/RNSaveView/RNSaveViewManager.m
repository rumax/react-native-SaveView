#import "RNSaveViewManager.h"

@implementation RNSaveViewManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(saveToPNGBase64: (nonnull NSNumber *)reactTag resolver: (RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *snapshot = [self snapshotReactView: reactTag];
      if (snapshot != nil) {
          NSString* base64Image = [self imageToBase64: snapshot];
          if (base64Image != nil) {
              resolve(base64Image);
          } else {
              reject(ERROR_INVALID_BASE_64, ERROR_MESSAGE_INVALID_BASE_64, nil);
          }
      } else {
          reject(ERROR_INVALID_REACT_TAG, [NSString stringWithFormat: @"ReactTag passed: %@", reactTag], nil);
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
            reject(ERROR_INVALID_REACT_TAG, [NSString stringWithFormat: @"ReactTag passed: %@", reactTag], nil);
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
    // Store the original background color
    UIColor* originalColor = view.backgroundColor;
    // If the background color is not set it will default to white
    if (originalColor == nil) {
        view.backgroundColor = [UIColor whiteColor];
    }
    
    UIImage *snapshot;
    
    if ([view isKindOfClass: [RCTScrollView class]]) {
        snapshot = [self snapshotScrollView: (RCTScrollView *)view];
    } else {
        snapshot = [self snapshotView: view];
    }
    
    // Restore the original view's background color
    view.backgroundColor = originalColor;
    return snapshot;
}

- (UIImage *)snapshotView: (UIView *)view {
  UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
  [view drawViewHierarchyInRect: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates: YES];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

- (UIImage *)snapshotScrollView: (RCTScrollView *)scrollview {
  // Store the original frame of the scrollview to restore later
  CGRect originalFrame = scrollview.frame;
  // Set the frame of the scrollview equal to it's contentsize
  scrollview.frame = CGRectMake(0, 0, scrollview.contentSize.width, scrollview.contentSize.height);
  
  UIGraphicsBeginImageContext(scrollview.contentSize);
  [scrollview.layer renderInContext: UIGraphicsGetCurrentContext()];
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  // Set scrollview frame to original frame
  scrollview.frame = originalFrame;
  
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
