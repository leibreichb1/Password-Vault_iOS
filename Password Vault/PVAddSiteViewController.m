//
//  PVAddSiteViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PVAddSiteViewController.h"
#import "PVOptionsViewController.h"

@interface PVAddSiteViewController (){
    CGPoint originalCenter;
}
@property (strong, nonatomic) NSString *keyFile;
@property (strong, nonatomic) NSMutableDictionary *usedKeys;

@end

@implementation PVAddSiteViewController
@synthesize addSiteBtn;
@synthesize genPassBtn;
@synthesize clearBtn;
@synthesize urlField;
@synthesize usernameField;
@synthesize passwordField;
@synthesize usedKeys;
@synthesize keyFile;

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
	self.navigationItem.title = @"Add Site";
    // Do any additional setup after loading the view from its nib.
	self.keyFile = [[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"];
	self.usedKeys = [[NSMutableDictionary alloc] initWithContentsOfFile:self.keyFile];
	
	UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"]; 
	UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	
	[addSiteBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
	[genPassBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
	[clearBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
}

- (void)viewDidUnload
{
    [self setAddSiteBtn:nil];
    [self setGenPassBtn:nil];
    [self setClearBtn:nil];
    [self setUrlField:nil];
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidDisappear:(BOOL)animated{
	[self.usedKeys writeToFile:self.keyFile atomically:YES];
}

- (IBAction)addSiteClicked:(id)sender {
	NSString *url = urlField.text;
	NSString *username = usernameField.text;
	NSString *password = passwordField.text;
	
	if([password isEqualToString:@"options"]){
		PVOptionsViewController *nextView = [[PVOptionsViewController alloc] init];
		[self.navigationController pushViewController:nextView animated:YES];
	}
	else if(![url isEqualToString:@""] && ![username isEqualToString:@""] && ![password isEqualToString:@""]){
		if((![url hasPrefix:@"http://"] || ![url hasPrefix:@"http://www."]) && [url hasPrefix:@"www."]){
			url = [@"http://" stringByAppendingString:url];
		}
		else if(![url hasPrefix:@"http://"] && ![url hasPrefix:@"http://www."]){
			url = [@"http://www." stringByAppendingString:url];
		}
		else if([url hasPrefix:@"http://"] && ![url hasPrefix:@"http://www."]){
			NSString *temp = [url substringFromIndex:7];
			url = [@"http://www." stringByAppendingString:temp];
		}
		PVDataManager *pvm = [PVDataManager sharedDataManager];
		[pvm insertSite:url withUser:username withPass:password];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (IBAction)genPassClicked:(id)sender {
	NSString *secPass = @"";
	NSArray *keys = [[NSArray alloc] initWithObjects: @"A",@"a",@"0",@"B",@"b",@"1",@"C",@"c",@"2",@"D",@"d",@"3",@"E",@"e",@"4",@"F",@"f",@"5",@"G",@"g",@"6",@"H",@"h",@"7",@"I",@"i",@"8",@"J",@"j",@"9",@"K",@"k",@"L",@"l",@"M",@"m",@"N",@"n",@"O",@"o",@"P",@"p",@"Q",@"q",@"R",@"r",@"S",@"s",@"T",@"t",@"U",@"u",@"V",@"v",@"W",@"w",@"X",@"x",@"Y",@"y",@"Z",@"z", nil];
	NSString *inputPw = [passwordField text];
	if(![inputPw isEqualToString:@""]){
		NSString *used = [usedKeys objectForKey:inputPw];
		if(used != NULL && ![used isEqualToString:@""]){
			secPass = used;
		}
	}
	if([secPass isEqualToString:@""]){
		while([secPass rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet] options:NSLiteralSearch].location == NSNotFound || [secPass rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet] options:NSLiteralSearch].location == NSNotFound || [secPass rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:NSLiteralSearch].location == NSNotFound){
				
			int lgth = (int) (arc4random()%16);
			while(lgth < 6)
				lgth = (int) (arc4random()%16);
			secPass = @"";
			
			for(int i = 0; i < lgth; i++){
				int passCharLoc = (int) arc4random()%[keys count];
				secPass = [secPass stringByAppendingString:[keys objectAtIndex:passCharLoc]];
			}
		}
	}
	[passwordField setText:secPass];
	[usedKeys setObject:secPass forKey:inputPw];
	[genPassBtn setEnabled:NO];
}

- (IBAction)clearClicked:(id)sender {
	[urlField setText:@""];
	[usernameField setText:@""];
	[passwordField setText:@""];
	[genPassBtn setEnabled:YES];
}

-(IBAction)textFieldDoneEditing:(id)sender{
	if(sender == urlField)
		[usernameField becomeFirstResponder];
	else if(sender == usernameField){
		[passwordField becomeFirstResponder];
	}
	else{
		[sender resignFirstResponder];
	}
}

- (IBAction)backgroundTap:(id)sender{
	[urlField resignFirstResponder];
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
}

#pragma TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == usernameField || textField == passwordField)
        self.view.center = CGPointMake(originalCenter.x, usernameField.center.y - 100);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.center = originalCenter;
}
@end
