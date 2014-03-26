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

@interface PersonDetailViewController ()

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
    // Do any additional setup after loading the view.
    Person *selectedPerson = [DetailKeeper sharedDetailKeeper].selectedPerson;
    self.tabBarController.title = selectedPerson.fullName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
