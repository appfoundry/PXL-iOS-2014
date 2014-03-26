//
//  MasterPersonTableViewController.m
//  BigBangApp
//
//  Created by Michael Seghers on 15/03/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "MasterPersonTableViewController.h"
#import "Person.h"
#import "BundlePersonDataLoader.h"
#import "DetailKeeper.h"

@interface MasterPersonTableViewController ()  {
    NSArray *_persons;
    id<PersonDataLoader> _personDataLoader;
}

@end

@implementation MasterPersonTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self _loadData];
}

- (void) _loadData {
    [self.refreshControl beginRefreshing];
    _personDataLoader = [[BundlePersonDataLoader alloc] init];
    [_personDataLoader fetchPersonData:^(NSArray *persons, NSError *error) {
        _persons = persons;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)refresh:(id)sender {
    [self _loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Person *p = _persons[indexPath.row];
    cell.textLabel.text = p.fullName;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Person *person = _persons[indexPath.row];
    [DetailKeeper sharedDetailKeeper].selectedPerson = person;
}

@end
