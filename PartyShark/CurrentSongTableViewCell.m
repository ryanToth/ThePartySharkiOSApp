//
//  CurrentSongTableViewCell.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-03.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "CurrentSongTableViewCell.h"

@implementation CurrentSongTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
    }
    
    return self;
}

@end
