#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static BOOL NR_IsRecording(void) {
    return [UIScreen mainScreen].isCaptured;
}

static BOOL NR_IsStatusBarView(UIView *view) {
    NSString *name = NSStringFromClass([view class]).lowercaseString;
    return [name containsString:@"statusbar"];
}

static BOOL NR_IsRed(UIColor *color) {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    if (![color getRed:&r green:&g blue:&b alpha:&a]) return NO;
    return r > 0.65 && r > g * 1.5 && r > b * 1.5 && a > 0.1;
}

%hook UIView

- (void)setBackgroundColor:(UIColor *)color {
    if (NR_IsRecording() &&
        NR_IsStatusBarView(self) &&
        NR_IsRed(color)) {
        %orig([UIColor clearColor]);
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        return;
    }

    %orig(color);
}

- (void)layoutSubviews {
    %orig;

    if (NR_IsRecording() &&
        NR_IsStatusBarView(self) &&
        NR_IsRed(self.backgroundColor)) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
}

%end
