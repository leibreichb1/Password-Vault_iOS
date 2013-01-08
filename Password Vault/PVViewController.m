//
//  PVViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PVViewController.h"
#import "PVSiteListViewController.h"
#import "DDAlertPrompt.h"
#import "PVSelectViewController.h"

@interface PVViewController (){
    CGPoint originalCenter;
}

@end

@implementation PVViewController
@synthesize passField;
@synthesize loginBtn;
@synthesize passBtn;
@synthesize aboutBtn;
@synthesize padPassField;
@synthesize pvm;

- (void)viewDidLoad
{
    [super viewDidLoad];
    originalCenter = self.view.center;
	self.navigationItem.title = @"Login";
	pvm = [PVDataManager sharedDataManager];
	BOOL result = [pvm doPasswordsExist];
	NSLog(@"%d",result);
	if(!result){
		DDAlertPrompt *loginPrompt = [[DDAlertPrompt alloc] initWithTitle:@"Create Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Create"];	
		[loginPrompt show];
	}
	UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"]; 
	UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	
	[loginBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
	[passBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [self setPassField:nil];
    [self setLoginBtn:nil];
    [self setPassBtn:nil];
    [self setAboutBtn:nil];
    [self setPadPassField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

- (IBAction)loginClicked:(id)sender {
	NSString *storedPW = [pvm getPassword:passField.text];
	if(![storedPW isEqualToString:@""]){
		//PVSiteListViewController *nextView = [[PVSiteListViewController alloc] init];
		//[self.navigationController pushViewController:nextView animated:YES];
		PVSelectViewController *nextVeiw = [[PVSelectViewController alloc] init];
		[self.navigationController pushViewController:nextVeiw animated:YES];
	}
	else{
		NSString *msg = [[NSString alloc] initWithFormat:@"Please enter a valid password"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Password" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}

- (IBAction)passBtnClicked:(id)sender {
	NSString *msg = [[NSString alloc] initWithFormat:@"Password: %@", passField.text];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Display Password" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

- (IBAction)aboutBtnClicked:(id)sender {
	NSString *msg = [[NSString alloc] initWithFormat:@"Password Vault is an application designed to teach developers and users about the dangers that an SQL Injection Attack can result with.  The application is vulnerable by design to produce a WOW factor to get people aware of dangers in Applications.\n\nCreated by the CAI and research team lead by Dr. Walden and Dr. Doyle"];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About Password Vault" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender{
	[passField resignFirstResponder];
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
	if ([alertView isKindOfClass:[DDAlertPrompt class]]) {
		DDAlertPrompt *loginPrompt = (DDAlertPrompt *)alertView;
		[loginPrompt.plainTextField becomeFirstResponder];		
		[loginPrompt setNeedsLayout];
	}
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([alertView isKindOfClass:[DDAlertPrompt class]] && buttonIndex == [alertView cancelButtonIndex]) {
		DDAlertPrompt *loginPrompt = [[DDAlertPrompt alloc] initWithTitle:@"Create Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Create"];	
		[loginPrompt show];
	} else if([alertView isKindOfClass:[DDAlertPrompt class]]) {
		if ([alertView isKindOfClass:[DDAlertPrompt class]]) {
			DDAlertPrompt *loginPrompt = (DDAlertPrompt *)alertView;
			if([loginPrompt.plainTextField.text isEqualToString:loginPrompt.secretTextField.text]){
				[pvm insertPassword:loginPrompt.plainTextField.text];
                UIAlertView *isDemoAlert = [[UIAlertView alloc] initWithTitle:@"DEMO?" message:@"Is this a demo?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                [isDemoAlert show];
			}
			else{
				DDAlertPrompt *loginPrompt = [[DDAlertPrompt alloc] initWithTitle:@"Create Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Create"];	
				[loginPrompt show];
			}
		}
	} else{
        if (buttonIndex != [alertView cancelButtonIndex]) {
            [self loadDemo];
        }
    }
}

#pragma TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view.center = CGPointMake(originalCenter.x, textField.center.y-60);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.center = originalCenter;
}

- (void) loadDemo{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://devimiiphone1.nku.edu/research_chat_client/chat_client_server/get_next_demo.php"]];
    
	NSString *params = @"OS=iOS&deviceID=1234";
	[request setHTTPMethod:@"POST"];
	//[request setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
	[request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(conn){
        [pvm insertSite:@"http://www.google.com" withUser:@"user" withPass:@"pass"];
        [pvm insertSite:@"http://www.nku.edu" withUser:@"student" withPass:@"password"];
        [pvm insertSite:@"http://www.yahoo.com" withUser:@"username" withPass:@"password"];
        [pvm insertSite:@"http://www.facebook.com" withUser:@"demouser@demo.com" withPass:@"pass22"];
        [pvm insertSite:@"http://www.woot.com" withUser:@"wootuser" withPass:@"wootpass"];
	}
	else{
        //alert user failed
	}

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
	NSString *responseString  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([responseString rangeOfString:@"DEMOUSER"].location != NSNotFound){
        responseString = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [pvm createChatUser:responseString];
    }
    else{
        NSLog(@"%@", responseString);
    }
}


@end
