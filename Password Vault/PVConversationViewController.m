//
//  PVConversationViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/22/12.
//
//

#import "PVConversationViewController.h"
#import "PVDataManager.h"

@interface PVConversationViewController ()

@end

@implementation PVConversationViewController
@synthesize scrollView;
@synthesize messageBox;
@synthesize sendBtn;
@synthesize userBtn;
@synthesize convo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithConvo:(NSString *)curConvo{
    self = [super init];
    convo = curConvo;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(convo != nil){
        [userBtn setTitle:convo forState:UIControlStateNormal];
    }
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
	UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	
	[sendBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setSendBtn:nil];
    [self setMessageBox:nil];
    [self setUserBtn:nil];
    [super viewDidUnload];
}

- (IBAction)sendClicked:(id)sender{
    PVDataManager *pvm = [[PVDataManager alloc] init];
    NSString *user = [pvm getChatUser];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://devimiiphone1.nku.edu/research_chat_client/chat_client_server/send_message.php"]];
    [request setHTTPMethod:@"POST"];
    NSString *str = [messageBox text];
    if(str != nil && ![str isEqualToString:@""]){
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        int intTime = (int)time;
        NSLog(@"%d", intTime);
        NSString *postStr = [[NSString alloc] initWithFormat:@"sender=%@&recipient=%@&message=%@&time=%d", user, convo, str, intTime];
        [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(!conn){
            //alert user connection failed
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
}

-(IBAction)removeKeyboard:(id)sender{
    [messageBox resignFirstResponder];
}
@end
