//
//  PVConversationViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/22/12.
//
//

#import "PVConversationViewController.h"
#import "PVDataManager.h"

@interface PVConversationViewController (){
    NSArray *users;
    NSString *convo;
    NSString *message;
    NSString *timeStr;
    UIProgressView *progress;
    UIActivityIndicatorView *spinner;
    BOOL sending;
    long height;
}
@end

@implementation PVConversationViewController
@synthesize scrollView;
@synthesize titleChat;
@synthesize messageBox;
@synthesize sendBtn;
@synthesize selectBtn;
@synthesize picker;

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
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:spinner];
    sending = NO;
    height = 10;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:tapGesture];
    
    if(convo != nil){
        [titleChat setText:[[NSString alloc] initWithFormat:@"Chat with: %@", convo]];
        [self loadConversation];
    }
    else{
        [self postForUsers];
    }
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
	UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	
	[sendBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [selectBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
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
    [self setTitleChat:nil];
    [self setPicker:nil];
    [self setSelectBtn:nil];
    [super viewDidUnload];
}

-(void)postForUsers{
    [picker setHidden:NO];
    [selectBtn setHidden:NO];
    [messageBox setHidden:YES];
    [sendBtn setHidden:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://devimiiphone1.nku.edu/research_chat_client/chat_client_server/get_users.php"]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn){
        [spinner startAnimating];
    }
    else{
        //alert user connection failed
    }

}

- (IBAction)sendClicked:(id)sender{
    PVDataManager *pvm = [[PVDataManager alloc] init];
    NSString *user = [pvm getChatUser];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://devimiiphone1.nku.edu/research_chat_client/chat_client_server/send_message.php"]];
    [request setHTTPMethod:@"POST"];
    message = [messageBox text];
    if(message != nil && ![message isEqualToString:@""]){
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        int intTime = (int)time;
        timeStr = [[NSString alloc] initWithFormat:@"%d", intTime];
        NSString *postStr;
        if(convo != nil)
            postStr = [[NSString alloc] initWithFormat:@"sender=%@&recipient=%@&message=%@&time=%d", user, convo, message, intTime];
        else
            postStr = [[NSString alloc] initWithFormat:@"sender=%@&recipient=%@&message=%@&time=%d", user, [users objectAtIndex:[picker selectedRowInComponent:0]], message, intTime];
        [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(conn){
            sending = YES;
            [spinner startAnimating];
        }
        else{
            //alert user connection failed
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(sending){
        PVDataManager *pvm = [[PVDataManager alloc] init];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([str isEqualToString:@"SENT"]){
            NSString *user = [pvm getChatUser];
            NSString *reci;
            if(convo == nil)
                reci = [users objectAtIndex:[picker selectedRowInComponent:0]];
            else
                reci = convo;
            [pvm addMessageSender:user recipient:reci otherMember:reci message:message time:timeStr];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, height, 300.0f, 460.0f)];
            [label setText:message];
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.numberOfLines = 0;
            
            [label sizeToFit];
            
            int offset = 310.0f - label.frame.size.width;
            UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, height, label.frame.size.width, label.frame.size.height)];
            [addLabel setText:[label text]];
            
            height += addLabel.frame.size.height + 10.0f;
            
            [scrollView addSubview:addLabel];
            
            CGSize size = CGSizeMake(320.0f, height);
            [scrollView setContentSize:size];
        }
    }
    else{
        NSError *e = nil;
        users = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
        [picker reloadAllComponents];
    }
    [spinner stopAnimating];
}

-(IBAction)removeKeyboard:(id)sender{
    [messageBox resignFirstResponder];
}

-(IBAction)selectedUser:(id)sender{
    NSString *str = [users objectAtIndex:[picker selectedRowInComponent:0]];
    if(str != nil)
        [titleChat setText:[[NSString alloc] initWithFormat:@"Chat with: %@", str]];
    else if(users != nil && [users count] > 0)
        [titleChat setText:[[NSString alloc] initWithFormat:@"Chat with: %@", [users objectAtIndex:0]]];
    if(users != nil){
        [picker setHidden:YES];
        [selectBtn setHidden:YES];
        [messageBox setHidden:NO];
        [sendBtn setHidden:NO];
    }
}

-(void)loadConversation{
    PVDataManager *pvm = [PVDataManager sharedDataManager];
    NSMutableArray *chat = [pvm getConversation:convo];
    for(NSDictionary *dict in chat){
        BOOL right = NO;
        int offset = 10;
        UILabel *label;
        if([convo isEqualToString:[dict objectForKey:@"sender"]]){
            label = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, height, 275.0f, 460.0f)];
            [label setBackgroundColor:[[UIColor alloc] initWithRed:0.0f green:153.0f blue:255.0f alpha:255.0f]];
            [label setText:[dict valueForKey:@"message"]];
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.numberOfLines = 0;
        }
        else{
            right = YES;
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, height, 275.0f, 460.0f)];
            [label setBackgroundColor:[[UIColor alloc] initWithRed:204.0f green:204.0f blue:204.0f alpha:255.0f]];
            [label setText:[dict valueForKey:@"message"]];
            label.numberOfLines = 0;
        }
        // resize label
        [label sizeToFit];
        if(right)
            offset = 310.0f - label.frame.size.width;
        UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, height, label.frame.size.width, label.frame.size.height)];
        [addLabel setBackgroundColor:[label backgroundColor]];
        addLabel.lineBreakMode = UILineBreakModeWordWrap;
        addLabel.numberOfLines = 0;
        [addLabel setText:[label text]];
        
        height += addLabel.frame.size.height + 10.0f;
        
        CGSize size = CGSizeMake(320.0f, height);
        [scrollView setContentSize:size];
        [scrollView addSubview:addLabel];
    }
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height + scrollView.contentInset.bottom);
    if (bottomOffset.y > 0)
        [scrollView setContentOffset: bottomOffset animated: YES];
}

-(void)hideKeyboard{
    [messageBox resignFirstResponder];
}

#pragma PickerView Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [users count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [users objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

@end
