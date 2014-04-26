//
//  CDMasterPersonTableViewController.m
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "CDMasterPersonTableViewController.h"
#import <CoreData/CoreData.h>
#import "CoreDataLocalPersonService.h"
#import "PersonCD.h"

@interface CDMasterPersonTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_frc;
    CoreDataLocalPersonService *_lps;
}

@end

@implementation CDMasterPersonTableViewController

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
    
    _lps = [CoreDataLocalPersonService sharedCoreDataLocalPersonService];
    NSFetchRequest *fr = _lps.fetchRequestForPersons;
    fr.sortDescriptors = @[
        [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES],
        [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES]
                           ];
    _frc = [[NSFetchedResultsController alloc]
            initWithFetchRequest:fr
            managedObjectContext:_lps.managedObjectContext
              sectionNameKeyPath:nil
                       cacheName:@"PersonCache"];
    _frc.delegate = self;
    
    NSError *error;
    BOOL success = [_frc performFetch:&error];
    if (!success) {
        NSLog(@"Fetch failed");
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *array = [_lps persons];
        [_lps.managedObjectContext deleteObject:array.firstObject];
        [_lps.managedObjectContext save:nil];
        
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_frc sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([[_frc sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_frc sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    PersonCD *p = [_frc objectAtIndexPath:indexPath];
    cell.textLabel.text = p.fullName;
    
    // Configure the cell with data from the managed object.
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
