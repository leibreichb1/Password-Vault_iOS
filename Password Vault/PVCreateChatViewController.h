//
//  PVCreateChatViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 10/17/12.
//
//

#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

@interface PVCreateChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (strong, nonatomic) NSMutableData *myData;
- (IBAction)createClicked:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@end