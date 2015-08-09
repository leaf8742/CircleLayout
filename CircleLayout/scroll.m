//
//  scroll.m
//  CircleLayout
//
//  Created by LEAF on 14-12-24.
//  Copyright (c) 2014年 Olivier Gutknecht. All rights reserved.
//

#import "scroll.h"
#import <objc/message.h>

@implementation scroll

#warning 手势解析
//- (void)handlePan:(UIPanGestureRecognizer *)sender {
//    CGPoint point = [sender translationInView:self];
//    NSLog(@"%@", NSStringFromCGPoint(point));
//    
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    objc_msgSendSuper(&s, @selector(handlePan:), sender);
//}

//- (void)_updatePanGesture {
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    objc_msgSendSuper(&s, @selector(_updatePanGesture));
//}

//- (void)_updatePanGestureConfiguration {
//}

#warning 拉动时的皮筋效应
//- (CGPoint)_rubberBandContentOffsetForOffset:(CGPoint)offset outsideX:(char *)outsideX outsideY:(char *)outsideY {
//    // 来源_updatePanGestureConfiguration
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    id result = objc_msgSendSuper(&s, @selector(_rubberBandContentOffsetForOffset:outsideX:outsideY:),
//                                  [NSValue valueWithCGPoint:offset],
//                                  outsideX,
//                                  outsideY);
//
//    return [result CGPointValue];
//}

//- (void)_rubberBandToOffset:(CGPoint)offset {
//    !!!不断下
//}

//- (float)_rubberBandOffsetForOffset:(float)offset maxOffset:(float)max minOffset:(float)min range:(float)range outside:(BOOL)outside {
//    // 来源_rubberBandContentOffsetForOffset:outsideX:outsideY:
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    id result = objc_msgSendSuper(&s, @selector(_rubberBandOffsetForOffset:maxOffset:minOffset:range:outside:),
//                                  [NSNumber numberWithFloat:offset],
//                                  [NSNumber numberWithFloat:max],
//                                  [NSNumber numberWithFloat:min],
//                                  [NSNumber numberWithFloat:range],
//                                  [NSNumber numberWithBool:outside]);
//    if (offset != 0) {
////        NSLog(@"\narg:%f, %f, %f, %f, %d\nresult:%@", offset, max, min, range, outside, result);
//    }
//    return [result floatValue];
//}

//- (void)scrollView:(UIScrollView *)scrollView didPanAtWindowPoint:(CGPoint)point {
//    NSLog(@"%@", NSStringFromCGPoint(point));
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    objc_msgSendSuper(&s, @selector(scrollView:maxOffset:didPanAtWindowPoint:),
//                      scrollView,
//                      [NSValue valueWithCGPoint:point]);
//}

#warning 惯性，包括皮筋效应，但不调用_rubber
//- (void)_smoothScrollTimer:(id)timer {
//    !!!不断下
//}

//- (void)_smoothScrollDisplayLink:(CADisplayLink *)displayLink {
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    objc_msgSendSuper(&s, @selector(_smoothScrollDisplayLink:), displayLink);
//}

//- (void)_smoothScrollWithUpdateTime:(CFTimeInterval)time {
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    objc_msgSendSuper(&s, @selector(_smoothScrollWithUpdateTime:), [NSNumber numberWithFloat:time]);
//}

//- (void)_getStandardDecelerationOffset:(double *)arg1 forTimeInterval:(double)arg2 min:(double)arg3 max:(double)arg4 decelerationFactor:(double)arg5 decelerationLnFactor:(double)arg6 velocity:(double *)arg7 {
//    !!!不断下
//}

//- (BOOL)_getBouncingDecelerationOffset:(CFTimeInterval *)offset
//                       forTimeInterval:(CFTimeInterval)timeInterval
//                      lastUpdateOffset:(CFTimeInterval)lastUpdateOffset
//                                   min:(CFTimeInterval)min
//                                   max:(CFTimeInterval)max
//                    decelerationFactor:(CFTimeInterval)decelerationFactor
//                  decelerationLnFactor:(CFTimeInterval)decelerationLnFactor
//                              velocity:(CFTimeInterval *)velocity {
//    NSLog(@"%f, %f, %f, %f, %f, %f, %f, %f", *offset, timeInterval, lastUpdateOffset, min, max, decelerationFactor, decelerationLnFactor, *velocity);
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    id result = objc_msgSendSuper(&s, @selector(_getBouncingDecelerationOffset:forTimeInterval:lastUpdateOffset:min:max:decelerationFactor:decelerationLnFactor:velocity:),
//                                  offset,
//                                  [NSNumber numberWithDouble:timeInterval],
//                                  [NSNumber numberWithDouble:lastUpdateOffset],
//                                  [NSNumber numberWithDouble:min],
//                                  [NSNumber numberWithDouble:max],
//                                  [NSNumber numberWithDouble:decelerationFactor],
//                                  [NSNumber numberWithDouble:decelerationLnFactor],
//                                  velocity);
//    return [result boolValue];
//}

//- (void)_getStandardDecelerationOffset:(CFTimeInterval *)offset
//                       forTimeInterval:(CFTimeInterval)timeInterval
//                                   min:(CFTimeInterval)min
//                                   max:(CFTimeInterval)max
//                    decelerationFactor:(CFTimeInterval)decelerationFactor
//                  decelerationLnFactor:(CFTimeInterval)decelerationLnFactor
//                              velocity:(CFTimeInterval *)velocity {
//    
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    objc_msgSendSuper(&s, @selector(_getStandardDecelerationOffset:forTimeInterval:min:max:decelerationFactor:decelerationLnFactor:velocity:),
//                                  offset,
//                                  [NSNumber numberWithDouble:timeInterval],
//                                  [NSNumber numberWithDouble:min],
//                                  [NSNumber numberWithDouble:max],
//                                  [NSNumber numberWithDouble:decelerationFactor],
//                                  [NSNumber numberWithDouble:decelerationLnFactor],
//                                  velocity);
//
//}

#warning 画边条
//- (void)_adjustScrollerIndicators:(BOOL)arg1 alwaysShowingThem:(BOOL)arg2 {
//    struct objc_super s;
//    s.receiver = self;
//    s.super_class = [UIScrollView class];
//    objc_msgSendSuper(&s, @selector(_adjustScrollerIndicators:alwaysShowingThem:),
//                      [NSNumber numberWithBool:arg1],
//                      [NSNumber numberWithBool:arg2]);
//}

@end
