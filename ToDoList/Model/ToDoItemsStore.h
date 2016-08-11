//
//  ToDoItemsStore.h
//  ToDoList
//
//  Created by goit on 8/10/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem.h"



@protocol ToDoItemStoreProtocol <NSObject>

- (void) addItem:(ToDoItem *) item;
- (void) removeItem:(ToDoItem *) item;
- (NSArray <ToDoItem*> *) items;
- (NSUInteger) itemsCount;

@end

@interface ToDoItemsStore : NSObject <ToDoItemStoreProtocol>

@end

