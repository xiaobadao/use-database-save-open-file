//
//  BaseFileManager.m
//  icare
//
//  Created by aiait on 16/5/6.
//  Copyright © 2016年 philamlife. All rights reserved.
//

#import "BaseFileManager.h"

@implementation BaseFileManager

SINGLETON_FOR_CLASS

+ (BOOL)fileExits:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+ (BOOL)deleteFile:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:NULL];
}

+ (BOOL)createDirectoryAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL];
}

+ (NSString *)documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)createTmpFileNameWithExtension:(NSString *)ext {
    return [[BaseFileManager documentsPath] stringByAppendingPathComponent:FORMAT(@"%lld.%@", MSEC([[NSDate date] timeIntervalSince1970]), ext)];
}

+ (NSString *)createTmpFileName:(NSString *)fileName withExtension:(NSString *)ext{
    return [[BaseFileManager documentsPath] stringByAppendingPathComponent:FORMAT(@"%@.%@", fileName, ext)];
}

+ (BOOL)isNilOrNull:(id)value {
    return value == nil || value == [NSNull null];
}

@end
