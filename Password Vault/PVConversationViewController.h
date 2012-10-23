//
//  PVConversationViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 10/22/12.
//
//

#import <UIKit/UIKit.h>

@interface PVConversationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *messageBox;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (strong, nonatomic) NSString *convo;

-(id)initWithConvo:(NSString *)convo;
- (IBAction)sendClicked:(id)sender;
- (IBAction)removeKeyboard:(id)sender;

@end
