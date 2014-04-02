//
//  PersonDetailViewController.m
//  BigBangApp
//
//  Created by Michael Seghers on 26/03/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "Person.h"
#import "DetailKeeper.h"

@interface PersonDetailViewController () {
    
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_professionLabel;
    __weak IBOutlet UILabel *_realNameLabel;
    __weak IBOutlet UITextView *_bioTextView;
}

@end

@implementation PersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _loadData];
}

- (void)_loadData
{
    Person *selectedPerson = [DetailKeeper sharedDetailKeeper].selectedPerson;
    self.tabBarController.title = selectedPerson.fullName;
    _nameLabel.text = selectedPerson.fullName;
    _professionLabel.text = selectedPerson.profession;
    _realNameLabel.text = selectedPerson.realName;
    _bioTextView.text = selectedPerson.bio;
}

@end
