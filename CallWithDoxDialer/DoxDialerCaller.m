//
//  DoxDialerCaller.m
//  CallWithDoxDialer
//
//  Created on 4/25/17.
//  Copyright © 2017 Doximity. All rights reserved.
//

#import "DoxDialerCaller.h"
#import <UIKit/UIKit.h>

@interface DoxDialerCaller() {
    NSURL *_doximitySchemeURL;
    NSURL *_openDoximityInAppStoreURL;
    UIImage *_doximityIcon;
    UIImage *_doximityIconAsTemplate;
}
@property (nonnull, readonly) NSString *doximityScheme;

@end


@implementation DoxDialerCaller

#pragma mark - Publically Available Properties / Methods -

#pragma mark Shared Instance Generator
+(instancetype _Nonnull)shared {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}


#pragma mark Methods
-(void)dialPhoneNumber:(nonnull NSString *)phoneNumber {
    if (self.isDoximityInstalled) {
        
        NSURLComponents *launchDialerURLComponents = [[NSURLComponents alloc] init];
        launchDialerURLComponents.scheme = self.doximityScheme;
        launchDialerURLComponents.host = @"doximity";
        launchDialerURLComponents.path = @"/dialer";
        launchDialerURLComponents.queryItems = @[
                                                 [[NSURLQueryItem alloc] initWithName:@"target_number" value:phoneNumber]
                                                 ];
        [self openURL:launchDialerURLComponents.URL];
    }
    else {
        [self openURL:self.openDoximityInAppStoreURL];
    }
}



#pragma mark Icons
-(nonnull UIImage *)doximityIcon {
    if(!_doximityIcon) {
        NSBundle *libraryBundle = [NSBundle bundleForClass:[DoxDialerCaller class]];
        NSURL *assetsBundleUrl = [libraryBundle URLForResource:@"CallWithDoxDialer" withExtension:@"bundle"];
        NSBundle *assetsBundle = [NSBundle bundleWithURL:assetsBundleUrl];
        
        _doximityIcon = [UIImage imageNamed:@"doximity-icon-black"
                                 inBundle:assetsBundle
            compatibleWithTraitCollection:nil];
    }
    return _doximityIcon;
}

-(nonnull UIImage *)doximityIconAsTemplate {
    if(!_doximityIconAsTemplate) {
        _doximityIconAsTemplate = [self.doximityIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _doximityIconAsTemplate;
}


#pragma mark - Private Internal Properties -

#pragma mark Lazy Properties
-(nonnull NSString *)doximityScheme {
    return @"doximity";
}
-(nonnull NSURL *)doximitySchemeURL {
    if(!_doximitySchemeURL) {
        NSURLComponents *dialerSchemeURLComponents = [[NSURLComponents alloc] init];
        dialerSchemeURLComponents.scheme = self.doximityScheme;
        dialerSchemeURLComponents.host = @"";
        _doximitySchemeURL = dialerSchemeURLComponents.URL;
    }
    return _doximitySchemeURL;
}

-(nonnull NSURL *)openDoximityInAppStoreURL {
    if(!_openDoximityInAppStoreURL) {
        NSString *appIdentifyingName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?: @"Unknown";
        
        _openDoximityInAppStoreURL = [NSURL URLWithString:
                                    [NSString stringWithFormat:@"https://app.appsflyer.com/id393642611?pid=third_party_app&c=%@", appIdentifyingName]];
    }
    return _openDoximityInAppStoreURL;
}

#pragma mark Private Helpers
-(BOOL)isDoximityInstalled {
    return [UIApplication.sharedApplication canOpenURL:self.doximitySchemeURL];
}


-(void)openURL:(NSURL *)url {
    
    // NOTE:
    // iOS 10 deprecated `UIApplication`'s `-openURL:` method, and replaced it with
    // `-openURL: options: completionHandler:`.
    //
    // We want code that compiles and runs without warnings or errors on both post- and pre- Xcode8/iOS 10 projects.
    //
    // Therefore we dynamically decide which code path to execute based on whether or not the iOS 10 variant of `openURL` is available.
    
    // explicitly ignore "undeclared selector" warning (would appear on Xcode < 8)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL openURLiOS10AndAbove = @selector(openURL: options: completionHandler:);
#pragma clang diagnostic pop

    if ([[UIApplication sharedApplication] respondsToSelector:openURLiOS10AndAbove]) {
        
        // Since we want the code to compile on Xcode < 8, we can't just make the method call.
        // Instead, we must construct it dynamically.
        //
        // Normally, we woudld be able to use `performSelector: withObject:` for this purpose.
        // However since the selector takes 3 arguments, and `performSelector` is limited to 2 arguments,
        // we must instead use `NSObject`'s `-methodForSelector`:
        
        // declare the method arguments:
        NSURL *arg1 = url;
        NSDictionary<NSString *, id> *arg2 = @{};
        typedef void (^OpenURLCompletionHandler)(BOOL);
        OpenURLCompletionHandler arg3 = ^void(BOOL success){ };
        
        // construct the method dynamically
        typedef void (*OpenURLMethod)(id, SEL, NSURL *, NSDictionary<NSString *, id> *, OpenURLCompletionHandler);
        OpenURLMethod openURLMethod;
        openURLMethod = (OpenURLMethod)[[UIApplication sharedApplication] methodForSelector:openURLiOS10AndAbove];
        
        // call the method
        openURLMethod([UIApplication sharedApplication], openURLiOS10AndAbove, arg1, arg2, arg3);
    }
    
    else if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:)]){
        
        // since this code path will only execute on pre-iOS 10 environments,
        // we are justified in ignoring the `deprecated` warning for this method call:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:url];
#pragma clang diagnostic pop
    }
    else {
        // This should never happen:
        NSLog(@"No available implementation for `-openURL` on `UIApplication`");
        NSLog(@"Please contact Doximity for support: dialer@doximity.com");
    }
}





@end
