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
-(nonnull UIImage *)doximityIcon;

/**
 The Doximity Dialer icon for use in tinted views.

 @return The icon as a UIImage, with rendering mode `UIImageRenderingModeAlwaysTemplate`
 */
-(nonnull UIImage *)doximityIconAsTemplate;


@end
