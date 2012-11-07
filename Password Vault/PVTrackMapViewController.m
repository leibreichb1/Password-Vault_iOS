//
//  PVTrackMapViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/31/12.
//
//

#import "PVTrackMapViewController.h"
#import "PVTrackedLocation.h"

#define METERS_PER_MILE 1609.344

@interface PVTrackMapViewController ()
{
    BOOL showingSelector;
    BOOL gettingUsers;
    NSMutableArray *userArray;
    NSMutableArray *userPoints;
    MKMapRect _routeRect;
    UIActivityIndicatorView *spinner;
    NSArray *colors;
    int color;
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
    
    colors = [[NSArray alloc] initWithObjects:[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], nil];
    color = 0;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    height = _selectView.frame.size.height;
    
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    
    userArray = [[NSMutableArray alloc] init];

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
    [self postForUsers];
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

#pragma mark - MapView Delegate Methods
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated{
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *pv = [[MKPolylineView alloc] initWithPolyline:overlay];
    pv.fillColor = [colors objectAtIndex:color % [colors count]];
    pv.strokeColor = [colors objectAtIndex:color % [colors count]];
    color++;
    pv.lineWidth = 3;
    return pv;
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

-(IBAction)getSelectedUsers:(id)sender{
    [self hideShowList];
    [_mapView removeOverlays:[_mapView overlays]];
    [_mapView removeAnnotations:[_mapView annotations]];
    NSMutableString *selectedUsers = [[NSMutableString alloc] initWithFormat:@""];
    for(int i = 0; i < [userArray count]; i++){
        NSMutableDictionary *dict = [userArray objectAtIndex:i];
        if ([[dict objectForKey:@"Selected"] isEqualToString:@"YES"]) {
            [selectedUsers appendFormat:@"%@,", [dict objectForKey:@"User"]];
        }
    }
    if(![selectedUsers isEqualToString:@""]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://devimiiphone1.nku.edu/research_chat_client/password_vault_server/get_locations.php"]];
        [request setHTTPMethod:@"POST"];
        NSString *postStr = [[NSString alloc] initWithFormat:@"users=%@", [selectedUsers substringToIndex:[selectedUsers length]-1]];
        NSLog(@"%@", postStr);
        [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(conn){
            [spinner startAnimating];
        }
        else{
            //alert user connection failed
        }
    }

}

-(void)postForUsers{
    gettingUsers = YES;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://devimiiphone1.nku.edu/research_chat_client/password_vault_server/get_tracked_users.php"]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn){
        [spinner startAnimating];
    }
    else{
        //alert user connection failed
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSError *e;
    if(gettingUsers){
        NSArray *json = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e]];
        gettingUsers = false;
        userArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < [json count]; i++){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[json objectAtIndex:i] forKey:@"User"];
            [dict setObject:@"NO" forKey:@"Selected"];
            [userArray addObject:dict];
        }
        [myTableView reloadData];
    }
    else{
        userPoints = [[NSMutableArray alloc] init];
        NSDictionary *json = [[NSDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e]];
        for(int i = 0; i < [userArray count]; i++){
            if([[[userArray objectAtIndex:i] objectForKey:@"Selected"] isEqualToString:@"YES"]){
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                NSString *user = [[userArray objectAtIndex:i] valueForKey:@"User"];
                NSLog(@"%@", user);
                NSLog(@"%@", [json objectForKey:user]);
                NSArray *dict = [[NSArray alloc] initWithArray:[json objectForKey:user]];
                for(int j = 0; j < [dict count]; j++){
                    double lat = [[[dict objectAtIndex:j] valueForKey:@"lat"] doubleValue];
                    double lon = [[[dict objectAtIndex:j] valueForKey:@"lon"] doubleValue];
                    CLGeocoder *coder = [[CLGeocoder alloc] init];
                    CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                    [tempArr addObject:loc];
                    CLLocationCoordinate2D cord;
                    cord.latitude = lat;
                    cord.longitude = lon;
                    PVTrackedLocation *trackLoc = [[PVTrackedLocation alloc] initWithName:@"" address:@"" coordinate:cord];
                    [_mapView addAnnotation:trackLoc];
                    [coder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
                        for(CLPlacemark *mark in placemarks){
                            NSDictionary *markDict = [mark addressDictionary];
                            NSString *str = [[NSString alloc] initWithFormat:@"%@, %@", [markDict objectForKey:@"City"], [mark postalCode]];
                            for(PVTrackedLocation *ano in [_mapView annotations]){
                                if([ano cord].latitude == lat && [ano cord].longitude == lon){
                                    [ano setAddress:str];
                                    [ano setName:user];
                                }
                            }
                        }
                    }];
                }
                [userPoints addObject:tempArr];
            }
        }
        [self loadRoute];
    }
    [spinner stopAnimating];
}

-(void)loadRoute{
    for(int i = 0; i < [userPoints count]; i++){
        MKMapPoint northEastPoint;
        MKMapPoint southWestPoint;
        NSArray *locations = [userPoints objectAtIndex:i];
        MKMapPoint* pointArr = malloc(sizeof(MKMapPoint) *[locations count]);
        for(int idx = 0; idx < [locations count]; idx++)
        {
            CLLocation *tempLoc = (CLLocation*)[locations objectAtIndex:idx];
            
            CLLocationDegrees latitude  = tempLoc.coordinate.latitude;
            CLLocationDegrees longitude = tempLoc.coordinate.longitude;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            
            MKMapPoint point = MKMapPointForCoordinate(coordinate);
            
            // if it is the first point, just use them, since we have nothing to compare to yet.
            if (idx == 0) {
                northEastPoint = point;
                southWestPoint = point;
            }
            else
            {
                if (point.x > northEastPoint.x)
                    northEastPoint.x = point.x;
                if(point.y > northEastPoint.y)
                    northEastPoint.y = point.y;
                if (point.x < southWestPoint.x)
                    southWestPoint.x = point.x;
                if (point.y < southWestPoint.y)
                    southWestPoint.y = point.y;
            }
            pointArr[idx] = point;
        }
        MKPolyline *pl = [MKPolyline polylineWithPoints:pointArr count:[locations count]];
        if (MKMapRectIsNull(_routeRect))
            _routeRect = pl.boundingMapRect;
        else
            _routeRect = MKMapRectUnion(_routeRect, pl.boundingMapRect);
        [_mapView addOverlay:pl];
        free(pointArr);
    }
}

@end
