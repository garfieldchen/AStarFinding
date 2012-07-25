//
//  TileView.m
//  AStarFinding
//
//  Created by Mahmood1 on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TileView.h"

@interface TileView()
-(void) stepPath: (NSTimer*)timer;
@end

@implementation TileView

@synthesize blockService;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.opaque =  NO;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (float)tileWidth {
    return [self bounds].size.width / self.blockService.width;
}

- (float)tileHeight 
{
    return [self bounds].size.height / self.blockService.height;    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    
    CGContextSetLineWidth(context, 15);
    CGContextAddRect(context, [self bounds]);
    
    CGContextStrokePath(context);   
    
    //grid
    if (self.blockService) {           
        CGContextSetLineWidth(context, 1);
        for (int i = 1; i < self.blockService.width; ++i) {        
            CGContextMoveToPoint(context, i * self.tileWidth, self.bounds.origin.y);
            CGContextAddLineToPoint(context, i * self.tileWidth, self.bounds.origin.y + self.bounds.size.height);
        }
        
        for (int i = 1; i < self.blockService.height; ++i) {
            CGContextMoveToPoint(context, self.bounds.origin.x, i * self.tileHeight);
            CGContextAddLineToPoint(context, self.bounds.origin.x + self.bounds.size.width, i * self.tileHeight);
        }
        CGContextStrokePath(context);
        
        [[UIColor blackColor] setFill];

        for (int i = 0; i < self.blockService.width; ++i) {
            for (int j = 0; j < self.blockService.height; ++j) {
                if ([self.blockService isBlock:i :j]) {
                    CGRect blockRect = CGRectMake(i * self.tileWidth, 
                                                  j * self.tileHeight, 
                                                  self.tileWidth, 
                                                  self.tileHeight);
                    CGContextFillRect(context, blockRect);
                }
            }
        }
        
        CGContextFillPath(context);
    } 
    
    // arrow
    if (_touching) {
        [[UIColor greenColor] setFill];        
        
        CGContextAddArc(context, _arrowFrom.x, _arrowFrom.y, 5, 0, M_2_PI, 1);
        CGContextFillPath(context);
        
        [[UIColor greenColor] setStroke];
        CGContextSetLineWidth(context, 2);
        
        CGContextMoveToPoint(context, _arrowFrom.x, _arrowFrom.y);
        CGContextAddLineToPoint(context, _arrowTo.x, _arrowTo.y);
        CGContextStrokePath(context);
    }
    
    //two end point    
    if (_tracer.path.count > 2) {
        [[UIColor yellowColor] setFill];
        IntPoint* pos = [_tracer.path objectAtIndex:0];
        CGContextAddArc(context, (pos.x + 0.5f) * self.tileWidth, (pos.y + 0.5f) * self.tileHeight, 20, 0, M_2_PI, 1);
        CGContextFillPath(context);
        
        [[UIColor greenColor] setFill];
        //IntPoint* 
        pos = [_tracer.path objectAtIndex: _tracer.path.count - 1];
        CGContextAddArc(context, (pos.x + 0.5f) * self.tileWidth, (pos.y + 0.5f) * self.tileHeight, 20, 0, M_2_PI, 1);
        CGContextFillPath(context);
    }
    
    //searching
    for (NSUInteger i = 0; i < _tracer.footprints.count && i < _pathIndex; ++i) {
        FootPoint* fp = [_tracer.footprints objectAtIndex:i];
        
        UIColor* color = nil;
        if (fp.action == ActionOpen )
            color = [UIColor orangeColor];
        else
            color = [UIColor purpleColor];
        
        [color setFill];
        CGContextAddArc(context, (fp.x + 0.5f) * self.tileWidth, (fp.y + 0.5f) * self.tileHeight, 14, 0, M_2_PI, 1);
        CGContextFillPath(context);
    }
    
    // the path
    [[UIColor blueColor] setFill];    
    const float xoffset = self.tileWidth * 0.15;
    const float yoffset = self.tileHeight * 0.15;   
    for (int i = 0; i < _pathIndex - (int)_tracer.footprints.count && i < _tracer.path.count; ++i) {
        IntPoint* pos = [_tracer.path objectAtIndex:i];
        CGContextAddRect(context, CGRectMake(pos.x * self.tileWidth + xoffset, 
                                             pos.y * self.tileHeight + xoffset, 
                                             self.tileWidth - yoffset * 2, 
                                             self.tileHeight - yoffset * 2));
    }
    CGContextFillPath(context);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches) {
        _arrowFrom = [touch locationInView: self];
        break;
    }
    
    _touching = YES;
    _arrowTo = _arrowFrom;
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches) {
        _arrowTo = [touch locationInView: self];
        break;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touching = NO;  
    
    if (self.blockService) 
    {        
        IntPoint* posFrom = [IntPoint pointWithX: _arrowFrom.x / self.tileWidth withY: _arrowFrom.y / self.tileHeight];
        IntPoint* posTo = [IntPoint pointWithX: _arrowTo.x / self.tileWidth withY: _arrowTo.y / self.tileHeight];
        
        [_findingDelegate tileView:self arrowFrom:posFrom arrowTo:posTo];    
    }
}

-(void) setDelegate:(id<TileViewFindingDelegate>) delegate 
{
    _findingDelegate = delegate;
}

-(void) stepPath: (NSTimer*)timer
{
    if (_pathIndex < _tracer.path.count + _tracer.footprints.count) {
        ++_pathIndex;
        [self setNeedsDisplay];
    } else {
        [timer invalidate];
    }
}

- (void)drawTracer: (FindingTracer*)tracer
{
    _pathIndex = 0;
    _tracer = [tracer retain];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(stepPath:) userInfo:nil repeats:YES];
    
}
@end
