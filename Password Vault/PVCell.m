//
//  PVCell.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/18/12.
//
//

#import "PVCell.h"

@implementation PVCell
@synthesize addressLabel;
@synthesize latLabel;
@synthesize lonLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
