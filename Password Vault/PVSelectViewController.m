//
//  PVSelectViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/16/12.
//
//

#import "PVSelectViewController.h"
#import "PVSiteListViewController.h"
#import "PVAddSiteViewController.h"
#import "PVCreateChatViewController.h"
#import "PVDataManager.h"
#import "PVConversationListViewController.h"

@interface PVSelectViewController ()

@end

@implementation PVSelectViewController

@synthesize showSitesBtn;
@synthesize addSiteBtn;
@synthesize chatBtn;
@synthesize mapBtn;

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
	self.navigationItem.title = @"Select option";
	
	UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
	UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	
	[showSitesBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
	[addSiteBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
	[chatBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
	[mapBtn setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setShowSitesBtn:nil];
	[self setAddSiteBtn:nil];
	[self setMapBtn:nil];
	[self setChatBtn:nil];
	[super viewDidUnload];
}

- (IBAction)showSitesClicked:(id)sender {
	PVSiteListViewController *nextView = [[PVSiteListViewController alloc] init];
	[self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)addSiteClicked:(id)sender {
	PVAddSiteViewController *nextView = [[PVAddSiteViewController alloc] init];
	[self.navigationController pushViewController:nextView animated:YES];
}

- (IBAction)chatClicked:(id)sender {
    PVDataManager *pvm = [[PVDataManager alloc] init];
    if(![pvm chatUserExist]){
        PVCreateChatViewController *nextView = [[PVCreateChatViewController alloc] init];
        [self.navigationController pushViewController:nextView animated:YES];
    }
    else{
        PVConversationListViewController *nextView = [[PVConversationListViewController alloc] init];
        [self.navigationController pushViewController:nextView animated:YES];
    }
}

- (IBAction)viewMapClicked:(id)sender {
}
@end
