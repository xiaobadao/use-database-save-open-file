//
//  EZBean.h
//  ezdb
//
//  Created by zzd on 16/10/11.
//  Copyright © 2016年 zzd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EZBeanProtocol
@optional
+ (NSArray *)ignoredPropertyNames;
@end

@interface EZBean : NSObject <EZBeanProtocol>

@property (strong, nonatomic) NSString *idKey; // Primary Key

@property (strong, nonatomic) NSString *createDate; // Millisecond

@property (strong, nonatomic) NSString *updateDate; // Millisecond

+ (instancetype)createBean; // Create an empty bean

- (BOOL)save; // Insert or Update

- (BOOL)del; // Delete

@end

NS_ASSUME_NONNULL_END
