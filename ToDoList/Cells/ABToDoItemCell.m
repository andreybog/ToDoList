//
//  ABToDoItemCell.m
//  ToDoList
//
//  Created by Andrey Bogushev on 8/14/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import "ABToDoItemCell.h"

@interface ABToDoItemCell() <UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UIButton *priorityButton;
@property (strong, nonatomic) NSString *currentTitle;
@property (strong, nonatomic) NSString *currentSummary;

@end

@implementation ABToDoItemCell

- (void) awakeFromNib {
    [super awakeFromNib];
}

- (void) initialSetup {
    self.currentTitle = self.titleTextField.text;
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    self.myContentView.backgroundColor = backgroundColor;
}

- (void) setPriorityButtonImage:(UIImage *) image {
    CGFloat inset = (int)(CGRectGetHeight(self.priorityButton.bounds) * 0.2);
    self.priorityButton.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset);
    [self.priorityButton setImage:image forState:UIControlStateNormal];
}

- (void) setEnabled:(BOOL) enabled {
    self.titleTextField.enabled = enabled;
    self.priorityButton.enabled = enabled;
    self.summaryTextField.enabled = enabled;
}

#pragma mark - Actions

- (IBAction)actionDidPressButton:(UIButton *)sender {
    if ( [sender isEqual:self.priorityButton] ) {
        [self.delegate toDoItemCellDidPressPriorityButton:self];
    }
}


- (IBAction)actionTextFieldEditingDidBegin:(UITextField *)sender {
    [self.delegate toDoItemCellDidBeginEditing:self];
    
    if ( [sender isEqual:self.titleTextField] ) {
        self.currentTitle = sender.text;
    } else if ( [sender isEqual:self.summaryTextField] ) {
        self.currentSummary = sender.text;
    }
}

- (IBAction)actionTextFieldEditingDidEnd:(UITextField *)sender {
    if ( [sender isEqual:self.titleTextField] ) {
        if ( ![self.currentTitle isEqualToString:sender.text] || !sender.text.length ) {
            [self.delegate toDoItemCell:self didChangeTitle:sender.text];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ( ![self.summaryTextField isFirstResponder] ) {
                [self.delegate toDoItemCellDidEndEditing:self];
            }
        });
        
    } else if ( [sender isEqual:self.summaryTextField] ) {
        if ( ![self.currentSummary isEqualToString:sender.text] ) {
            [self.delegate toDoItemCell:self didChangeSummary:sender.text];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ( ![self.titleTextField isFirstResponder] ) {
                [self.delegate toDoItemCellDidEndEditing:self];
            }
        });
    }
}

#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
        
    if ( [textField isEqual:self.titleTextField] ) {
        [self.summaryTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
   }
    
    return YES;
}

@end
