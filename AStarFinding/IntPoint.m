//
//  IntPoint.m
//  AStarFinding
//
//  Created by Mahmood1 on 7/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IntPoint.h"


@implementation IntPoint

@synthesize x, y;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.x = self.y = 0;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

+(id) pointWithX:(int)x withY:(int)y 
{
    return [[IntPoint alloc] initWithX:x withY:y];
}

-(id) initWithX:(int)nx withY:(int)ny 
{
    if ((self = [super init])) {
        self.x = nx;
        self.y = ny;
    }
    
    return self;
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"IntPoint: %d, %d", self.x ,self.y];
}

@end
