//
//  EZDao.h
//  ezdb
//
//  Created by zzd on 16/10/11.
//  Copyright © 2016年 zzd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZDatabase;
@class EZBean;

NS_ASSUME_NONNULL_BEGIN

@protocol EZDaoProtocol <NSObject>
@optional
- (NSString *)getTableName;
- (NSString *)getPrimaryKeyName;
@end

@interface EZDao : NSObject <EZDaoProtocol>

@property (strong, nonatomic) NSString *primaryKeyName;

@property (strong, nonatomic) NSString *tableName;

@property (strong, nonatomic) EZDatabase *database;

+ (instancetype)getInstance;

- (BOOL)initWithDatabase:(EZDatabase *)database;

- (BOOL)insertOrUpdate:(EZBean *)bean;

- (BOOL)deleteAll;

- (BOOL)deleteWithIdKey:(NSString *)idKey;

- (BOOL)deleteAllWhere:(NSString *)column1
                equals:(NSString *)value1;

- (BOOL)deleteAllWhere:(NSString *)column1
                equals:(NSString *)value1
                   and:(nullable NSString *)column2
                equals:(nullable NSString *)value2;

- (BOOL)deleteAllWhere:(NSString *)whereClause;

- (BOOL)deleteAllWhere:(NSString *)whereClause withParameterDictionary:(NSDictionary *)arguments;

- (NSMutableArray<__kindof EZBean *> *)selectAll;

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)column1
                                               equals:(NSString *)value1;

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)column1
                                               equals:(NSString *)value1
                                              orderBy:(nullable NSString *)orderByColumn;

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)column1
                                               equals:(NSString *)value1
                                                  and:(nullable NSString *)column2
                                               equals:(nullable NSString *)value2;

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)column1
                                               equals:(NSString *)value1
                                                  and:(nullable NSString *)column2
                                               equals:(nullable NSString *)value2
                                              orderBy:(nullable NSString *)orderByColumn;

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)whereClause;

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)whereClause withParameterDictionary:(NSDictionary *)arguments;

- (__kindof EZBean *)selectFirst;

- (__kindof EZBean *)selectOneWithIdKey:(NSString *)idKey;

- (__kindof EZBean *)selectOneWhere:(NSString *)column1
                             equals:(NSString *)value1;

- (__kindof EZBean *)selectOneWhere:(NSString *)column1
                             equals:(NSString *)value1
                            orderBy:(nullable NSString *)orderByColumn;

- (__kindof EZBean *)selectOneWhere:(NSString *)column1
                             equals:(NSString *)value1
                                and:(nullable NSString *)column2
                             equals:(nullable NSString *)value2;

- (__kindof EZBean *)selectOneWhere:(NSString *)column1
                             equals:(NSString *)value1
                                and:(nullable NSString *)column2
                             equals:(nullable NSString *)value2
                            orderBy:(nullable NSString *)orderByColumn;

- (__kindof EZBean *)selectOneWhere:(NSString *)whereClause;

- (__kindof EZBean *)selectOneWhere:(NSString *)whereClause withParameterDictionary:(NSDictionary *)arguments;

- (NSMutableArray<__kindof EZBean *> *)executeQuery:(NSString *)sql;
- (NSMutableArray<__kindof EZBean *> *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;

- (void)updateTableAddColumn;

@end

NS_ASSUME_NONNULL_END
