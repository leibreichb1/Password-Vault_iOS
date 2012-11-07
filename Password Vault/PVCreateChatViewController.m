//
//  PVCreateChatViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/17/12.
//
//

#import "PVCreateChatViewController.h"
#import "PVDataManager.h"
#import "PVConversationListViewController.h"

@interface PVCreateChatViewController (){
    CGPoint originalCenter;
}

@end

@implementation PVCreateChatViewController
@synthesize usernameField;
@synthesize myData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    originalCenter = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUsernameField:nil];
    [self setCreateBtn:nil];
    [super viewDidUnload];
}
- (IBAction)createClicked:(id)sender {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://devimiiphone1.nku.edu/research_chat_client/chat_client_server/create_new_user.php"]];
		
	NSString *params = [[NSString alloc] initWithFormat:@"username=%@&OS=iOS&deviceID=1234", [usernameField text]];
	[request setHTTPMethod:@"POST"];
	//[request setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
	[request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(conn){
		myData = [[NSMutableData alloc] init];
	}
	else{
        //alert user failed
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [myData appendData:data];
	NSString *responseString  = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    if([responseString isEqualToString:@"CREATED"]){
        PVDataManager *pvm = [PVDataManager sharedDataManager];
        [pvm createChatUser:[usernameField text]];
        
        PVConversationListViewController *nextView = [[PVConversationListViewController alloc] init];
        UINavigationController *cont = self.navigationController;
        
        [cont popViewControllerAnimated:NO];
        [cont pushViewController:nextView animated:YES];
    }
    else{
        NSLog(@"%@", responseString);
    }
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender{
	[usernameField resignFirstResponder];
}

#pragma TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view.center = CGPointMake(originalCenter.x, textField.center.y-60);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.center = CGPointMake(originalCenter.x, originalCenter.y-25);
}

@end
