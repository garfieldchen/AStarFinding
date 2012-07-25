//
//  AStarFindingAppDelegate.h
//  AStarFinding
//
//  Created by Mahmood1 on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringBlockService.h"

#import "TileView.h"
#import "FindingTracer.h"

@interface AStarFindingAppDelegate : NSObject <UIApplicationDelegate, TileViewFindingDelegate> {

    UITextField *_widthField;
    UITextField *_heightField;
    UITextField *_blockField;
    StringBlockService* _blockService;
    FindingTracer* _tracer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) TileView* tileView;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UITextField *widthField;
@property (nonatomic, retain) IBOutlet UITextField *heightField;
@property (nonatomic, retain) IBOutlet UITextField *blockField;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (IBAction)onCreateBlock:(id)sender;
- (IBAction)onCreateMap:(id)sender;
- (IBAction)onClearBlock:(id)sender;
@end
