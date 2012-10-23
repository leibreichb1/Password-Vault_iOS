//
//  PVAddSiteViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVDataManager.h"

@interface PVAddSiteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *addSiteBtn;
@property (weak, nonatomic) IBOutlet UIButton *genPassBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)addSiteClicked:(id)sender;
- (IBAction)genPassClicked:(id)sender;
- (IBAction)clearClicked:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@end
