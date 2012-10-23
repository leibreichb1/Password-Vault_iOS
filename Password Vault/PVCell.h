//
//  PVCell.h
//  Password Vault
//
//  Created by Brian Leibreich on 10/18/12.
//
//

#import <UIKit/UIKit.h>

@interface PVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *lonLabel;

@end
