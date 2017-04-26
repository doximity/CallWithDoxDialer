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
    NSURL *_dialerSchemeURL;
    NSURL *_openDialerInAppStoreURL;
    UIImage *_dialerIcon;
    UIImage *_dialerIconAsTemplate;
}
@end


@implementation DoxDialerCaller

#pragma mark - Publically Available Properties / Methods -

#pragma mark Shared Instance Generator
+(id _Nonnull)shared {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}


#pragma mark Methods
-(void)dialPhoneNumber:(nonnull NSString *)phoneNumber {
    if (self.isDialerInstalled) {
        NSString *urlEscapedPhoneNumber = [phoneNumber stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSURL *launchDialerURL = [NSURL URLWithString:[NSString stringWithFormat:@"/call?targetNumber=%@", urlEscapedPhoneNumber]
                                        relativeToURL:self.dialerSchemeURL];
        [UIApplication.sharedApplication openURL:launchDialerURL];
    }
    else {
        [UIApplication.sharedApplication openURL:self.openDialerInAppStoreURL];
    }
}



#pragma mark Icons
-(nonnull UIImage *)dialerIcon {
    if(!_dialerIcon) {
        NSBundle *libraryBundle = [NSBundle bundleForClass:[DoxDialerCaller class]];
        NSURL *assetsBundleUrl = [libraryBundle URLForResource:@"CallWithDoxDialer" withExtension:@"bundle"];
        NSBundle *assetsBundle = [NSBundle bundleWithURL:assetsBundleUrl];
        
        _dialerIcon = [UIImage imageNamed:@"doximity-dialer-icon"
                                 inBundle:assetsBundle
            compatibleWithTraitCollection:nil];
    }
    return _dialerIcon;
}

-(nonnull UIImage *)dialerIconAsTemplate {
    if(!_dialerIconAsTemplate) {
        _dialerIconAsTemplate = [self.dialerIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _dialerIconAsTemplate;
}


/**
 Generates the dialer icon using the given color.
 This call is relatively expensive, so if you expect to make it many times
 (e.g. for each cell in a table), consider the following alternatives:
 - cache the returned image for a color you expect to reuse.
 - use `dialerIconAsTemplate` along with a (reused) tinted view.
 
 @param color The color to fill the icon.
 @return The Doximity Dialer icon, filled with the given color.
 */
-(nonnull UIImage *)dialerIconInColor:(nonnull UIColor *)color {
    UIImage *returned;
    UIImage *templateImage = self.dialerIconAsTemplate;
    
    UIGraphicsBeginImageContextWithOptions(templateImage.size, NO, templateImage.scale);
    [color set];
    [self.dialerIconAsTemplate drawInRect:CGRectMake(0, 0, templateImage.size.width, templateImage.size.height)];
    returned = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returned;
}



#pragma mark - Private Internal Properties -

#pragma mark Lazy Properties
-(nonnull NSURL *)dialerSchemeURL {
    if(!_dialerSchemeURL) {
        _dialerSchemeURL = [NSURL URLWithString:@"DoximityDialer://"];
    }
    return _dialerSchemeURL;
}

-(nonnull NSURL *)openDialerInAppStoreURL {
    if(!_openDialerInAppStoreURL) {
        NSString *appIdentifyingName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        
        _openDialerInAppStoreURL = [NSURL URLWithString:
                                    [NSString stringWithFormat:@"https://app.appsflyer.com/id1157770564?pid=third_party_app&c=%@", appIdentifyingName]];
    }
    return _openDialerInAppStoreURL;
}

#pragma mark Private Helpers
-(BOOL)isDialerInstalled {
    return [UIApplication.sharedApplication canOpenURL:self.dialerSchemeURL];
}








@end
