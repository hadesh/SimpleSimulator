//
//  AppDelegate.m
//  SimpleSimulator
//
//  Created by hanxiaoming on 17/2/9.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    if (flag) {
        return YES;
    }
    else
    {
        [[NSApplication sharedApplication].windows.firstObject makeKeyAndOrderFront:self];// Window that you want open while click on dock app icon
        return NO;
    }
}

@end
