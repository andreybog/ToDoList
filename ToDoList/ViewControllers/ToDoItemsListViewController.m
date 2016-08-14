//
//  ToDoItemsListViewController.m
//  ToDoList
//
//  Created by goit on 8/10/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import "ToDoItemsListViewController.h"
#import "ToDoItemsStore.h"
#import "ABToDoItemCell.h"

@interface ToDoItemsListViewController () <UITableViewDataSource, UITableViewDelegate, ABToDoItemCellDelegate>

@property (nonatomic, strong) id <ToDoItemStoreProtocol> itemsStore;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;

@end

@implementation ToDoItemsListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemsStore = [[ToDoItemsStore alloc] init];
    
    for ( int i = 0; i < 3; i++ ) {
        [self addItemWithTitle:@"Buy" summary:@"When cost is low" priority:ToDoItemPriorityLow toItemsStore:self.itemsStore];
        [self addItemWithTitle:@"Sell" summary:@"When cost is high" priority:ToDoItemPriorityDefault toItemsStore:self.itemsStore];
        [self addItemWithTitle:@"Buy pickles" summary:@"12" priority:ToDoItemPriorityHigh toItemsStore:self.itemsStore];
        [self addItemWithTitle:@"Go to lecture" summary:@"01.12.2016" priority:ToDoItemPriorityDefault toItemsStore:self.itemsStore];
        [self addItemWithTitle:@"Do hometask or delegate it to smbd!!!" summary:@"Due Fri" priority:ToDoItemPriorityUrgent toItemsStore:self.itemsStore];
    }
    
}

#pragma mark - Actions

- (IBAction)actionDidTouchAddButton:(UIButton *)sender {
    
    [self addItemWithTitle:@"" summary:@"" priority:ToDoItemPriorityDefault toItemsStore:self.itemsStore];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths: @[ indexPath ] withRowAnimation:UITableViewRowAnimationLeft];
    
    ABToDoItemCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    
    [cell.titleTextField becomeFirstResponder];
    
    [self configureButton:sender asEnabled:NO];
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
    
    static NSString *identifier = @"ABToDoItemCell";
    
    ToDoItem  *item = [self.itemsStore.items objectAtIndex:indexPath.row];
   
    ABToDoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:item.title];
    cell.delegate = self;
    
    if ( item.isDone ) {
        cell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        cell.titleTextField.textColor = [UIColor grayColor];
        
        [title addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [title length])];
        [cell setEnabled:NO];
        [cell setPriorityButtonImage:[UIImage imageNamed:@"blankImage"]];
        
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        [title removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, [title length])];
        cell.titleTextField.textColor = [self colorForItemPriority:item.priority];
        [cell setEnabled:YES];
        [cell setPriorityButtonImage:[UIImage imageNamed:[self imageNameForItemPriority:item.priority]]];
    }
    
    cell.titleTextField.attributedText = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        
        ToDoItem *item = [self.itemsStore.items objectAtIndex:indexPath.row];
 
        [self.itemsStore removeItem:item];

        [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        NSLog(@"Unhandled editing style: %ld", editingStyle);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoItem *item = [self.itemsStore.items objectAtIndex:indexPath.row];
    
    if ( [item.title length] != 0 ) {
    
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
    [self.tableView endEditing:YES];
    
}

#pragma mark - Help functions

- (ToDoItem *) addItemWithTitle:(NSString *) title summary:(NSString *) summary
                 priority:(ToDoItemPriority) priority toItemsStore:(ToDoItemsStore *) itemsStore {
    
    ToDoItem *item = [[ToDoItem alloc] init];
    item.title = title;
    item.summary = summary;
    item.priority = priority;
    
    [itemsStore insertItem:item atIndex:0];
    
    return item;
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
            return [UIColor lightGrayColor];
        case ToDoItemPriorityDefault:
            return [UIColor blackColor];
        case ToDoItemPriorityHigh:
            return [UIColor orangeColor];
        case ToDoItemPriorityUrgent:
            return [UIColor redColor];
    }
}

- (NSString *) imageNameForItemPriority:(ToDoItemPriority) priority {
    
    switch (priority) {
        case ToDoItemPriorityLow:
            return @"exclamationGrey";
        case ToDoItemPriorityDefault:
            return @"exclamationBlack";
        case ToDoItemPriorityHigh:
            return @"exclamationOrange";
        case ToDoItemPriorityUrgent:
            return @"exclamationRed";
    }
}

- (void) increasePriorityInItem:(ToDoItem *) item {
    
    if ( item.priority == ToDoItemPriorityUrgent ) {
        item.priority = ToDoItemPriorityLow;
    } else {
        item.priority += 1;
    }
}

- (void) toDoItemCellDidPressPriorityButton:(ABToDoItemCell *) cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ToDoItem *item = [self.itemsStore.items objectAtIndex:indexPath.row];
    
    if ( [item.title length] != 0 ) {
    
        [self increasePriorityInItem:item];
        
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endEditing:YES];
    }
    
}

- (void) toDoItemCell:(ABToDoItemCell *)cell DidChangeTitle:(NSString *) title {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ToDoItem *item = [self.itemsStore.items objectAtIndex:indexPath.row];
    NSString *newTitle = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ( [newTitle length] == 0 ) {
        
        [self.itemsStore removeItem:item];
        [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationRight];
        
    } else {
        item.title = newTitle;
        
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self configureButton:self.addItemButton asEnabled:YES];
}

@end
