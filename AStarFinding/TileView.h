//
//  TileView.h
//  AStarFinding
//
//  Created by Mahmood1 on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockService.h"
#import "IntPoint.h"
#import "FindingTracer.h"

@class TileView;

@protocol TileViewFindingDelegate
-(void) tileView: (TileView*)view arrowFrom: (IntPoint*) posFrom arrowTo: (IntPoint*) posTo; 
@end

@interface TileView : UIView {
    BOOL _touching;
    CGPoint _arrowFrom;
    CGPoint _arrowTo;
    
    int     _pathIndex;
    FindingTracer* _tracer;
    
    id<TileViewFindingDelegate> _findingDelegate;
}

@property(nonatomic, retain) id<BlockService> blockService;
@property(nonatomic, readonly) float tileWidth;
@property(nonatomic, readonly) float tileHeight;

-(void) setDelegate: (id<TileViewFindingDelegate>) delegate;

- (void)drawTracer: (FindingTracer*)tracer;
@end
