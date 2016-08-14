//
//  ABSwipeableCell.m
//  ToDoList
//
//  Created by Andrey Bogushev on 8/14/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import "ABSwipeableCell.h"

static CGFloat const kBounceValue = 20.0f;

@interface ABSwipeableCell() <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UILabel *myTextLabel;

@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (assign) CGPoint panStartPoint;
@property (assign) CGFloat startingRightLayoutConstarintConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

@end

@implementation ABSwipeableCell

#pragma mark - Properties

- (void) setItemText:(NSString *)itemText {
    _itemText = itemText;
    
    self.myTextLabel.text = _itemText;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    
    [self.myContentView addGestureRecognizer:self.panRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Actions

- (IBAction)actionButtonClicked:(UIButton *)sender {
    
    if ( sender == self.button1 ) {
        
        [self.delegate buttonOneActionForItemText:self.itemText];
    } else if ( sender == self.button2 ) {
        [self.delegate buttonTwoActionForItemText:self.itemText];
    }
}

- (void) panThisCell: (UIPanGestureRecognizer *) recognizer {
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.contentView];
            self.startingRightLayoutConstarintConstant = self.contentViewRightConstraint.constant;
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.contentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            
            BOOL paningLeft = NO;
            
            if ( currentPoint.x < self.panStartPoint.x ) {
                paningLeft = YES;
            }
            
            if ( self.startingRightLayoutConstarintConstant == 0 ) {
                // the cell was closed and is now opening
                if ( ! paningLeft ) {
                    CGFloat constant = MAX(-deltaX, 0);
                    
                    if ( constant == 0 ) {
                        [self resetConstraintsConstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]);
                    
                    if ( constant == [self buttonTotalWidth] ) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            } else {
                // The cell was at least partially open.
                
                CGFloat adjustment = self.startingRightLayoutConstarintConstant - deltaX;
                
                if ( ! paningLeft ) {
                    CGFloat constant = MAX(adjustment, 0);
                    
                    if ( constant == 0 ) {
                        [self resetConstraintsConstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                    
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]);
                    
                    if ( constant == [self buttonTotalWidth] ) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }
            
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant;
        }
            break;
        case UIGestureRecognizerStateEnded:
            
            if ( self.startingRightLayoutConstarintConstant == 0 ) {
                // cell was opening
                
                CGFloat halfOfButtonOne = CGRectGetWidth(self.button1.frame) / 2;
                
                if ( self.contentViewRightConstraint.constant >= halfOfButtonOne ) {
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    [self resetConstraintsConstantsToZero:YES notifyDelegateDidClose:YES];
                }
            } else {
                // cell was closing
                
                CGFloat buttonOneAndHalfOfButton2 = CGRectGetWidth(self.button1.frame) + CGRectGetWidth(self.button2.frame) / 2;
                
                if ( self.contentViewRightConstraint.constant >= buttonOneAndHalfOfButton2 ) {
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    [self resetConstraintsConstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            
            break;
        case UIGestureRecognizerStateCancelled:
            
            if ( self.startingRightLayoutConstarintConstant == 0 ) {
                [self resetConstraintsConstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - Public functions

- (void) openCell {
    [self setConstraintsToShowAllButtons:NO notifyDelegateDidOpen:NO];
}

#pragma mark - Help functions

- (void) updateConstraintsIfNeeded:(BOOL) animated completion:(void (^)(BOOL finished)) completion {
    float duration = 0.0;
    
    if ( animated ) {
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self layoutIfNeeded];
                     } completion:completion];
    
}

- (CGFloat) buttonTotalWidth {
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.button2.frame);
}

- (void) resetConstraintsConstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL) notifyDelegate {
    
    if ( notifyDelegate ) {
        [self.delegate cellDidClose:self];
    }
 
    if ( self.startingRightLayoutConstarintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0 ) {
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstarintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void) setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL) notifyDelegate {
    
    if ( notifyDelegate ) {
        [self.delegate cellDidOpen:self];
    }
    
    if ( self.startingRightLayoutConstarintConstant == [self buttonTotalWidth] &&
        self.contentViewRightConstraint.constant == [self buttonTotalWidth] ) {
        return;
    }
    
    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        
        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
        self.contentViewLeftConstraint.constant = - self.contentViewRightConstraint.constant;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstarintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
    
    
}

- (void) prepareForReuse {
    [super prepareForReuse];
    
    [self resetConstraintsConstantsToZero:NO notifyDelegateDidClose:NO];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}



@end
