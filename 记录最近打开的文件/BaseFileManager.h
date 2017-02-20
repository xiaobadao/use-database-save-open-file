//
//  BaseFileManager.h
//  icare
//
//  Created by aiait on 16/5/6.
//  Copyright © 2016年 philamlife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseFileManager : NSObject

SINGLETON_FOR_HEADER

+ (BOOL)fileExits:(NSString *)fileName;
+ (BOOL)deleteFile:(NSString *)filePath;
+ (BOOL)createDirectoryAtPath:(NSString *)filePath;
+ (NSString *)documentsPath;
+ (NSString *)createTmpFileNameWithExtension:(NSString *)ext;
+ (NSString *)createTmpFileName:(NSString *)fileName withExtension:(NSString *)ext;
+ (BOOL)isNilOrNull:(id)value;

@end
