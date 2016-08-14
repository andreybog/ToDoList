//
//  ToDoItemsListViewController.m
//  ToDoList
//
//  Created by goit on 8/10/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import "ToDoItemsListViewController.h"
#import "ToDoItemsStore.h"
#import "ABSwipeableCell.h"


@interface ToDoItemsListViewController () <UITableViewDataSource, UITableViewDelegate, ABSwipeableCellDelegate>

@property (nonatomic, strong) id <ToDoItemStoreProtocol> itemsStore;
@property (weak, nonatomic) IBOutlet UITextField *summaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityControl;

@property (strong, nonatomic) NSMutableSet *cellsCurrentlyEditing;

@end

@implementation ToDoItemsListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemsStore = [[ToDoItemsStore alloc] init];
    self.cellsCurrentlyEditing = [[NSMutableSet alloc] init];
    
    for ( int i = 0; i < 6; i++ ) {
    [self addItemWithTitle:@"Buy" summary:@"When cost is low" priority:ToDoItemPriorityLow toItemsStore:self.itemsStore];
    [self addItemWithTitle:@"Sell" summary:@"When cost is high" priority:ToDoItemPriorityDefault toItemsStore:self.itemsStore];
    [self addItemWithTitle:@"Buy pickles" summary:@"12" priority:ToDoItemPriorityHigh toItemsStore:self.itemsStore];
    [self addItemWithTitle:@"Go to lecture" summary:@"01.12.2016" priority:ToDoItemPriorityDefault toItemsStore:self.itemsStore];
    [self addItemWithTitle:@"Do hometask or delegate it to smbd!!!" summary:@"Due Fri" priority:ToDoItemPriorityUrgent toItemsStore:self.itemsStore];
    }
    
}

#pragma mark - Actions

- (IBAction)actionDidTouchAddButton:(UIButton *)sender {
    
    NSString *title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ( [title length] > 0 ) {
        
        NSString *summary = [self.summaryTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        ToDoItemPriority priority = [self.priorityControl selectedSegmentIndex];
        
        [self addItemWithTitle:title summary:summary priority:priority toItemsStore:self.itemsStore];
        
         NSIndexPath *newElementIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView insertRowsAtIndexPaths: @[ newElementIndexPath ] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self resetAddItemUI];
    }
}

- (IBAction)actionTitleFieldEditingChanged:(UITextField *)sender {
    
    NSString *title = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ( [title length] > 0 ) {
        if ( ! self.addItemButton.isEnabled ) {
            [self configureButton:self.addItemButton asEnabled:YES];
        }
    } else {
        [self configureButton:self.addItemButton asEnabled:NO];
    }
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.itemsStore itemsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ToDoItem  *item = [self.itemsStore.items objectAtIndex:indexPath.row];
    
    /*
//    static NSString *identifier = @"ABSwipeableCell";
//    ABSwipeableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
     cell.delegate = self;
     cell.itemText = item.title;
     cell.accessoryType = item.isDone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
     cell.backgroundColor = item.isDone ? [UIColor colorWithWhite:0.8 alpha:1.0] : [UIColor whiteColor];
     */
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if ( ! cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:item.title];
    
    
    if ( item.isDone ) {
        cell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [title removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, [title length])];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        [title addAttribute:NSStrikethroughStyleAttributeName
                      value:@2
                      range:NSMakeRange(0, [title length])];
    }
    
    cell.textLabel.textColor = [self colorForItemPriority:item.priority];
    cell.detailTextLabel.text = item.summary;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    
//    cell.accessoryType = item.isDone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    
    
#ifdef DEBUG
//    NSLog(@"Cell recursive description:\n\n%@\n\n", [cell performSelector:@selector(recursiveDescription)]);
#endif
    
//    if ( [self.cellsCurrentlyEditing containsObject:indexPath] ) {
//        [cell openCell];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        
        ToDoItem *item = [self.itemsStore.items objectAtIndex:indexPath.row];
      
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
#ifdef DEBUG
//        NSLog(@"Cell recursive description:\n\n%@\n\n", [cell performSelector:@selector(recursiveDescription)]);
#endif
        
        [self.itemsStore removeItem:item];

        [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        NSLog(@"Unhandled editing style: %ld", editingStyle);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoItem *item = [self.itemsStore.items objectAtIndex:indexPath.row];
    
    item.done = !item.isDone;
    
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationNone;
    NSIndexPath *newIndexPath = nil;
    
    [tableView reloadRowsAtIndexPaths: @[ indexPath ] withRowAnimation:rowAnimation];
    
    if ( item.isDone ) {
        
        newIndexPath = [NSIndexPath indexPathForRow:[self.itemsStore itemsCount]-1 inSection:0];
        rowAnimation = UITableViewRowAnimationNone;
        
    } else {
        
        rowAnimation = UITableViewRowAnimationAutomatic;
        newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    
    [self.itemsStore removeItem:item];
    [self.itemsStore insertItem:item atIndex:newIndexPath.row];
}

#pragma mark - Help functions

- (void) addItemWithTitle:(NSString *) title summary:(NSString *) summary
                 priority:(ToDoItemPriority) priority toItemsStore:(ToDoItemsStore *) itemsStore {
    
    ToDoItem *item = [[ToDoItem alloc] init];
    item.title = title;
    item.summary = summary;
    item.priority = priority;
    
    [itemsStore insertItem:item atIndex:0];
}

- (void) configureButton:(UIButton *) button asEnabled:(BOOL) enabled {
    
    UIColor *enableColor = [UIColor colorWithRed:48/255.0 green:131/255.0 blue:251/255.0 alpha:1.0];
    UIColor *backgroundColor = enabled ? enableColor : [UIColor lightGrayColor];
    
    button.enabled = enabled;
    button.backgroundColor = backgroundColor;
}

- (UIColor *) colorForItemPriority:(ToDoItemPriority) priority {
    
    switch (priority) {
        case ToDoItemPriorityLow:
            return [UIColor grayColor];
        case ToDoItemPriorityDefault:
            return [UIColor blackColor];
        case ToDoItemPriorityHigh:
            return [UIColor orangeColor];
        case ToDoItemPriorityUrgent:
            return [UIColor redColor];
    }
}

- (void) resetAddItemUI {
    
    self.titleTextField.text = nil;
    self.summaryTextField.text = nil;
    
    [self.view endEditing:YES];
    [self configureButton:self.addItemButton asEnabled:NO];
    [self.priorityControl setSelectedSegmentIndex:ToDoItemPriorityDefault];
}

#pragma mark - ABSwipeableCellDelegate

- (void) buttonOneActionForItemText:(NSString *) itemText {
    NSLog(@"In delegate, clicke button one for %@", itemText);
}

- (void) buttonTwoActionForItemText:(NSString *) itemText {
    NSLog(@"In delegate, clicke button two for %@", itemText);
}

- (void) cellDidOpen:(UITableViewCell *) cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:indexPath];
}

- (void) cellDidClose:(UITableViewCell *) cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.cellsCurrentlyEditing removeObject:indexPath];
}

@end
