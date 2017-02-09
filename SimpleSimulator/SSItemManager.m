//
//  SSItemManager.m
//  SimpleSimulator
//
//  Created by hanxiaoming on 17/2/9.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "SSItemManager.h"

static NSString * DevicePlist = @"device.plist";
static NSString * MCMMetadataIdentifier = @"MCMMetadataIdentifier";
static NSString * SimulatorPath = @"Library/Developer/CoreSimulator/Devices/";

static NSFileManager *_fileManager = nil;
static NSString *_homePath = nil;

@implementation SSItemManager

+ (NSFileManager *)fileManager{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

+ (NSString *)homePath{
    if (!_homePath) {
        _homePath = [NSHomeDirectory() stringByAppendingPathComponent:SimulatorPath];
    }
    return _homePath;
}

#pragma mark - Interface

+ (NSArray<SSSimulator *> *)allSimulators
{
    NSMutableArray *allItems = [NSMutableArray array];
    NSArray *plists = [self allDeviceInfoPlists];
    
    for (NSDictionary *dict in plists) {
        NSString *version = [[[dict valueForKeyPath:@"runtime"] componentsSeparatedByString:@"."] lastObject];
        NSString *device = [dict valueForKeyPath:@"name"];
        
        NSString *boxName = [NSString stringWithFormat:@"%@ > (%@)",device, version];
        
        SSSimulator *aSim = [[SSSimulator alloc] init];
        if ([dict valueForKeyPath:@"UDID"]) {
            aSim.udid = dict[@"UDID"];
        }
        aSim.name = boxName;
        aSim.version = version;
        aSim.device = device;
        
        aSim.devicePath = [self.homePath stringByAppendingPathComponent:aSim.udid];
        aSim.deviceDataPath = [aSim.devicePath stringByAppendingPathComponent:@"data/Containers/Data/Application"];
        aSim.deviceBundlePath = [aSim.devicePath stringByAppendingPathComponent:@"data/Containers/Bundle/Application"];
        
        
        aSim.applications = [self applicationsWithSimulator:aSim];
        
        [allItems addObject:aSim];
    }
    return allItems;
}

#pragma mark - Utility

+ (NSArray *)allDeviceInfoPlists{
    NSMutableArray *plists = [NSMutableArray array];
    if([self.fileManager fileExistsAtPath:self.homePath]){
        NSArray *files = [self.fileManager contentsOfDirectoryAtPath:self.homePath error:nil];
        
        for (NSString *filesPath in files) {
            
            NSString *devicePath =  [[self.homePath stringByAppendingPathComponent:filesPath] stringByAppendingPathComponent:DevicePlist];
            if (![self.fileManager fileExistsAtPath:devicePath]) {
                continue;
            }
            
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:devicePath];
            if (dict.allKeys.count) {
                [plists addObject:dict];
            }
        }
    }
    return plists;
}

+ (NSArray *)applicationsWithSimulator:(SSSimulator *)simulator
{
    if (simulator.deviceBundlePath.length == 0)
    {
        return nil;
    }
    
    if (![self.fileManager fileExistsAtPath:simulator.deviceBundlePath])
    {
        return nil;
    }

    NSMutableDictionary *appMapping = [NSMutableDictionary dictionary];
    NSArray *appsContents = [self.fileManager contentsOfDirectoryAtPath:simulator.deviceBundlePath error:nil];
    for (NSString *appUDID in appsContents) {
        NSString *appBunldePath = [simulator.deviceBundlePath stringByAppendingPathComponent:appUDID];
        
        NSDictionary *metaPList = [NSDictionary dictionaryWithContentsOfFile:[self metadataFilePathWithPath:appBunldePath]];
        
        SSApplication *aApp = [[SSApplication alloc] init];
        aApp.applicationBundlePath = appBunldePath;
        aApp.bundleID = [metaPList objectForKey:MCMMetadataIdentifier];
        aApp.displayName = aApp.bundleID;
        
        NSArray *arr = [self.fileManager contentsOfDirectoryAtPath:appBunldePath error:nil];
        for (NSString *str in arr) {
            if ([str hasSuffix:@".app"]) {
                aApp.displayName = [str stringByReplacingOccurrencesOfString:@".app" withString:@""];
                break;
            }
        }
        
        if (aApp.bundleID.length > 0)
        {
            [appMapping setObject:aApp forKey:aApp.bundleID];
        }
    }
    
    // get data path
    NSMutableArray *appArray = [NSMutableArray array];
    NSArray *datasContents = [self.fileManager contentsOfDirectoryAtPath:simulator.deviceDataPath error:nil];
    for (NSString *appUDID in datasContents) {
        NSString *dataPath = [simulator.deviceDataPath stringByAppendingPathComponent:appUDID];
        NSDictionary *metaPList = [NSDictionary dictionaryWithContentsOfFile:[self metadataFilePathWithPath:dataPath]];
        NSString *bundleid = [metaPList objectForKey:MCMMetadataIdentifier];
        
        SSApplication *aApp = [appMapping objectForKey:bundleid];
        if (aApp)
        {
            aApp.applicationDataPath = dataPath;
            [appArray addObject:aApp];
        }
    }
    
    return appArray;
}

+ (NSString *)metadataFilePathWithPath:(NSString *)path
{
    return [path stringByAppendingPathComponent:@".com.apple.mobile_container_manager.metadata.plist"];
}

+ (NSString *)simulatorHomePath
{
    return self.homePath;
}

+ (void)openFileAtPath:(NSString *)path
{
    if (!path.length)
    {
        return;
    }
    NSString *open = [NSString stringWithFormat:@"open %@",path];
    const char *str = [open UTF8String];
    system(str);
}

@end
