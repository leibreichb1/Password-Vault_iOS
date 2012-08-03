//
//  PVAppDelegate.h
//  Password Vault
//
//  Created by Brian Leibreich on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PVViewController;

@interface PVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PVViewController *viewController;

@end
