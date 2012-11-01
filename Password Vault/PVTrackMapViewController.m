//
//  PVTrackMapViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/31/12.
//
//

#import "PVTrackMapViewController.h"

#define METERS_PER_MILE 1609.344

@interface PVTrackMapViewController ()
{
    BOOL showingSelector;
    NSMutableArray *userArray;
    int height;
}
@end

@implementation PVTrackMapViewController
@synthesize finishBtn;
@synthesize _mapView;
@synthesize _selectView;
@synthesize myTableView;

- (id)init
{
    self = [super init];
    if (self) {
        showingSelector = NO;
    }
    return self;
}
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
    
    height = _selectView.frame.size.height;
    
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    
    userArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 20; i++){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[[NSString alloc] initWithFormat:@"%d", i] forKey:@"User"];
        [dict setObject:@"NO" forKey:@"Selected"];
        [userArray addObject:dict];
    }

    CGRect selectFrame = _selectView.frame;
    selectFrame.size.height = 0;
    _selectView.frame = selectFrame;
    
    CGRect btnFrame = finishBtn.frame;
    btnFrame.origin.y -= 44;
    finishBtn.frame = btnFrame;
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.029579;
    zoomLocation.longitude = -84.463509;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];

    UIBarButtonItem *usersBtn = [[UIBarButtonItem alloc] initWithTitle:@"Users" style:UIBarButtonItemStylePlain target:self action:@selector(hideShowList)];
	self.navigationItem.rightBarButtonItem = usersBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self set_mapView:nil];
    [self set_selectView:nil];
    [self setFinishBtn:nil];
    [self setMyTableView:nil];
    [super viewDidUnload];
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
    return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellAccessoryNone reuseIdentifier:CellIdentifier];
	}
    
    // Configure the cell...
    cell.textLabel.text = [[userArray objectAtIndex:indexPath.row ] valueForKey:@"User"];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[pvm removeSite:[siteArray objectAtIndex:indexPath.row]];
//		[self populateSiteArray];
		[_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		[_tableView reloadData];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
	//NSString *siteName = [userArray objectAtIndex:indexPath.row];
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSMutableDictionary *dict = [userArray objectAtIndex:indexPath.row];
        [dict setObject:@"YES" forKey:@"Selected"];
        
    }else{
    	thisCell.accessoryType = UITableViewCellAccessoryNone;
        NSMutableDictionary *dict = [userArray objectAtIndex:indexPath.row];
        [dict setObject:@"NO" forKey:@"Selected"];
    }
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    if([[[userArray objectAtIndex:indexPath.row] valueForKey:@"Selected"] isEqualToString:@"YES"])
        return UITableViewCellAccessoryCheckmark;
    return UITableViewCellAccessoryNone;
}

#pragma mark - Custom methods
- (void)hideShowList
{
	[UIView animateWithDuration:0.3 animations:^{
        CGRect selectFrame = _selectView.frame;
        CGRect btnFrame = finishBtn.frame;
		if(showingSelector)
		{
			selectFrame.size.height = 0;
            btnFrame.origin.y -= 44;
		} else {
			selectFrame.size.height = height;
            btnFrame.origin.y += 44;
		}
        showingSelector = !showingSelector;
        finishBtn.frame = btnFrame;
        _selectView.frame = selectFrame;
	}];
}

@end
