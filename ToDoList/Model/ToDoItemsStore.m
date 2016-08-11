//
//  ToDoItemsStore.m
//  ToDoList
//
//  Created by goit on 8/10/16.
//  Copyright © 2016 goit. All rights reserved.
//

#import "ToDoItemsStore.h"

@interface ToDoItemsStore()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ToDoItemsStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void) addItem:(ToDoItem *) item {
    [_items addObject:item];
}

- (void) removeItem:(ToDoItem *) item {
    [_items removeObject:item];
}

- (NSArray <ToDoItem*> *) items {
    return [NSArray arrayWithArray:_items];
}


- (NSUInteger) itemsCount {
    return [_items count];
}

@end
