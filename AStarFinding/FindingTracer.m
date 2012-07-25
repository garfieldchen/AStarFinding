//
//  FindingTracer.m
//  AStarFinding
//
//  Created by Mahmood1 on 7/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FindingTracer.h"

@implementation FootPoint
@synthesize action;

+ (id)footWithPoint:(IntPoint *)pos withAction:(AStarAction)act {
    FootPoint* foot = [[FootPoint alloc] init];
    foot.x = pos.x;
    foot.y = pos.y;
    foot.action = act;
    
    return foot;
}

@end

////////////////////////////
@implementation FindingTracer

@synthesize path, footprints;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.footprints = [[NSMutableArray arrayWithCapacity: 50] retain];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) addFoot:(IntPoint *)pos withAcition:(AStarAction)action
{
    [self.footprints addObject:[FootPoint footWithPoint:pos withAction:action]];
}

- (void)clear
{
    [self.footprints removeAllObjects];
    [self.path release];
    self.path = nil;
}

@end
