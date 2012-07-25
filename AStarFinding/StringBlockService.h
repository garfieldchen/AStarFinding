//
//  StringBlockService.h
//  AStarFinding
//
//  Created by Mahmood1 on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockService.h"

@interface StringBlockService : NSObject<BlockService> {
    NSMutableString* _blocks;
    
}
@property int width;
@property int height;

-(id)initWidthWidth: (int)w height: (int)h;

-(void)setBlockAtX: (int)x Y: (int)y block: (BOOL) bblock;

-(void)randomBlock: (int)count;

-(void)clearBlocks;
@end
