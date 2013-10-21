//
//  BIDSecondViewController.h
//  Roster_WOOW
//
//  Created by Mariana Stroie on 10/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDSecondViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UISearchBarDelegate>

@property (retain, nonatomic) IBOutlet UITableView *contactsTableView;
@property (retain, nonatomic) NSMutableArray *contactsDataArray;
@property (retain, nonatomic) NSMutableArray *filteredArray;
@property (assign, nonatomic) BOOL isFiltered;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
