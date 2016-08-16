//
//  ABToDoItemCell.h
//  ToDoList
//
//  Created by Andrey Bogushev on 8/14/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABToDoItemCellDelegate;


@interface ABToDoItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *summaryTextField;

@property (weak, nonatomic) id <ABToDoItemCellDelegate> delegate;


- (void) setPriorityButtonImage:(UIImage *) image;
- (void) setEnabled:(BOOL) enabled;
@end


@protocol ABToDoItemCellDelegate <NSObject>

- (void) toDoItemCellDidPressPriorityButton:(ABToDoItemCell *) cell;
- (void) toDoItemCell:(ABToDoItemCell *)cell didChangeTitle:(NSString *) title;
- (void) toDoItemCell:(ABToDoItemCell *)cell didChangeSummary:(NSString *) summary;
- (void) toDoItemCellDidEndEditing:(ABToDoItemCell *)cell;
- (void) toDoItemCellDidBeginEditing:(ABToDoItemCell *)cell;

@end
