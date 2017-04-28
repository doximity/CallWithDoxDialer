//
//  DoxDialerCaller.h
//  CallWithDoxDialer
//
//  Created on 4/25/17.
//  Copyright © 2017 Doximity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DoxDialerCaller : NSObject


/**
 The shared instance.
 
 All instance method calls will be made on this instance.

 @return The shared `DoxDialerCaller` instance
 */
+(instancetype _Nonnull)shared;


/**
 Dial the given phone number using the Doximity Dialer app.
 
 If the Doximity Dialer app is installed, it is launched with the
 given number pre-entered.

 If the app is not installed, the user is instead routed to
 the Doximity Dialer app on the App Store.
 
 @param phoneNumber The phone number to dial, as a String. It may be given
 in most reasonable formats, e.g.:
 - using numbers only: 6502333444
 - formatted: (650)233-3444
 - with a leading international area code: +1(650)233-3444
 */
-(void)dialPhoneNumber:(nonnull NSString *)phoneNumber;

/**
 The Doximity Dialer icon rendered in the default colors.

 @return The icon as a UIImage.
 */
-(nonnull UIImage *)dialerIcon;

/**
 The Doximity Dialer icon for use in tinted views.

 @return The icon as a UIImage, with rendering mode `UIImageRenderingModeAlwaysTemplate`
 */
-(nonnull UIImage *)dialerIconAsTemplate;

/**
 Generates the dialer icon using the given color.
 
 This call is relatively expensive, so if you expect to make it many times
 (e.g. for each cell in a table), consider the following alternatives:
    - cache the returned image for a color you expect to reuse.
    - use `dialerIconAsTemplate` along with a (reused) tinted view.
 
 @param color The color to fill the icon.
 @return The Doximity Dialer icon, filled with the given color.
 */
-(nonnull UIImage *)dialerIconInColor:(nonnull UIColor *)color;


@end
