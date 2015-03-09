//
//  BackgroundTaskManager.m
//
//  Created by Puru Shukla on 20/02/13.
//  Copyright (c) 2013 Puru Shukla. All rights reserved.
//

#import "BackgroundTaskManager.h"

@interface BackgroundTaskManager()
@property (nonatomic, strong)NSMutableArray* bgTaskIdList;
@property (assign) UIBackgroundTaskIdentifier masterTaskId;
@end

@implementation BackgroundTaskManager

+(instancetype)sharedBackgroundTaskManager{
    static BackgroundTaskManager* sharedBGTaskManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBGTaskManager = [[BackgroundTaskManager alloc] init];
    });
    
    return sharedBGTaskManager;
}

-(id)init{
    self = [super init];
    if(self){
        _bgTaskIdList = [NSMutableArray array];
        _masterTaskId = UIBackgroundTaskInvalid;
    }
    
    return self;
}

-(UIBackgroundTaskIdentifier)beginNewBackgroundTask
{
    UIApplication* application = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier bgTaskId = UIBackgroundTaskInvalid;
    if([application respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)]){
        bgTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"background task %lu expired", (unsigned long)bgTaskId);
            
            [self.bgTaskIdList removeObject:@(bgTaskId)];
            [application endBackgroundTask:bgTaskId];
            bgTaskId = UIBackgroundTaskInvalid;
            
        }];
        if ( self.masterTaskId == UIBackgroundTaskInvalid )
        {
            self.masterTaskId = bgTaskId;
            NSLog(@"started master task %lu", (unsigned long)self.masterTaskId);
        }
        else
        {
            //add this id to our list
            NSLog(@"started background task %lu", (unsigned long)bgTaskId);
            [self.bgTaskIdList addObject:@(bgTaskId)];
            [self endBackgroundTasks];
        }
    }
    
    return bgTaskId;
}

-(void)endBackgroundTasks
{
    [self drainBGTaskList:NO];
}

-(void)endAllBackgroundTasks
{
    [self drainBGTaskList:YES];
}

-(void)drainBGTaskList:(BOOL)all
{
    //mark end of each of our background task
    UIApplication* application = [UIApplication sharedApplication];
    if([application respondsToSelector:@selector(endBackgroundTask:)]){
        NSUInteger count=self.bgTaskIdList.count;
        for ( NSUInteger i=(all?0:1); i<count; i++ )
        {
            UIBackgroundTaskIdentifier bgTaskId = [[self.bgTaskIdList objectAtIndex:0] integerValue];
            NSLog(@"ending background task with id -%lu", (unsigned long)bgTaskId);
            [application endBackgroundTask:bgTaskId];
            [self.bgTaskIdList removeObjectAtIndex:0];
        }
        if ( self.bgTaskIdList.count > 0 )
        {
            NSLog(@"kept background task id %@", [self.bgTaskIdList objectAtIndex:0]);
        }
        if ( all )
        {
            NSLog(@"no more background tasks running");
            [application endBackgroundTask:self.masterTaskId];
            self.masterTaskId = UIBackgroundTaskInvalid;
        }
        else
        {
            NSLog(@"kept master background task id %lu", (unsigned long)self.masterTaskId);
        }
    }
}


@end
