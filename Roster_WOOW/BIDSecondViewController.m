//
//  BIDSecondViewController.m
//  Roster_WOOW
//
//  Created by Mariana Stroie on 10/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BIDSecondViewController.h"
#import "ContactCell.h"

#define CELL_HEIGHT     50
#define CONTACTS_URL    @"http://downloadapp.youwow.me/iPhone/iOSTest/contacts.json"

@interface BIDSecondViewController ()

@end

@implementation BIDSecondViewController
@synthesize searchBar;
@synthesize activityIndicator;
@synthesize filteredArray, isFiltered;
@synthesize contactsTableView, contactsDataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"Second", @"Second");
        
        self.contactsDataArray = [NSMutableArray array];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self.activityIndicator startAnimating];
    
    NSURLRequest *requestContacts = [NSURLRequest requestWithURL:[NSURL URLWithString:CONTACTS_URL]];
    
    [NSURLConnection sendAsynchronousRequest:requestContacts 
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   [self parseData:data];
                               }
                               else {
                                   UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Connection Error" 
                                                                                       message:@"Data could not be retrieved" 
                                                                                      delegate:self 
                                                                             cancelButtonTitle:@"OK" 
                                                                             otherButtonTitles:nil] autorelease];
                                   [alertView show];
                               }
                           }];
}


- (void)parseData:(NSData *)data
{
    NSError *error = nil;
    self.contactsDataArray = [(NSDictionary *)[NSJSONSerialization JSONObjectWithData:data 
                                                                              options:NSJSONReadingMutableLeaves                                       
                                                                                error:&error] 
                              valueForKey:@"groups"];
    if (error) {
        [[[[UIAlertView alloc] initWithTitle:@"Error" 
                                   message:@"Invalid Data" 
                                  delegate:self 
                         cancelButtonTitle:@"OK" 
                           otherButtonTitles: nil] autorelease] show];
    }
    else {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        [contactsTableView reloadData];   
    }
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [self setContactsTableView:nil];
    [self setContactsDataArray:nil];
    [self setFilteredArray:nil];
    [self setSearchBar:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [contactsTableView release];
    [contactsDataArray release];
    [filteredArray release];
    [searchBar release];
    [activityIndicator release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSMutableArray *currentArray = isFiltered ? self.filteredArray:self.contactsDataArray;
    return [currentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     NSMutableArray *currentArray = isFiltered ? self.filteredArray:self.contactsDataArray;
    return [(NSArray *)[(NSDictionary *)[currentArray objectAtIndex:section] valueForKey:@"people"] count];        
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray *currentArray = isFiltered ? self.filteredArray:self.contactsDataArray;

    if ([currentArray count] > 0) {
        NSString *groupName = (NSString *)[(NSDictionary *)[currentArray objectAtIndex:section] valueForKey:@"groupName"];
        return [groupName capitalizedString];
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]
									loadNibNamed:@"ContactCell"
                                    owner:nil 
                                    options:nil];
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass: [UITableViewCell class]]) {
				cell = (ContactCell *)currentObject;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSMutableArray *currentArray = isFiltered ? self.filteredArray:self.contactsDataArray;

    NSDictionary *groupDictionary = (NSDictionary *)[currentArray objectAtIndex:indexPath.section];
    NSArray *contactsInGroup = (NSArray *)[groupDictionary valueForKey:@"people"];
    NSDictionary *contactDictionary = (NSDictionary *)[contactsInGroup objectAtIndex:indexPath.row];
    
    [cell configureWithData:contactDictionary];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - UISearchBarDelegate methods
// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // Set the boolean flag
    if (searchText.length == 0) {
        isFiltered = NO;
        [self.searchBar resignFirstResponder];
    }
    else {
        isFiltered = YES;
        if(self.filteredArray)
            [self.filteredArray removeAllObjects];
        else
            self.filteredArray = [NSMutableArray array];
        
        for (NSDictionary *groupDict in self.contactsDataArray) {
            
            // Initilaize the array with filtered contacts
            NSMutableArray *filteredContacts  = [NSMutableArray array];
            
            // Get list of contacts in this Group
            NSArray *contactsArray = [groupDict valueForKey:@"people"];
            
            for (NSDictionary *contactDict in contactsArray) {
            
                NSString *firstName = (NSString *)[contactDict valueForKey:@"firstName"];
                NSString *lastName =  (NSString *)[contactDict valueForKey:@"lastName"];
              
                // See if last name or first name contain the searched text
                NSRange contactFirstNameRange = [firstName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                NSRange contactLastNameRange = [lastName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if ((contactFirstNameRange.location != NSNotFound) || (contactLastNameRange.location != NSNotFound))
                {
                    // Add the contact to the filtered array of contacts for this group
                    [filteredContacts addObject:contactDict];
                }
            }
            
            if ([filteredContacts count] > 0) { 
                // If the search returned any results
                // Create a new group dictionary containig the filtered contacts for this group
                NSMutableDictionary *filteredGroupDictionary = [NSMutableDictionary dictionary];
                [filteredGroupDictionary setObject:(NSString *)[groupDict valueForKey:@"groupName"] forKey:@"groupName"];
                [filteredGroupDictionary setObject:filteredContacts forKey:@"people"];

                [self.filteredArray addObject:filteredGroupDictionary];
            }
        }
    }
    
    [self.contactsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
// called when keyboard search button pressed
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar;
// called when cancel button pressed
{
    [self.searchBar resignFirstResponder];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}

@end
