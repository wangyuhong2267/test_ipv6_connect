//
//  AppDelegate.m
//  ipv6
//
//  Created by openthread on 6/20/16.
//  Copyright © 2016 openthread. All rights reserved.
//

#import "AppDelegate.h"
#import "IPv6Tester.h"

@interface AppDelegate ()
@property (nonatomic, strong) IPv6Tester *tester;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.tester = [[IPv6Tester alloc] init];
    [self.tester performSelector:@selector(test) withObject:nil afterDelay:0.5];
    return YES;
}

@end
