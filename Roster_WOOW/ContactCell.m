//
//  ContactCell.m
//  Roster_WOOW
//
//  Created by Mariana Stroie on 10/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ContactCell.h"
#define GENDER_MALE_ICON    @"contacts_list_avatar_male"
#define GENDER_FEMALE_ICON  @"contacts_list_avatar_female"
#define GENDER_UNKNOWN_ICON @"contacts_list_avatar_unknown"

@implementation ContactCell
@synthesize statusImageView;
@synthesize avatarImageView;
@synthesize statusLabel;
@synthesize nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)configureWithData:(NSDictionary *)contactDictionary
{
    NSDictionary *statusDataDictionary = (NSDictionary *)[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StatusData" ofType:@"plist"]] valueForKey:@"Statuses"];
    
    // First name and last name
    NSString *firstName = (NSString *)[contactDictionary valueForKey:@"firstName"];
    NSString *lastName = (NSString *)[contactDictionary valueForKey:@"lastName"];
    
    // Avatar (the gender of the contact is not present in the current JSON, but if it were, this is how it would go)
    if ([contactDictionary.allKeys containsObject:@"gender"]) {
        NSString *genderValue = (NSString *)[contactDictionary valueForKey:@"gender"];
        if ([genderValue isEqualToString:@"male"]) {
            self.avatarImageView.image = [UIImage imageNamed:GENDER_MALE_ICON];
        }
        else if ([genderValue isEqualToString:@"female"]) {
            self.avatarImageView.image = [UIImage imageNamed:GENDER_FEMALE_ICON];
        }
        else {
            self.avatarImageView.image = [UIImage imageNamed:GENDER_UNKNOWN_ICON];
        }
    }
    
    // Status (text and icon)
    NSString *statusMessage = (NSString *)[contactDictionary valueForKey:@"statusMessage"];
    NSString *statusIcon = (NSString *)[contactDictionary valueForKey:@"statusIcon"];
    
    
    self.nameLabel.text = [[firstName stringByAppendingString:@" "] stringByAppendingString:lastName];    
    
    NSDictionary *statusDictionary = (NSDictionary *)[statusDataDictionary valueForKey:statusIcon];
    self.statusImageView.image = [UIImage imageNamed:(NSString *)[statusDictionary valueForKey:@"icon_file"]];
    
    // If no custom status message is available, display a standard one, according to the status icon
    if ([statusMessage isEqualToString:@""]) {
        self.statusLabel.text = (NSString *)[statusDictionary valueForKey:@"message"];
    }
    else {
        self.statusLabel.text = statusMessage;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [statusImageView release];
    [avatarImageView release];
    [statusLabel release];
    [nameLabel release];
    [super dealloc];
}
@end
