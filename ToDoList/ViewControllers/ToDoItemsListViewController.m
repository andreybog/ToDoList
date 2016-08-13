//
//  ToDoItemsListViewController.m
//  ToDoList
//
//  Created by goit on 8/10/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import "ToDoItemsListViewController.h"
#import "ToDoItemsStore.h"

@interface ToDoItemsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id <ToDoItemStoreProtocol> itemsStore;
@property (weak, nonatomic) IBOutlet UITextField *summaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityControl;

@end

@implementation ToDoItemsListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemsStore = [[ToDoItemsStore alloc] init];
    
    [self addItemWithTitle:@"Buy" summary:@"When cost is low" priority:ToDoItemPriorityLow toItemsStore:self.itemsStore];
    [self addItemWithTitle:@"Sell" summary:@"When cost is high" priority:ToDoItemPriorityDefault toItemsStore:self.itemsStore];
    [self addItemWithTitle:@"Buy pickles" summary:@"12" priority:ToDoItemPriorityHigh toItemsStore:self.itemsStore];
    [self addItemWithTitle:@"Go to lecture" summary:@"01.12.2016" priority:ToDoItemPriorityDefault toItemsStore:self.itemsStore];
    [self addItemWithTitle:@"Do hometask!!!" summary:@"Due Fri" priority:ToDoItemPriorityUrgent toItemsStore:self.itemsStore];
    
}

#pragma mark - Actions

- (IBAction)actionDidTouchAddButton:(UIButton *)sender {
    
    NSString *title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ( [title length] > 0 ) {
        
        NSString *summary = [self.summaryTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        ToDoItemPriority priority = [self.priorityControl selectedSegmentIndex];
        
        [self addItemWithTitle:title summary:summary priority:priority toItemsStore:self.itemsStore];
        
        NSUInteger newElementIndex = [self.itemsStore itemsCount]-1;
        NSIndexPath *newElementIndexPath = [NSIndexPath indexPathForRow:newElementIndex inSection:0];
        
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
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if ( ! cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = item.title;
    cell.textLabel.textColor = [self colorForItemPriority:item.priority];
    cell.detailTextLabel.text = item.summary;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.accessoryType = item.isDone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.backgroundColor = item.isDone ? [UIColor colorWithWhite:0.8 alpha:1.0] : [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        
        ToDoItem *item = [self.itemsStore.items objectAtIndex:indexPath.row];
        
        [self.itemsStore removeItem:item];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
    }
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
    // some comments
    // comments from new branch
}

#pragma mark - Help functions

- (void) addItemWithTitle:(NSString *) title summary:(NSString *) summary
                 priority:(ToDoItemPriority) priority toItemsStore:(ToDoItemsStore *) itemsStore {
    
    ToDoItem *item = [[ToDoItem alloc] init];
    item.title = title;
    item.summary = summary;
    item.priority = priority;
    
    [itemsStore addItem:item];
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

@end
