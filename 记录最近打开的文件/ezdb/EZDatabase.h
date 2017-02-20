//
//  EZDatabase.h
//  ezdb
//
//  Created by zzd on 16/10/11.
//  Copyright © 2016年 zzd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EZDatabase : NSObject

+ (instancetype)databaseWithPath:(NSString *)path;
+ (instancetype)databaseWithPath:(NSString *)path key:(NSString *)key;

- (BOOL)executeUpdate:(NSString *)sql;
- (BOOL)executeUpdate:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;

- (NSMutableArray<NSDictionary *> *)executeQuery:(NSString *)sql;
- (NSMutableArray<NSDictionary *> *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;

@end

NS_ASSUME_NONNULL_END
