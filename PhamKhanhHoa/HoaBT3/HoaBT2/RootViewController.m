//
//  RootViewController.m
//  HoaBT2
//
//  Created by MrHoa on 12/13/15.
//  Copyright (c) 2015 MrHoa. All rights reserved.
//

#import "RootViewController.h"
#import <CoreData/CoreData.h>

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
{
    __weak IBOutlet UITableView *tbView;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Traditional Multi-Context";
    UIBarButtonItem *btDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionDelete:)];
    self.navigationItem.rightBarButtonItem = btDelete;
    [[CoreData shared] managedObjectContext];


    [self performSelectorInBackground:@selector(getData) withObject:nil];
    
    [[[CoreData shared] managedObjectContext] performBlock:^{
        [[CoreData shared] saveContext];
    }];
    NSError *error = nil;
    self.fetchedResultsController.delegate = self;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (void) getData {
    for (int i=0; i<=20; i++) {
        [self performSelectorInBackground:@selector(xuLy1) withObject:nil];
        [self performSelectorInBackground:@selector(xuLy2) withObject:nil];
        [self performSelectorInBackground:@selector(xuLy3) withObject:nil];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(IBAction)actionDelete:(id)sender{
    [[CarDAO shared] deleteAllCar];
    [tbView reloadData];
}
- (void)xuLy1{
        [[[CoreData shared] tmpManagedOC] performBlock:^{
            NSString *name = @"Car Number x";
            NSString *stt;
            for (int i = 1; i <= 3; i++) {
                stt = @(i).stringValue;
                CDCar *car = (CDCar *)[NSEntityDescription insertNewObjectForEntityForName:@"CDCar" inManagedObjectContext:[[CoreData shared] tmpManagedOC] ];
                car.stt = stt;
                car.name = name;
                [[CoreData shared] tmpSaveContext];
                NSLog(@"Thread1->%i",i);
            }
        }];
}
- (void)xuLy2{
        [[[CoreData shared] tmpManagedOC1] performBlock:^{
            NSString *name = @"Car Number y";
            NSString *stt;
            for (int i = 1; i <= 3; i++) {
                stt = @(i).stringValue;
                CDCar *car = (CDCar *)[NSEntityDescription insertNewObjectForEntityForName:@"CDCar" inManagedObjectContext:[[CoreData shared] tmpManagedOC1] ];
                car.stt = stt;
                car.name = name;
                [[CoreData shared] tmpSaveContext1];
                NSLog(@"Thread2->%i",i);
            }
        }];
}
- (void)xuLy3{
        [[[CoreData shared] tmpManagedOC2] performBlock:^{
            NSString *name = @"Car Number z";
            NSString *stt;
            for (int i = 1; i <= 3; i++) {
                stt = @(i).stringValue;
                CDCar *car = (CDCar *)[NSEntityDescription insertNewObjectForEntityForName:@"CDCar" inManagedObjectContext:[[CoreData shared] tmpManagedOC2] ];
                car.stt = stt;
                car.name = name;
                [[CoreData shared] tmpSaveContext2];
                NSLog(@"Thread3->%i",i);
            }
        }];
}
-(NSFetchedResultsController *)fetchedResultsController {
    if(_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [[CarDAO shared] loadAllCarsController];
    return _fetchedResultsController;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    CDCar *car = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = car.stt;
    cell.detailTextLabel.text = car.name;
    return cell;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [tbView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tbView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tbView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        case NSFetchedResultsChangeMove:
            [tbView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            [tbView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [tbView endUpdates];
}
@end
