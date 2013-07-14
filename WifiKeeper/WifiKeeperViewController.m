//
//  WifiKeeperViewController.m
//  WifiKeeper
//
//  Created by chenjs.us on 13-5-11.
//  Copyright (c) 2013年 HelloTom. All rights reserved.
//

#import "WifiKeeperViewController.h"

@interface WifiKeeperViewController ()

@end

@implementation WifiKeeperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appDidEnterBackground
{
    NSLog(@"VC: %@", NSStringFromSelector(_cmd));
     
    [self doBackgroundTask];
}

- (void)doBackgroundTask
{
    UIApplication *app = [UIApplication sharedApplication];
    
    __block UIBackgroundTaskIdentifier taskId;
    taskId = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background task ran out of the time and was terminated.");
        [app endBackgroundTask:taskId];
        
        [self doBackgroundTask];
        //[self performSelector:@selector(doBackgroundTask) withObject:nil afterDelay:0.1f];
    }];
    
    if (taskId == UIBackgroundTaskInvalid) {
        NSLog(@"Failed to start background task!");
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Beginning background task with %f seconds remaining", app.backgroundTimeRemaining);
              
        while (app.backgroundTimeRemaining > 0) {
            NSLog(@"Doing background task with %f seconds remaining", app.backgroundTimeRemaining);
            [NSThread sleepForTimeInterval:60];
        }
        
        NSLog(@"Finishing background task with %f seconds remaining", app.backgroundTimeRemaining);
        [app endBackgroundTask:taskId];
    });
}


@end
