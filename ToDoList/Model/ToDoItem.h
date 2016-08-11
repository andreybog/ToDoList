//
//  ToDoItem.h
//  ToDoList
//
//  Created by goit on 8/10/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ToDoItemPriority) {
    ToDoItemPriorityLow,
    ToDoItemPriorityDefault,
    ToDoItemPriorityHigh,
    ToDoItemPriorityUrgent
};

@interface ToDoItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *summary;
@property (assign, getter=isDone) BOOL done;
@property (assign) ToDoItemPriority priority;

@end
