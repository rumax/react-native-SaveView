#import "RNSaveViewManager.h"

@implementation RNSaveViewManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(saveToPNGBase64: (nonnull NSNumber *)reactTag filePath: (nonnull NSString *)filePath resolver: (RCTPromiseResolveBlock)resolve rejecter: (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIView *view = (UIView *)[self.bridge.uiManager viewForReactTag: reactTag];
    UIImage *snapshot;
    
    if ([view isKindOfClass: [RCTScrollView class]]) {
      snapshot = [self takeSnapshotOfScrollView: (RCTScrollView *)view];
    } else {
      snapshot = [self takeSnapshotOfView: view];
    }
    if (snapshot != nil) {
      NSFileManager *fileManager = [NSFileManager defaultManager];
      NSData *myImageData = UIImageJPEGRepresentation(snapshot, 1.0);
      [fileManager createFileAtPath: filePath contents: myImageData attributes: nil];
      resolve(nil);
    } else {
      reject(ERROR_INVALID_REACT_TAG, [NSString stringWithFormat: @"ReactTag passed: %@", reactTag], nil);
    }
  });
}

- (UIImage *)takeSnapshotOfView: (UIView *)view {
  UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
  [view drawViewHierarchyInRect: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates: YES];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

- (UIImage *)takeSnapshotOfScrollView: (RCTScrollView *)scrollview {
  // Store the original frame of the scrollview to restore later
  CGRect originalFrame = scrollview.frame;
  // Set the frame of the scrollview equal to it's contentsize
  scrollview.frame = CGRectMake(0, 0, scrollview.contentSize.width, scrollview.contentSize.height);
  
  UIGraphicsBeginImageContext(scrollview.contentSize);
  [scrollview.layer renderInContext: UIGraphicsGetCurrentContext()];
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  scrollview.frame = originalFrame;
  
  return image;
}

- (instancetype)init {
  self = [super init];
  return self;
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

@end
