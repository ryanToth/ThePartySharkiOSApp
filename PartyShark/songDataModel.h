//
//  songDataModel.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-10.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface songDataModel : NSObject

@property (strong, nonatomic) NSString *songCode;
@property (strong, nonatomic) NSString *songAlbum;
@property (strong, nonatomic) NSString *songTitle;
@property (strong, nonatomic) NSString *songArtist;
@property (strong, nonatomic) UIImage  *albumArt;


@end
