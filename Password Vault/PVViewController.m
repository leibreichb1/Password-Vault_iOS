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

@interface PVViewController ()

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
	NSString *msg = [[NSString alloc] initWithFormat:@"Password Vault is an application designed to teach developers and users about the dangers that an SQL Injection Attack can result with.  The application is vulnerable by design to produce a WOW factor to get people aware of dangers in Applications.\n\nCreated by Josh Newkirk and Brian Leibreich"];
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
	} else {
		if ([alertView isKindOfClass:[DDAlertPrompt class]]) {
			DDAlertPrompt *loginPrompt = (DDAlertPrompt *)alertView;
			if([loginPrompt.plainTextField.text isEqualToString:loginPrompt.secretTextField.text]){
				[pvm insertPassword:loginPrompt.plainTextField.text];
			}
			else{
				DDAlertPrompt *loginPrompt = [[DDAlertPrompt alloc] initWithTitle:@"Create Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Create"];	
				[loginPrompt show];
			}
		}
	}
}
@end
