#import "AStar.h"

@interface ANode : NSObject{
}

+(id)nodeWithX: (int)px Y:(int)py withG: (int)ng withH: (int)nh withParent: (ANode*)p;
@property int x;
@property int y;

@property int G;	//distance passed
@property int H;	//distance maybe

@property(assign) ANode* parent;

@property(readonly) int F;
@end

@implementation ANode

@synthesize x, y, H, G, parent;

+(id)nodeWithX: (int)px Y:(int)py withG: (int)ng withH: (int)nh withParent: (ANode*)p
{
    ANode* node = [[ANode alloc] init];
	node.x = px;
	node.y = py;
	node.G = ng;
    node.H = nh;
	
    node.parent = p;
    return node;
}

-(int) F
{
	return self.G + self.H;
}

-(NSString*) description 
{
    return [NSString stringWithFormat: @"ANode, x :%d, y: %d, F: %d, G: %d, H: %D", self.x, self.y, self.F, self.G, self.H];
}

@end

///////////////////////////////////////////////////////////////
/*
  O	-----------> x
  |	3	2	1
  |   \ | / 
  |	4 - + - 0
  |	  / | \
  |	5   6  7
  y\/
*/
static int s_dirOffsets[16] = { 1, 0, 1, -1, 0, -1, -1, -1, -1, 0, -1, 1, 0, 1, 1, 1};
static int s_dirDistance[8] = { 10, 14, 10, 14, 10, 14, 10, 14};

@interface AStarFinder()
- (ANode*)nearF:(NSMutableDictionary*)nodes;
	
- (int)calcMaybeFrom: (IntPoint*)pos1 to:(IntPoint*)pos2;
- (int)calcDir: (IntPoint*)posFrom to: (IntPoint*)posTo;

//- (int*)calcJPSNeighbou(IntPoint*)posFrom to:(IntPoint*)posTo c count:(int*)cnt;- (int*)calcNeighout:(IntPoint*)posFrom to:(IntPoint*)posTo 2 count:(int*)cnt;
- (id)createKeyX:(int)x Y:(int)y;
@end

@implementation AStarFinder

@synthesize maxCloseNode;

- (int*)calcJPSNeighbour:(IntPoint*)posFrom to:(IntPoint*)posTo count:(int *)cntt;
{
    return 0;
}

- (id)createKeyX:(int)x Y:(int)y
{
    return [NSNumber numberWithInt: x<< 16 | y];
}

//- (int*)calcNeight:(IntPoint*)posFrom to:(IntPoint*)posTont
//{
//    static int _dirs[8] = {0, 1, 2, 3, 4, 5, 6, 7};
//    *cnt = 8;
//    return _dirs;
//}

- (int) calcMaybeFrom: (IntPoint*)pos1 to:(IntPoint*)pos2
{
	return (abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)) * 10; 
}

- (int)calcDir:(IntPoint*)posFrom to:(IntPoint*)posTo
{
    int dx = posFrom.x - posTo.x;
    int dy = posFrom.y - posTo.y;
    
    if (dx == 0 ) {
        if (dy > 0) return 6;
        if (dy < 0) return 2;
    } else if (dy == 0){
        if (dx > 0) return 0;
        if (dx < 0) return 4;
    } else {
        if (dx > 0 && dy > 0) return 7;
        else if(dx >0 && dy < 0) return 1;
        else if (dx < 0 && dy > 0) return 5;
        else return 3;
    }
    return 0;    
}

-(ANode*)nearF: (NSMutableDictionary*)nodes
{
    id minikey = nil;
	ANode* miniNode = nil;
    for (id key in nodes) {
        ANode* n = [nodes objectForKey:key];
		if ( !miniNode || n.F < miniNode.F) {
			miniNode = n;
            minikey = key;
        }
	}
	
    if (minikey)
        [nodes removeObjectForKey: minikey];
    
	return miniNode;
}

-(id) initWithCapacity: (int)cap {
	AStarFinder* finder = [[AStarFinder alloc] init];
	finder.maxCloseNode = cap;
	return finder;
}

-(NSArray*) find:(id<BlockService>)blocks from:(IntPoint*)posFrom to:(IntPoint*)posTo withTracer:(FindingTracer *)tracer
{
    NSMutableDictionary* openList = [NSMutableDictionary dictionaryWithCapacity: 30];
	NSMutableDictionary* closeList = [NSMutableDictionary dictionaryWithCapacity:100];
	
	ANode* startNode = [ANode nodeWithX: posFrom.x Y: posFrom.y withG: 0 withH: 0 withParent: nil];
    [openList setObject:startNode forKey: [self createKeyX:startNode.x Y:startNode.y]];
	
	ANode* lastNode = nil;
	while (!lastNode && closeList.count < maxCloseNode) {
        //NSLog(@"openList %@", openList);
		ANode* nearNode = [self nearF: openList];

        //add to tracer for tool
        [tracer addFoot:[IntPoint pointWithX:nearNode.x withY:nearNode.y] withAcition:ActionClose];
        [closeList setObject: nearNode forKey: [NSNumber numberWithInt: nearNode.x << 16 | nearNode.y]];
		for (int i = 0; i < 8; ++i) {
			int x = nearNode.x + s_dirOffsets[i * 2];
			int y = nearNode.y + s_dirOffsets[i * 2 +1];
            
            if ( x < 0 || x >= blocks.width || y < 0 || y >= blocks.height || [blocks isBlock: x : y] || 
                [closeList objectForKey:[NSNumber numberWithUnsignedInt: (x << 16 | y)]]) 
            {
                continue;
            }
            
			if (x == posTo.x && y == posTo.y) {
				lastNode= [ANode nodeWithX: x Y:y withG: 0 withH: 0 withParent: nearNode];
                [tracer addFoot:[IntPoint pointWithX:x withY:y] withAcition:ActionOpen];
				break;
			} else {                
                int newH = [self calcMaybeFrom: [IntPoint pointWithX: x withY: y] to: posTo];
                int dis = s_dirDistance[i];                
                ANode* newNode = [ANode nodeWithX: x Y: y withG: nearNode.G + dis withH: newH withParent:nearNode];	
                
                id key = [self createKeyX:x Y:y];    
                ANode* openedNode = [openList objectForKey:key]; 
                if (!openedNode ) {
                    [openList setObject: newNode forKey:key];
                    // add to tracer for tool
                    [tracer addFoot: [IntPoint pointWithX:x withY:y] withAcition: ActionOpen];
                } else if (newNode.G < openedNode.G) {
                    openedNode.parent = newNode.parent;
                    openedNode.G = newNode.G;
                }
			}
		}
	}	
	
	if (lastNode) {
		NSMutableArray* path = [NSMutableArray arrayWithCapacity: 50];
		//extract path from close nodes
		do  {
			[path addObject: [IntPoint pointWithX: lastNode.x withY: lastNode.y]];	
			lastNode = lastNode.parent;
		} while(lastNode);
		
        //NSLog(@"reverse path: %@", path);
		//reverse
		for (int i = 0; i < path.count/2; ++i) {
			int j = path.count - i - 1;
			id point = [path objectAtIndex: i];
			[path replaceObjectAtIndex: i withObject: [path objectAtIndex: j]];
			[path replaceObjectAtIndex: j withObject: point];
		}
        
        //add to tracer, reverse path
        tracer.path = [path retain];		
		return [path retain];
	} else {
		return nil;
    }
}
    
@end
