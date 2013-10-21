//
//  ContactCell.h
//  Roster_WOOW
//
//  Created by Mariana Stroie on 10/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *statusImageView;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

- (void)configureWithData:(NSDictionary *)contactDictionary;

@end
