//
//  SSItemManager.h
//  SimpleSimulator
//
//  Created by hanxiaoming on 17/2/9.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSSimulator.h"

@interface SSItemManager : NSObject

+ (NSArray<SSSimulator *> *)allSimulators;

#pragma mark - 

+ (NSString *)simulatorHomePath;

+ (void)openFileAtPath:(NSString *)path;

@end
