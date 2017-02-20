//
//  EZDatabase.m
//  ezdb
//
//  Created by zzd on 16/10/11.
//  Copyright © 2016年 zzd. All rights reserved.
//

#import "EZDatabase.h"

#import <FMDB.h>

@interface EZDatabase ()
@property (strong, nonatomic) FMDatabaseQueue *fmdbQueue;
@property (strong, nonatomic) FMDatabase *fmdb;
@end

@implementation EZDatabase

+ (instancetype)databaseWithPath:(NSString *)path {
    return [EZDatabase databaseWithPath:path key:@""];
}

+ (instancetype)databaseWithPath:(NSString *)path key:(NSString *)key {
    if (path.length == 0) {
        return nil;
    }

    EZDatabase *dbModel = [[EZDatabase alloc] init];
    dbModel.fmdbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    [dbModel.fmdbQueue inDatabase:^(FMDatabase *db) {
        dbModel.fmdb = db;

        if (key.length > 0) {
            [db setKey:key];
        }
    }];
    return dbModel;
}

- (BOOL)executeUpdate:(NSString *)sql {
    return [self executeUpdate:sql withParameterDictionary:@{}];
}

- (BOOL)executeUpdate:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments {
    return [self.fmdb executeUpdate:sql withParameterDictionary:arguments];
}

- (NSMutableArray<NSDictionary *> *)executeQuery:(NSString *)sql {
    return [self executeQuery:sql withParameterDictionary:@{}];
}

- (NSMutableArray<NSDictionary *> *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments {
    FMResultSet *resultSet = [self.fmdb executeQuery:sql withParameterDictionary:arguments];

    NSMutableArray *resultArray = [NSMutableArray array];

    while ([resultSet next]) {
        [resultArray addObject:[resultSet resultDictionary]];
    }

    [resultSet close];

    return resultArray;
}

@end
