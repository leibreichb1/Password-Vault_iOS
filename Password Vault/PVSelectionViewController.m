//
//  PVSelectionViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PVSelectionViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PVSelectionViewController ()
@property (strong, nonatomic)NSMutableArray *selections;
@end

@implementation PVSelectionViewController
@synthesize selections;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	selections = [[NSMutableArray alloc] init];
	[self getAddressBook];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [selections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
	NSDictionary *tempDict = [selections objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [tempDict objectForKey:@"Name"];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
	NSDictionary *tempDict = [selections objectAtIndex:indexPath.row];
	NSString *msg = [[NSString alloc] initWithFormat:@"Name: %@\nPhone: %@\nEmail: %@", [tempDict valueForKey:@"Name"], [tempDict valueForKey:@"Phone"], [tempDict valueForKey:@"Email"]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Info" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)getAddressBook{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
	int contacts = CFArrayGetCount(people);
	for(int i = 0; i < contacts; i++){
		CFStringRef cfLastName = ABRecordCopyValue(CFArrayGetValueAtIndex(people, i), kABPersonLastNameProperty);
		CFStringRef cfFirstName = ABRecordCopyValue(CFArrayGetValueAtIndex(people, i), kABPersonFirstNameProperty);
		
		NSString *fName = [((__bridge NSString *)cfFirstName) stringByAppendingString:@" "];
		NSString *lName = ((__bridge NSString *)cfLastName);
		NSString *email;
		NSString *phone;
		NSMutableArray *emails = [[NSMutableArray alloc] init];
		NSMutableArray *phones = [[NSMutableArray alloc] init];
		
		ABMutableMultiValueRef multi = ABRecordCopyValue(CFArrayGetValueAtIndex(people, i), kABPersonPhoneProperty);
		//getPhone
		for (CFIndex j = 0; j < ABMultiValueGetCount(multi); j++) {
			CFStringRef cfPhone = ABMultiValueCopyValueAtIndex(multi, j);
			
			[phones addObject:(__bridge NSString *)cfPhone];
			
			CFRelease(cfPhone);
		}
		
		multi = ABRecordCopyValue(CFArrayGetValueAtIndex(people, i), kABPersonEmailProperty);
		//getPhone
		for (CFIndex j = 0; j < ABMultiValueGetCount(multi); j++) {
			CFStringRef cfEmail = ABMultiValueCopyValueAtIndex(multi, j);
			
			[emails addObject:(__bridge NSString *)cfEmail];
			
			CFRelease(cfEmail);
		}
		
		CFRelease(cfLastName);
		CFRelease(cfFirstName);
		if([emails count] > 0){
			email = [emails objectAtIndex:0];
		}
		else{
			email = @"";
		}
		if([phones count] > 0){
			phone = [phones objectAtIndex:0];
		}
		else{
			phone = @"";
		}
		NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[fName stringByAppendingString:lName], @"Name", email, @"Email", phone, @"Phone", nil];
		[selections addObject:tempDict];
	}
	CFRelease(addressBook);
	CFRelease(people);
}
@end
