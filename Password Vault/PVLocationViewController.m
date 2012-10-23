//
//  PVLocationViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/16/12.
//
//

#import "PVLocationViewController.h"
#import "PVDataManager.h"
#import "PVCell.h"
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLPlacemark.h>

//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

@interface PVLocationViewController ()

@end

@implementation PVLocationViewController
@synthesize jArray;

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

    PVDataManager *pvm = [[PVDataManager alloc] init];
    NSString *user = [pvm getChatUser];
    
    NSLog(@"%@", user);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://devimiiphone1.nku.edu/research_chat_client/password_vault_server/get_my_locations.php"]];
    [request setHTTPMethod:@"POST"];
    NSString *postStr = [[NSString alloc] initWithFormat:@"username=%@", user];
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn){
        //alert user connection failed
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [jArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:@"PVCell" owner:nil options:nil];
        for (id currentObject in nibObjects) {
            if([currentObject isKindOfClass:[PVCell class]])
            {
                cell = (PVCell *)currentObject;
                break;
            }
        }
    }
    
    NSDictionary *dict = [jArray objectAtIndex:indexPath.row];
    NSLog(@"%@", dict);
    [cell.addressLabel setText:[dict objectForKey:@"Addr"]];
    [cell.latLabel setText:[dict objectForKey:@"lat"]];
    [cell.lonLabel setText:[dict objectForKey:@"lon"]];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    NSError *e;
    jArray = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e]];
    for(int i = 0; i < [jArray count]; i++){
        CLGeocoder *coder = [[CLGeocoder alloc] init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[jArray objectAtIndex:i]];
        CLLocationDegrees lat = [[dict objectForKey:@"lat"] doubleValue];
        CLLocationDegrees lon = [[dict objectForKey:@"lon"] doubleValue];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        [dict setObject:loc forKey:@"Loc"];
        [jArray setObject:dict atIndexedSubscript:i];
        [coder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            for(CLPlacemark *mark in placemarks){
                NSDictionary *markDict = [mark addressDictionary];
                NSString *str = [[NSString alloc] initWithFormat:@"%@, %@", [markDict objectForKey:@"City"], [mark postalCode]];
                [dict setObject:str forKey:@"Addr"];
                [jArray setObject:dict atIndexedSubscript:i];
            }
            [self.tableView reloadData];
        }];
    }
}

//-(void)addAddr:(CLPlacemark *)mark givenLoc:(CLLocation *)givenLoc{
//    NSDictionary *dict1 = [mark addressDictionary];
//    NSString *str = [[NSString alloc] initWithFormat:@"%@, %@", [dict1 objectForKey:@"City"], [mark postalCode]];
//    for(NSMutableDictionary *dict in jArray){
//        if([){
//            [dict setObject:str forKey:@"Addr"];
//        }
//    }
//}
@end
