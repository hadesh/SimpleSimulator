//
//  SSDevice.m
//  SimpleSimulator
//
//  Created by hanxiaoming on 17/2/9.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "SSSimulator.h"

@implementation SSSimulator

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@[%d]", self.name, @(self.applications.count).intValue];
}

@end


@implementation SSApplication

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@[%@]", self.displayName, self.bundleID];
}

@end
