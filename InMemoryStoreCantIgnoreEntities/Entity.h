//
//  Entity.h
//  CoreDataFetchStringContainsButNotInSetBug
//
//  Created by dev1 on 9/19/12.
//  Copyright (c) 2012 Heath Borders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * stringAttribute;

@end
