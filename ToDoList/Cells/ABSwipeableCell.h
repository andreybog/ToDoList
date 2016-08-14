//
//  ABSwipeableCell.h
//  ToDoList
//
//  Created by Andrey Bogushev on 8/14/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABSwipeableCellDelegate <NSObject>

- (void) buttonOneActionForItemText:(NSString *) itemText;
- (void) buttonTwoActionForItemText:(NSString *) itemText;
- (void) cellDidOpen:(UITableViewCell *) cell;
- (void) cellDidClose:(UITableViewCell *) cell;

@end

@interface ABSwipeableCell : UITableViewCell

@property (strong, nonatomic) NSString *itemText;
@property (weak, nonatomic) id <ABSwipeableCellDelegate> delegate;

- (void) openCell;

@end
