//
//  CurrentSongTableViewCell.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-03.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface CurrentSongTableViewCell : MGSwipeTableCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *albumLabel;
@property (nonatomic, weak) IBOutlet UIImageView *albumView;

@property (nonatomic) IBOutlet UILabel *completedDuration;
@property (nonatomic) IBOutlet UILabel *totalDuration;

@property (strong, nonatomic) NSNumber* songCellCode;

@end
