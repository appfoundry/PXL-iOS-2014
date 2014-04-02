//
//  PersonTabBarController.m
//  BigBangApp
//
//  Created by Michael Seghers on 02/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "PersonTabBarController.h"
#import "Person.h"
#import "DetailKeeper.h"

@interface PersonTabBarController ()

@end

@implementation PersonTabBarController

- (IBAction)_openWebsite:(id)sender {
    Person *selectedPerson = [DetailKeeper sharedDetailKeeper].selectedPerson;
    if (selectedPerson.websiteUrl) {
        [self performSegueWithIdentifier:@"toWebView" sender:sender];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"No website" message:@"The person has no website" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
