//
//  PVSiteDetailsViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PVSiteDetailsViewController.h"

@interface PVSiteDetailsViewController ()
{
	BOOL showingPWInfo;
}
@property (strong, nonatomic) NSString *urlAddress;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@end

@implementation PVSiteDetailsViewController
@synthesize urlTextLabel;
@synthesize userTextLabel;
@synthesize passTextLabel;
@synthesize siteWebView;
@synthesize urlAddress;
@synthesize username;
@synthesize password;

- (id)initWithUrl:(NSString *)url username:(NSString *)user password:(NSString *)pass
{
    self = [super initWithNibName:@"PVSiteDetailsViewController" bundle:nil];
    if (self) {
		self.urlAddress = url;
		self.username = user;
		self.password = pass;
		showingPWInfo = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [urlTextLabel setText:self.urlAddress];
	[userTextLabel setText:self.username];
	[passTextLabel setText:self.password];
	NSURL *url = [NSURL URLWithString:self.urlAddress];
	NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
	[siteWebView loadRequest:requestUrl];
	
	UIBarButtonItem *infoBtn = [[UIBarButtonItem alloc] initWithTitle:@"info" style:UIBarButtonItemStylePlain target:self action:@selector(hideShowPWInfo)];
	self.navigationItem.rightBarButtonItem = infoBtn;
}


- (void)hideShowPWInfo
{
	[UIView animateWithDuration:0.3 animations:^{
		CGRect frame = siteWebView.frame;
		if(showingPWInfo)
		{
			frame.origin.y -= 107;
			frame.size.height += 107;
			showingPWInfo = !showingPWInfo;
		} else {
			frame.origin.y += 107;
			frame.size.height -= 107;
			showingPWInfo = !showingPWInfo;
		}
		siteWebView.frame = frame;
	}];
}

- (void)viewDidUnload
{
    [self setUrlTextLabel:nil];
    [self setUserTextLabel:nil];
    [self setPassTextLabel:nil];
    [self setSiteWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
