//
//  IntPoint.h
//  AStarFinding
//
//  Created by Mahmood1 on 7/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IntPoint : NSObject {
    
}

@property int x;
@property int y;

+(id)pointWithX: (int)x withY: (int)y;
-(id)initWithX: (int)x withY: (int)y;
@end
