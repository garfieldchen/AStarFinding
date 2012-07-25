//
//  FindingTracer.h
//  AStarFinding
//
//  Created by Mahmood1 on 7/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IntPoint.h"

typedef enum{
    ActionOpen,
    ActionClose
}AStarAction;

@interface FootPoint : IntPoint {
}
@property(nonatomic) AStarAction action;

+ (id) footWithPoint: (IntPoint*)pos withAction: (AStarAction)act;

@end

@interface FindingTracer : NSObject {
    
}

@property(nonatomic, retain) NSArray* path;
@property(nonatomic, retain) NSMutableArray* footprints;    

- (void)addFoot:(IntPoint*)pos withAcition: (AStarAction)action;
- (void)clear;
@end
