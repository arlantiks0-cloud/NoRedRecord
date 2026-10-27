#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const void *NR_OriginalColorKey = &NR_OriginalColorKey;

static BOOL NR_IsRecording(void) {
    return UIScreen.mainScreen.isCaptured;
}

static BOOL NR_IsStatusBarView(UIView *view) {
    NSString *name = NSStringFromClass(view.class).lowercaseString;
    return [name containsString:@"statusbar"];
}

%hook UIView

- (void)setBackgroundColor:(UIColor *)color {
    if (NR_IsRecording() && NR_IsStatusBarView(self)) {
        if (!objc_getAssociatedObject(self, NR_OriginalColorKey)) {
            objc_setAssociatedObject(
                self, NR_OriginalColorKey, color,
                OBJC_ASSOCIATION_RETAIN_NONATOMIC
            );
        }

        %orig(UIColor.clearColor);
        return;
    }

    %orig(color);
}

- (void)layoutSubviews {
    %orig;

    if (NR_IsRecording() && NR_IsStatusBarView(self)) {
        %orig;
        self.backgroundColor = UIColor.clearColor;
        self.layer.backgroundColor = UIColor.clearColor.CGColor;
    } else {
        objc_setAssociatedObject(
            self, NR_OriginalColorKey, nil,
            OBJC_ASSOCIATION_RETAIN_NONATOMIC
        );
    }
}

%end
