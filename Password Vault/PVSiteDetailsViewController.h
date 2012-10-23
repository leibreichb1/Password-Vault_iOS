//
//  PVSiteDetailsViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVSiteDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *urlTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *passTextLabel;
@property (weak, nonatomic) IBOutlet UIWebView *siteWebView;

- (id)initWithUrl:(NSString *)url username:(NSString *)user password:(NSString *)pass;

@end
