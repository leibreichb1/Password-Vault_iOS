//
//  PVConversationViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 10/22/12.
//
//

#import <UIKit/UIKit.h>

@interface PVConversationViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *titleChat;
@property (weak, nonatomic) IBOutlet UITextField *messageBox;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

-(id)initWithConvo:(NSString *)convo;
- (IBAction)sendClicked:(id)sender;
- (IBAction)removeKeyboard:(id)sender;
-(IBAction)selectedUser:(id)sender;

@end
