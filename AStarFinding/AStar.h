#import <Foundation/Foundation.h>

#import "BlockService.h"
#import "FindingTracer.h"
#import "IntPoint.h"

typedef enum {
    ModeNormal,
    ModeJPS
}AStarMode;

@interface AStarFinder : NSObject {
    int _nearDirections[8];
    
    int* (^_getNeibourFunc)(Point*, Point*, int*);
}

@property int maxCloseNode;

-(id) initWithCapacity: (int)cap;

-(NSArray*) find: (id<BlockService>) blocks from: (IntPoint*)posFrom to: (IntPoint*)posTo withTracer: (FindingTracer*)tracer;

//- (void)setMode:(AStarMode)mode;

@end
