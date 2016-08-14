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

@end

@implementation ABToDoItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    self.myContentView.backgroundColor = backgroundColor;
}

- (void) setPriorityButtonImage:(UIImage *) image {
    [self.priorityButton setImage:image forState:UIControlStateNormal];
}

- (void) setEnabled:(BOOL) enabled {
    
    self.titleTextField.enabled = enabled;
    self.priorityButton.enabled = enabled;
    
}

#pragma mark - Actions

- (IBAction)actionDidPressButton:(UIButton *)sender {
    
    if ( sender == self.priorityButton ) {
        [self.delegate toDoItemCellDidPressPriorityButton:self];
    }
}
- (IBAction)actionTextFieldEditingDidBegin:(UITextField *)sender {
    self.currentTitle = sender.text;
}

- (IBAction)actionTextFieldEditingDidEnd:(UITextField *)sender {
    
    if ( ! [self.currentTitle isEqualToString:sender.text] || [sender.text length] == 0 ) {
        [self.delegate toDoItemCell:self DidChangeTitle:sender.text];
    }
    
}

#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
