//
//  PVConversationListViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/17/12.
//
//

#import "PVConversationListViewController.h"
#import "PVConversationViewController.h"
#import "PVDataManager.h"

@interface PVConversationListViewController ()

@end

@implementation PVConversationListViewController

@synthesize convos;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    
    PVDataManager *pvm = [PVDataManager sharedDataManager];
    
    NSString *username = [pvm getChatUser];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://devimiiphone1.nku.edu/research_chat_client/chat_client_server/get_messages.php"]];
    
	NSString *params = [[NSString alloc] initWithFormat:@"username=%@&deviceID=1234", username];
	[request setHTTPMethod:@"POST"];
	//[request setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
	[request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(conn){
	}
	else{
        //alert user failed
	}

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *infoBtn = [[UIBarButtonItem alloc] initWithTitle:@"New conversation" style:UIBarButtonItemStylePlain target:self action:@selector(newConvo)];
	self.navigationItem.rightBarButtonItem = infoBtn;
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
    return [convos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [convos objectAtIndex:indexPath.row];
    [cell.textLabel setText:[dict objectForKey:@"other_member"]];
    [cell.detailTextLabel setText:[dict objectForKey:@"message"]];
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
        
        NSString *otherUser = [[convos objectAtIndex:indexPath.row] objectForKey:@"other_member"];
        PVDataManager *pvm = [PVDataManager sharedDataManager];
        [pvm deleteConvo:otherUser];
        
        // Delete the row from the data source
        [convos removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

    NSDictionary *dict = [convos objectAtIndex:indexPath.row];
    PVConversationViewController *nextView = [[PVConversationViewController alloc] initWithConvo:[dict objectForKey:@"other_member"]];
    [self.navigationController pushViewController:nextView animated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    NSError *e;
    NSArray *json = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e]];
    PVDataManager *pvm = [PVDataManager sharedDataManager];
    NSString *user = [pvm getChatUser];
    for(NSDictionary *dict in json){
        NSString *sender = [dict objectForKey:@"sender"];
        NSString *reci = user;
        NSString *other = sender;
        NSString *mess = [dict objectForKey:@"message"];
        NSString *time = [dict objectForKey:@"timestamp"];
        
        [pvm addMessageSender:sender recipient:reci otherMember:other message:mess time:time];
    }
    
    [self loadConvos];
}

-(void)loadConvos{
    PVDataManager *pvm = [PVDataManager sharedDataManager];
    convos = [pvm getConvoList];
    [self.tableView reloadData];
}

-(void)newConvo{
    PVConversationViewController *nextView = [[PVConversationViewController alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
}
@end
