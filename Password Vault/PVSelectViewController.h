//
//  PVSelectViewController.h
//  Password Vault
//
//  Created by Brian Leibreich on 10/16/12.
//
//

#import <UIKit/UIKit.h>

@interface PVSelectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *showSitesBtn;
@property (weak, nonatomic) IBOutlet UIButton *addSiteBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
- (IBAction)showSitesClicked:(id)sender;
- (IBAction)addSiteClicked:(id)sender;
- (IBAction)chatClicked:(id)sender;
- (IBAction)viewMapClicked:(id)sender;

@end
