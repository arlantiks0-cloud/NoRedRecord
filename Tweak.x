#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// NoRedRecord
// iOS 15.7.8 — SpringBoard
// Initial diagnostic build

%ctor {
    NSLog(@"[NoRedRecord] Tweak loaded in SpringBoard");
}
