//
//  SLScrollViewKeyboardSupport.m
//  SLScrollViewKeyboardSupport
//
//  The MIT License (MIT)
//  Copyright (c) 2013-2015 Oliver Letterer, Sparrow-Labs
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "SLScrollViewKeyboardSupport.h"
#import <objc/runtime.h>

static void class_swizzleSelector(Class class, SEL originalSelector, SEL newSelector)
{
    Method origMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    if(class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

static UIEdgeInsets UIEdgeInsetsByAddingInsets(UIEdgeInsets edgeInsets, UIEdgeInsets additionalEdgeInsets)
{
    edgeInsets.top += additionalEdgeInsets.top;
    edgeInsets.left += additionalEdgeInsets.left;
    edgeInsets.bottom += additionalEdgeInsets.bottom;
    edgeInsets.right += additionalEdgeInsets.right;

    return edgeInsets;
}

static UIView *findFirstResponderInView(UIView *view)
{
    if (view.isFirstResponder) {
        return view;
    }

    for (UIView *subview in view.subviews) {
        UIView *firstResponder = findFirstResponderInView(subview);
        if (firstResponder != nil) {
            return firstResponder;
        }
    }

    return nil;
}



char *const SLScrollViewKeyboardSupportContentOffsetChangeIsExpected;

char *const SLScrollViewKeyboardSupportKeyboardSupportContentInset;
char *const SLScrollViewKeyboardSupportOriginalContentInset;

char *const SLScrollViewKeyboardSupportKeyboardSupportScrollIndicatorInsets;
char *const SLScrollViewKeyboardSupportOriginalScrollIndicatorInsets;

@interface UIScrollView (SLScrollViewKeyboardSupport)

@property (nonatomic, assign) BOOL SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected;

@property (nonatomic, assign) UIEdgeInsets SLScrollViewKeyboardSupport_keyboardSupportContentInset;
@property (nonatomic, assign) UIEdgeInsets SLScrollViewKeyboardSupport_originalContentInset;

@property (nonatomic, assign) UIEdgeInsets SLScrollViewKeyboardSupport_keyboardSupportScrollIndicatorInsets;
@property (nonatomic, assign) UIEdgeInsets SLScrollViewKeyboardSupport_originalScrollIndicatorInsets;

@end

@implementation UIScrollView (SLScrollViewKeyboardSupport)

#pragma mark - setters and getters
#pragma mark - contentOffsetChangeIsExpected

- (BOOL)SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected
{
    return [objc_getAssociatedObject(self, &SLScrollViewKeyboardSupportContentOffsetChangeIsExpected) boolValue];
}

- (void)setSLScrollViewKeyboardSupport_contentOffsetChangeIsExpected:(BOOL)SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected
{
    objc_setAssociatedObject(self, &SLScrollViewKeyboardSupportContentOffsetChangeIsExpected, @(SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - keyboardSupportContentInset

- (UIEdgeInsets)SLScrollViewKeyboardSupport_keyboardSupportContentInset
{
    NSValue *value = objc_getAssociatedObject(self, &SLScrollViewKeyboardSupportKeyboardSupportContentInset);

    if (!value) {
        return UIEdgeInsetsZero;
    } else {
        return [value UIEdgeInsetsValue];
    }
}

- (void)setSLScrollViewKeyboardSupport_keyboardSupportContentInset:(UIEdgeInsets)SLScrollViewKeyboardSupport_keyboardSupportContentInset
{
    objc_setAssociatedObject(self, &SLScrollViewKeyboardSupportKeyboardSupportContentInset, [NSValue valueWithUIEdgeInsets:SLScrollViewKeyboardSupport_keyboardSupportContentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - originalContentInset

- (UIEdgeInsets)SLScrollViewKeyboardSupport_originalContentInset
{
    NSValue *value = objc_getAssociatedObject(self, &SLScrollViewKeyboardSupportOriginalContentInset);

    if (!value) {
        return UIEdgeInsetsZero;
    } else {
        return [value UIEdgeInsetsValue];
    }
}

- (void)setSLScrollViewKeyboardSupport_originalContentInset:(UIEdgeInsets)SLScrollViewKeyboardSupport_originalContentInset
{
    objc_setAssociatedObject(self, &SLScrollViewKeyboardSupportOriginalContentInset, [NSValue valueWithUIEdgeInsets:SLScrollViewKeyboardSupport_originalContentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - keyboardSupportScrollIndicatorInsets

- (UIEdgeInsets)SLScrollViewKeyboardSupport_keyboardSupportScrollIndicatorInsets
{
    NSValue *value = objc_getAssociatedObject(self, &SLScrollViewKeyboardSupportKeyboardSupportScrollIndicatorInsets);

    if (!value) {
        return UIEdgeInsetsZero;
    } else {
        return [value UIEdgeInsetsValue];
    }
}

- (void)setSLScrollViewKeyboardSupport_keyboardSupportScrollIndicatorInsets:(UIEdgeInsets)SLScrollViewKeyboardSupport_keyboardSupportScrollIndicatorInsets
{
    objc_setAssociatedObject(self, &SLScrollViewKeyboardSupportKeyboardSupportScrollIndicatorInsets, [NSValue valueWithUIEdgeInsets:SLScrollViewKeyboardSupport_keyboardSupportScrollIndicatorInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - originalScrollIndicatorInsets

- (UIEdgeInsets)SLScrollViewKeyboardSupport_originalScrollIndicatorInsets
{
    NSValue *value = objc_getAssociatedObject(self, &SLScrollViewKeyboardSupportOriginalScrollIndicatorInsets);

    if (!value) {
        return UIEdgeInsetsZero;
    } else {
        return [value UIEdgeInsetsValue];
    }
}

- (void)setSLScrollViewKeyboardSupport_originalScrollIndicatorInsets:(UIEdgeInsets)SLScrollViewKeyboardSupport_originalScrollIndicatorInsets
{
    objc_setAssociatedObject(self, &SLScrollViewKeyboardSupportOriginalScrollIndicatorInsets, [NSValue valueWithUIEdgeInsets:SLScrollViewKeyboardSupport_originalScrollIndicatorInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Hooks

+ (void)load
{
    class_swizzleSelector(self, @selector(setContentInset:), @selector(__SLScrollViewKeyboardSupportSetContentInset:));
    class_swizzleSelector(self, @selector(setScrollIndicatorInsets:), @selector(__SLScrollViewKeyboardSupportSetScrollIndicatorInsets:));
}

- (void)__SLScrollViewKeyboardSupportSetContentInset:(UIEdgeInsets)contentInset
{
    if (self.SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected) {
        [self __SLScrollViewKeyboardSupportSetContentInset:contentInset];
    } else {
        self.SLScrollViewKeyboardSupport_originalContentInset = contentInset;

        contentInset = UIEdgeInsetsByAddingInsets(contentInset, self.SLScrollViewKeyboardSupport_keyboardSupportContentInset);
        [self __SLScrollViewKeyboardSupportSetContentInset:contentInset];
    }
}

- (void)__SLScrollViewKeyboardSupportSetScrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets
{
    if (self.SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected) {
        [self __SLScrollViewKeyboardSupportSetScrollIndicatorInsets:scrollIndicatorInsets];
    } else {
        self.SLScrollViewKeyboardSupport_originalScrollIndicatorInsets = scrollIndicatorInsets;

        scrollIndicatorInsets = UIEdgeInsetsByAddingInsets(scrollIndicatorInsets, self.SLScrollViewKeyboardSupport_keyboardSupportScrollIndicatorInsets);
        [self __SLScrollViewKeyboardSupportSetScrollIndicatorInsets:scrollIndicatorInsets];
    }
}

@end



@implementation SLScrollViewKeyboardSupport

#pragma mark - Initialization

- (id)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init]) {
        _scrollView = scrollView;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHideCallback:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShowCallback:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

#pragma mark - Memory management

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private category implementation ()

- (void)_keyboardWillShowCallback:(NSNotification *)notification
{
    UIView *firstResponder = findFirstResponderInView([[UIApplication sharedApplication] keyWindow]);
    UIScrollView *scrollView = self.scrollView;

    if (![firstResponder isDescendantOfView:scrollView]) {
        return;
    }

    CGRect endFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect keyboardFrame = [[UIApplication sharedApplication].keyWindow convertRect:endFrame toView:scrollView];

    CGRect hiddenFrame = CGRectIntersection(keyboardFrame, scrollView.bounds);
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions options = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] | UIViewAnimationOptionBeginFromCurrentState;

    CGRect responderFrame = [firstResponder convertRect:firstResponder.bounds toView:scrollView];

    [UIView animateWithDuration:duration delay:0.0f options:options animations:^{
        UIEdgeInsets additionsEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(hiddenFrame), 0.0f);
        UIEdgeInsets originalEdgeInsets = scrollView.SLScrollViewKeyboardSupport_originalContentInset;
        UIEdgeInsets originalScrollIndicatorInsets = scrollView.SLScrollViewKeyboardSupport_originalScrollIndicatorInsets;

        scrollView.SLScrollViewKeyboardSupport_keyboardSupportContentInset = additionsEdgeInsets;
        scrollView.SLScrollViewKeyboardSupport_keyboardSupportScrollIndicatorInsets = additionsEdgeInsets;

        scrollView.SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected = YES;
        scrollView.contentInset = UIEdgeInsetsByAddingInsets(originalEdgeInsets, additionsEdgeInsets);
        scrollView.scrollIndicatorInsets = UIEdgeInsetsByAddingInsets(originalScrollIndicatorInsets, additionsEdgeInsets);
        scrollView.SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected = NO;

        if (CGRectIntersectsRect(responderFrame, keyboardFrame)) {
            CGFloat offset = CGRectGetMaxY(responderFrame) - CGRectGetHeight(scrollView.frame) + CGRectGetHeight(keyboardFrame);
            [scrollView setContentOffset:CGPointMake(0.0f, offset) animated:NO];
        }
    } completion:NULL];
}

- (void)_keyboardWillHideCallback:(NSNotification *)notification
{
    UIScrollView *scrollView = self.scrollView;

    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions options = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] | UIViewAnimationOptionBeginFromCurrentState;

    [UIView animateWithDuration:duration delay:0.0f options:options animations:^{
        scrollView.SLScrollViewKeyboardSupport_keyboardSupportContentInset = UIEdgeInsetsZero;
        scrollView.SLScrollViewKeyboardSupport_keyboardSupportScrollIndicatorInsets = UIEdgeInsetsZero;

        scrollView.SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected = YES;
        scrollView.contentInset = scrollView.SLScrollViewKeyboardSupport_originalContentInset;
        scrollView.scrollIndicatorInsets = scrollView.SLScrollViewKeyboardSupport_originalScrollIndicatorInsets;
        scrollView.SLScrollViewKeyboardSupport_contentOffsetChangeIsExpected = NO;
    } completion:NULL];
}

@end
