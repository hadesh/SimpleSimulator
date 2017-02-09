//
//  SSDevice.h
//  SimpleSimulator
//
//  Created by hanxiaoming on 17/2/9.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSApplication;

@interface SSSimulator : NSObject

@property (nonatomic, copy) NSString *udid;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *device;

/// device+version
@property (nonatomic, copy) NSString *name;

/// all applications
@property (nonatomic, strong) NSArray<SSApplication *> *applications;

@property (nonatomic, copy) NSString *devicePath;
@property (nonatomic, copy) NSString *deviceDataPath;
@property (nonatomic, copy) NSString *deviceBundlePath;

@end

@interface SSApplication : NSObject

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *bundleID;

@property (nonatomic, copy) NSString *applicationDataPath;
@property (nonatomic, copy) NSString *applicationBundlePath;

@end
