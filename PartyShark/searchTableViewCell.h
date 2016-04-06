//
//  searchTableViewCell.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-08.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface searchTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (strong, nonatomic) NSString* songCellCode;

@end
