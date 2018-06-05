//
//  CALayer+test.m
//  demo
//
//  Created by Duzj on 2018/6/4.
//  Copyright © 2018年 dzj. All rights reserved.
//

#import "CALayer+test.h"
#import <objc/runtime.h>

@implementation CALayer (test)

+ (void)load{
    method_exchangeImplementations(class_getInstanceMethod([CALayer class], @selector(addAnimation:forKey:)), class_getInstanceMethod([CALayer class], @selector(hackedAddAnimation:forKey:)));
}

- (void)hackedAddAnimation:(CABasicAnimation *)anim forKey:(NSString *)key{
    [self hackedAddAnimation:anim forKey:key];
    if ([anim isKindOfClass:[CAKeyframeAnimation class]]) {
        CAKeyframeAnimation *ddd = (CAKeyframeAnimation *)anim;
        NSLog(@"%@",ddd.keyTimes);
    }
    if ([anim isKindOfClass:[CABasicAnimation class]]) {
        if ([anim.keyPath isEqualToString:@"transform"]) {
            if (anim.fromValue) {
                CATransform3D fromValue = [anim.fromValue CATransform3DValue];
                CGAffineTransform ffd = CATransform3DGetAffineTransform(fromValue);
                
                NSLog(@"From:%f ,%f ,%f ,%f ,%f ,%f ",ffd.a,ffd.b,ffd.c,ffd.d,ffd.tx,ffd.ty);
            }
            if (anim.toValue) {
                CATransform3D toValue = [anim.toValue CATransform3DValue];
                CGAffineTransform ffd = CATransform3DGetAffineTransform(toValue);
//                CAKeyframeAnimation *fd = [CAKeyframeAnimation ]
                NSLog(@"From:%f ,%f ,%f ,%f ,%f ,%f ",ffd.a,ffd.b,ffd.c,ffd.d,ffd.tx,ffd.ty);
//                NSLog(@"To:%@",CATransform3DGetAffineTransform(toValue));
            }
            if (anim.byValue) {
                CATransform3D byValue = [anim.byValue CATransform3DValue];
                CGAffineTransform ffd = CATransform3DGetAffineTransform(byValue);
                
                NSLog(@"From:%f ,%f ,%f ,%f ,%f ,%f ",ffd.a,ffd.b,ffd.c,ffd.d,ffd.tx,ffd.ty);
//                NSLog(@"By:%@",CATransform3DGetAffineTransform(byValue));
            }
            NSLog(@"Duration:%.2f",anim.duration);
            NSLog(@"TimingFunction:%@",anim.timingFunction);
        }
    }
}

@end
