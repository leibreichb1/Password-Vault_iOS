//
//  PVSiteListViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PVSiteListViewController.h"
#import "PVAddSiteViewController.h"
#import "PVSiteDetailsViewController.h"
#import "PVDataManager.h"

@interface PVSiteListViewController ()
@property (strong, nonatomic) NSArray *siteArray;
@property (strong, nonatomic) PVDataManager *pvm;
@end

@implementation PVSiteListViewController
@synthesize siteArray;
@synthesize pvm;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"Sites List";
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	pvm = [PVDataManager sharedDataManager];
	//[self populateSiteArray];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated{
	[self populateSiteArray];
	
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [siteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    // Configure the cell...
    cell.textLabel.text = [siteArray objectAtIndex:indexPath.row];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[pvm removeSite:[siteArray objectAtIndex:indexPath.row]];
		[self populateSiteArray];
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		[self.tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
	NSString *siteName = [siteArray objectAtIndex:indexPath.row];
	//[pvm insertSite:url withUser:username withPass:password];
	NSArray *siteDetails = [pvm getSiteDetails:siteName];
	
	if(siteDetails){
		NSString *url = [siteDetails objectAtIndex:0];
		NSString *username = [siteDetails objectAtIndex:1];
		NSString *password = [siteDetails objectAtIndex:2];
		PVSiteDetailsViewController *nextView = [[PVSiteDetailsViewController alloc] initWithUrl:url username:username password:password];
		[self.navigationController pushViewController:nextView animated:YES];
	}
}

-(IBAction)addSite:(id)sender{
	PVAddSiteViewController *nextView = [[PVAddSiteViewController alloc] init];
	[self.navigationController pushViewController:nextView animated:YES];
}

-(void)populateSiteArray{
	siteArray = [pvm getSitesList];
}
@end
