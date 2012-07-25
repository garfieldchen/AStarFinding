//
//  BlockService.h
//  AStarFinding
//
//  Created by Mahmood1 on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BlockService <NSObject>

-(BOOL) isBlock:(int)x : (int)y; 
-(int) width;
-(int) height;

@end
