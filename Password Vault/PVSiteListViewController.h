//
//  PVSiteListViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVSiteListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

-(IBAction)addSite:(id)sender;
-(void)populateSiteArray;
@end
