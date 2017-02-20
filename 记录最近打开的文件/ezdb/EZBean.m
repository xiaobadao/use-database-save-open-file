//
//  EZBean.m
//  ezdb
//
//  Created by zzd on 16/10/11.
//  Copyright © 2016年 zzd. All rights reserved.
//

#import "EZBean.h"

#import <MJExtension.h>

#import "EZDB.h"
#import "EZDao.h"

@implementation EZBean

+ (NSArray *)ignoredPropertyNames {
    return nil;
}

+ (instancetype)createBean {
    return [[self alloc] init];
}

- (BOOL)save {
    NSString *className = NSStringFromClass([self class]);
    NSString *daoName = [className stringByReplacingOccurrencesOfString:EZ_SQLITE_BEAN withString:EZ_SQLITE_DAO];
    return [[NSClassFromString(daoName) getInstance] insertOrUpdate:self];
}

- (BOOL)del {
    NSString *className = NSStringFromClass([self class]);
    NSString *daoName = [className stringByReplacingOccurrencesOfString:EZ_SQLITE_BEAN withString:EZ_SQLITE_DAO];
    [[NSNotificationCenter defaultCenter] postNotificationName:EZExecuteUpdateNotification object:self];

    return [[NSClassFromString(daoName) getInstance] deleteWithIdKey:self.idKey];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    NSString *className = NSStringFromClass([self class]);
    NSString *daoName = [className stringByReplacingOccurrencesOfString:EZ_SQLITE_BEAN withString:EZ_SQLITE_DAO];
    return @{ @"idKey" : ((EZDao *) [NSClassFromString(daoName) getInstance]).primaryKeyName };
}

MJLogAllIvars

    @end
