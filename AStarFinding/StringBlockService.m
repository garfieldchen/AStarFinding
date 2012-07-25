//
//  StringBlockService.m
//  AStarFinding
//
//  Created by Mahmood1 on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StringBlockService.h"

@implementation StringBlockService

@synthesize width, height;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWidthWidth:(int)w height:(int)h {
    if ( (self = [super init])) {
        self.width = w;
        self.height = h;
        _blocks = [[NSMutableString stringWithCapacity: w * h] retain];
        [self clearBlocks];        
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)setBlockAtX:(int)x Y:(int)y block:(BOOL)bblock
{
    int pos = y * self.width + x;
    NSString* blockChar = bblock ? @"1" : @"0";
    
    if (pos < _blocks.length)
        [_blocks replaceCharactersInRange:NSMakeRange(pos,1) withString:blockChar];        
}

-(BOOL)isBlock:(int)x :(int)y
{
    int pos = y * self.width + x;
    return pos < _blocks.length ? [_blocks characterAtIndex:pos] == '1' : YES;
}

-(void)randomBlock:(int)count {
    int rsize = MIN(count, _blocks.length);
    
    for (int i = 0; i< rsize; ++i) {
        int x = rand() /  (float)RAND_MAX * width;
        int y = rand() / (float)RAND_MAX * height;
        
        [self setBlockAtX:x Y:y block:YES];
    }
}

-(void)clearBlocks
{
    [_blocks release];
    
    _blocks = [[NSMutableString stringWithCapacity: self.width * self.height] retain];
    for (int i = 0; i < self.width * self.height; ++i)
        [_blocks appendString: @"0"];
}

//-(NSString*)description 
//{
//    //NSMutableString* des = NSMutableString stringWithFormat: "
//    return @"";
//}

@end
