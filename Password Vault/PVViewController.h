//
//  PVViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVDataManager.h"

@interface PVViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *passBtn;
@property (weak, nonatomic) IBOutlet UIButton *aboutBtn;
@property (weak, nonatomic) IBOutlet UITextField *padPassField;
@property (strong, nonatomic) PVDataManager *pvm;

- (IBAction)loginClicked:(id)sender;
- (IBAction)passBtnClicked:(id)sender;
- (IBAction)aboutBtnClicked:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@end
