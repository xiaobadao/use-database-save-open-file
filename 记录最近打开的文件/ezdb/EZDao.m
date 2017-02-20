//
//  EZDao.m
//  ezdb
//
//  Created by zzd on 16/10/11.
//  Copyright © 2016年 zzd. All rights reserved.
//

#import "EZDao.h"

#import <MJExtension.h>
#import <UIKit/UIKit.h>

#import "EZBean.h"
#import "EZDB.h"
#import "EZDatabase.h"

@interface EZDao ()
@property (strong, nonatomic) NSString *className;
@property (strong, nonatomic) NSString *beanName;
@property (strong, nonatomic) NSArray<NSArray *> *propertyArray;
@property (strong, nonatomic) NSString *createTableSql;
@property (strong, nonatomic) NSString *insertSql;
@property (strong, nonatomic) NSString *updateSql;
@property (strong, nonatomic) NSString *deleteSql;

@property (assign, nonatomic) NSTimeInterval lastTime;
@end

@implementation EZDao

+ (instancetype)getInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)className {
    if (!_className) {
        _className = NSStringFromClass([self class]);
    }
    return _className;
}

- (NSString *)beanName {
    if (!_beanName) {
        _beanName = [self.className stringByReplacingOccurrencesOfString:EZ_SQLITE_DAO withString:EZ_SQLITE_BEAN];
    }
    return _beanName;
}

- (NSString *)tableName {
    if (!_tableName) {
        if ([self respondsToSelector:@selector(getTableName)]) {
            _tableName = [self getTableName];
        } else {
            _tableName = [self.className stringByReplacingOccurrencesOfString:EZ_SQLITE_DAO withString:@""];
        }
    }
    return _tableName;
}

- (NSString *)primaryKeyName {
    if (!_primaryKeyName) {
        if ([self respondsToSelector:@selector(getPrimaryKeyName)]) {
            _primaryKeyName = [self getPrimaryKeyName];
        } else {
            _primaryKeyName = [self.className stringByReplacingOccurrencesOfString:EZ_SQLITE_DAO withString:EZ_SQLITE_ID];

            NSString *prefix = [_primaryKeyName substringToIndex:1].lowercaseString;
            NSString *suffix = [_primaryKeyName substringFromIndex:1];

            _primaryKeyName = [prefix stringByAppendingString:suffix];
        }
    }
    return _primaryKeyName;
}

- (NSArray *)propertyArray {
    if (!_propertyArray) {
        NSArray *ignoredArray = [NSClassFromString(self.beanName) ignoredPropertyNames];

        NSMutableArray *array = [NSMutableArray array];

        [NSClassFromString(self.beanName) mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
            NSString *name = property.name;
            if (![ignoredArray containsObject:name]) {
                NSString *typeCode = property.type.code;
                NSString *type = @"";

                if ([typeCode isEqualToString:@"NSNumber"]) {
                    type = EZ_SQLITE_REAL;
                } else if ([typeCode isEqualToString:@"NSString"]) {
                    type = EZ_SQLITE_TEXT;
                } else if ([typeCode isEqualToString:@"NSData"]) {
                    type = EZ_SQLITE_BLOB;
                }

                if (![name isEqualToString:EZ_SQLITE_DESCRIPTION] &&
                    ![name isEqualToString:EZ_SQLITE_DEBUGDESCRIPTION] &&
                    ![name isEqualToString:EZ_SQLITE_IDKEY] &&
                    name.length > 0 &&
                    type.length > 0) {
                    [array addObject:@[ name, type ]];
                }
            }
        }];

        _propertyArray = array;
    }
    return _propertyArray;
}

- (NSString *)createTableSql {
    if (!_createTableSql) {
        NSString *tableName = self.tableName;
        NSString *primaryKeyName = self.primaryKeyName;
        if (tableName.length == 0 || primaryKeyName.length == 0) {
            return nil;
        }

        NSMutableString *sql = [NSMutableString string];
        [sql appendFormat:@"CREATE TABLE IF NOT EXISTS \"%@\" ( ", tableName];
        [sql appendFormat:@"\"%@\" %@ PRIMARY KEY NOT NULL", primaryKeyName, EZ_SQLITE_TEXT];
        [self.propertyArray enumerateObjectsUsingBlock:^(NSArray *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *name = obj[0];
            NSString *type = obj[1];
            [sql appendFormat:@", \"%@\" %@", name, type];
        }];
        [sql appendString:@" )"];
        _createTableSql = sql;
    }
    return _createTableSql;
}

- (NSString *)insertSql {
    if (!_insertSql) {
        NSString *tableName = self.tableName;
        NSString *primaryKeyName = self.primaryKeyName;
        if (tableName.length == 0 || primaryKeyName.length == 0) {
            return nil;
        }

        NSMutableString *insertSql = [NSMutableString string];
        [insertSql appendFormat:@"INSERT INTO \"%@\" ( ", tableName];
        [insertSql appendFormat:@"\"%@\"", primaryKeyName];

        NSMutableString *valuesSql = [NSMutableString string];
        [valuesSql appendString:@"VALUES ( "];
        [valuesSql appendFormat:@":%@", primaryKeyName];

        [self.propertyArray enumerateObjectsUsingBlock:^(NSArray *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *name = obj[0];

            [insertSql appendFormat:@", \"%@\"", name];

            [valuesSql appendFormat:@", :%@", name];
        }];

        _insertSql = [NSString stringWithFormat:@"%@ ) %@ )", insertSql, valuesSql];
    }
    return _insertSql;
}

- (NSString *)updateSql {
    if (!_updateSql) {
        NSString *tableName = self.tableName;
        NSString *primaryKeyName = self.primaryKeyName;
        if (tableName.length == 0 || primaryKeyName.length == 0) {
            return nil;
        }

        NSMutableString *sql = [NSMutableString string];
        [sql appendFormat:@"UPDATE \"%@\" SET ", tableName];

        [self.propertyArray enumerateObjectsUsingBlock:^(NSArray *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *name = obj[0];
            [sql appendFormat:@"\"%@\" = :%@", name, name];

            if (idx != self.propertyArray.count - 1) {
                [sql appendString:@", "];
            }
        }];

        [sql appendFormat:@" WHERE \"%@\" = :%@", primaryKeyName, primaryKeyName];

        _updateSql = sql;
    }
    return _updateSql;
}

- (NSString *)deleteSql {
    if (!_deleteSql) {
        NSString *tableName = self.tableName;
        NSString *primaryKeyName = self.primaryKeyName;
        if (tableName.length == 0 || primaryKeyName.length == 0) {
            return nil;
        }

        NSMutableString *sql = [NSMutableString string];
        [sql appendFormat:@"DELETE FROM \"%@\" ", tableName];
        [sql appendFormat:@"WHERE \"%@\" = :%@", primaryKeyName, primaryKeyName];

        _deleteSql = sql;
    }
    return _deleteSql;
}

- (NSString *)getNextIdKey {
    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;

    while (self.lastTime == now) {
        now = [NSDate date].timeIntervalSince1970;
    }

    return [NSString stringWithFormat:@"%@-%.6f", uuid, now];
}

- (BOOL)initWithDatabase:(EZDatabase *)database {
    self.database = database;
    return [self.database executeUpdate:self.createTableSql];
}

- (BOOL)insertOrUpdate:(EZBean *)bean {
    NSString *now = [NSString stringWithFormat:@"%lld", (long long) ([NSDate date].timeIntervalSince1970 * 1000)];

    bean.updateDate = now;
    NSString *sql = nil;

    if (bean.idKey.length == 0) {
        bean.idKey = [self getNextIdKey];
        bean.createDate = now;
        sql = self.insertSql;
    } else {
        sql = self.updateSql;
    }

    NSMutableDictionary *arguments = [bean mj_keyValues];

    [self.propertyArray enumerateObjectsUsingBlock:^(NSArray *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *name = obj[0];

        if (!arguments[name]) {
            arguments[name] = [NSNull null];
        }
    }];

    BOOL result = [self.database executeUpdate:sql withParameterDictionary:arguments];

    [[NSNotificationCenter defaultCenter] postNotificationName:EZExecuteUpdateNotification object:bean];

    return result;
}

- (BOOL)deleteAll {
    return [self deleteAllWhere:@""];
}

- (BOOL)deleteWithIdKey:(NSString *)idKey {
    NSDictionary *arguments = @{self.primaryKeyName : idKey};
    BOOL result = [self.database executeUpdate:self.deleteSql withParameterDictionary:arguments];

    return result;
}

- (BOOL)deleteAllWhere:(NSString *)column1
                equals:(NSString *)value1 {
    return [self deleteAllWhere:column1 equals:value1 and:nil equals:nil];
}

- (BOOL)deleteAllWhere:(NSString *)column1
                equals:(NSString *)value1
                   and:(nullable NSString *)column2
                equals:(nullable NSString *)value2 {
    if (column1.length == 0 || value1.length == 0) {
        return NO;
    }

    NSMutableString *whereClause = [NSMutableString string];
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];

    [whereClause appendFormat:@"WHERE \"%@\" = :value1", column1];
    arguments[@"value1"] = value1;

    if (column2.length > 0 && value2.length > 0) {
        [whereClause appendFormat:@" AND \"%@\" = :value2", column2];
        arguments[@"value2"] = value2;
    }

    return [self deleteAllWhere:whereClause withParameterDictionary:arguments];
}

- (BOOL)deleteAllWhere:(NSString *)whereClause {
    return [self deleteAllWhere:whereClause withParameterDictionary:@{}];
}

- (BOOL)deleteAllWhere:(NSString *)whereClause withParameterDictionary:(NSDictionary *)arguments {

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM \"%@\" %@", self.tableName, whereClause];

    BOOL result = [self.database executeUpdate:sql withParameterDictionary:arguments];

    [[NSNotificationCenter defaultCenter] postNotificationName:EZExecuteUpdateNotification object:nil];

    return result;
}

- (NSMutableArray<__kindof EZBean *> *)selectAll {
    return [self selectAllWhere:@""];
}

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)column1
                                               equals:(NSString *)value1 {
    return [self selectAllWhere:column1 equals:value1 and:nil equals:nil orderBy:nil];
}

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)column1
                                               equals:(NSString *)value1
                                              orderBy:(nullable NSString *)orderByColumn {
    return [self selectAllWhere:column1 equals:value1 and:nil equals:nil orderBy:orderByColumn];
}

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)column1
                                               equals:(NSString *)value1
                                                  and:(nullable NSString *)column2
                                               equals:(nullable NSString *)value2 {
    return [self selectAllWhere:column1 equals:value1 and:column2 equals:value2 orderBy:nil];
}

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)column1
                                               equals:(NSString *)value1
                                                  and:(nullable NSString *)column2
                                               equals:(nullable NSString *)value2
                                              orderBy:(nullable NSString *)orderByColumn {
    return [self select:@"all" Where:column1 equals:value1 and:column2 equals:value2 orderBy:orderByColumn];
}

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)whereClause {
    return [self selectAllWhere:whereClause withParameterDictionary:@{}];
}

- (NSMutableArray<__kindof EZBean *> *)selectAllWhere:(NSString *)whereClause withParameterDictionary:(NSDictionary *)arguments {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" %@", self.tableName, whereClause];
    NSArray *dictionaryArray = [self.database executeQuery:sql withParameterDictionary:arguments];
    return [NSClassFromString(self.beanName) mj_objectArrayWithKeyValuesArray:dictionaryArray];
}

- (__kindof EZBean *)selectFirst {
    return [self selectOneWhere:@""];
}

- (__kindof EZBean *)selectOneWithIdKey:(NSString *)idKey {
    if (idKey.length == 0) {
        return nil;
    }
    NSString *whereClause = [NSString stringWithFormat:@"WHERE %@ = :idKey", self.primaryKeyName];
    NSDictionary *arguments = @{ @"idKey" : idKey };
    return [self selectOneWhere:whereClause withParameterDictionary:arguments];
}

- (__kindof EZBean *)selectOneWhere:(NSString *)column1
                             equals:(NSString *)value1 {
    return [self selectOneWhere:column1 equals:value1 and:nil equals:nil orderBy:nil];
}

- (__kindof EZBean *)selectOneWhere:(NSString *)column1
                             equals:(NSString *)value1
                            orderBy:(nullable NSString *)orderByColumn {
    return [self selectOneWhere:column1 equals:value1 and:nil equals:nil orderBy:orderByColumn];
}

- (__kindof EZBean *)selectOneWhere:(NSString *)column1
                             equals:(NSString *)value1
                                and:(nullable NSString *)column2
                             equals:(nullable NSString *)value2 {
    return [self selectOneWhere:column1 equals:value1 and:column2 equals:value2 orderBy:nil];
}

- (__kindof EZBean *)selectOneWhere:(NSString *)column1
                             equals:(NSString *)value1
                                and:(nullable NSString *)column2
                             equals:(nullable NSString *)value2
                            orderBy:(nullable NSString *)orderByColumn {
    return [self select:@"one" Where:column1 equals:value1 and:column2 equals:value2 orderBy:orderByColumn];
}

- (id)select:(NSString *)all_or_one
       Where:(NSString *)column1
      equals:(NSString *)value1
         and:(nullable NSString *)column2
      equals:(nullable NSString *)value2
     orderBy:(nullable NSString *)orderByColumn {
    if (![all_or_one isEqualToString:@"all"] && ![all_or_one isEqualToString:@"one"]) {
        return nil;
    }

    if (column1.length == 0 || value1.length == 0) {
        return nil;
    }

    NSMutableString *whereClause = [NSMutableString string];
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];

    [whereClause appendFormat:@"WHERE \"%@\" = :value1", column1];
    arguments[@"value1"] = value1;

    if (column2.length > 0 && value2.length > 0) {
        [whereClause appendFormat:@" AND \"%@\" = :value2", column2];
        arguments[@"value2"] = value2;
    }

    if (orderByColumn.length > 0) {
        [whereClause appendFormat:@" ORDER BY \"%@\"", orderByColumn];
    }

    if ([all_or_one isEqualToString:@"all"]) {
        return [self selectAllWhere:whereClause withParameterDictionary:arguments];
    } else {
        return [self selectOneWhere:whereClause withParameterDictionary:arguments];
    }
}

- (__kindof EZBean *)selectOneWhere:(NSString *)whereClause {
    return [self selectOneWhere:whereClause withParameterDictionary:@{}];
}

- (__kindof EZBean *)selectOneWhere:(NSString *)whereClause withParameterDictionary:(NSDictionary *)arguments {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" %@ LIMIT 1", self.tableName, whereClause];
    NSArray *dictionaryArray = [self.database executeQuery:sql withParameterDictionary:arguments];
    if (dictionaryArray.count == 0) {
        return nil;
    }

    return [NSClassFromString(self.beanName) mj_objectWithKeyValues:dictionaryArray[0]];
}

- (NSMutableArray<__kindof EZBean *> *)executeQuery:(NSString *)sql {
    return [self executeQuery:sql withParameterDictionary:@{}];
}

- (NSMutableArray<__kindof EZBean *> *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments {
    NSArray *dictionaryArray = [self.database executeQuery:sql withParameterDictionary:arguments];
    return [NSClassFromString(self.beanName) mj_objectArrayWithKeyValuesArray:dictionaryArray];
}

- (void)updateTableAddColumn {
}

@end
