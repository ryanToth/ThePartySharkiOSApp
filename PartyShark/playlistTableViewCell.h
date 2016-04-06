//
//  playlistTableViewCell.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-04.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface playlistTableViewCell : MGSwipeTableCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;
@property (nonatomic, weak) IBOutlet UILabel *suggestorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;

@property (strong, nonatomic) NSNumber* songCellCode;

@end
