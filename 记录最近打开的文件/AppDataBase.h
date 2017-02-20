//
//  AppDataBase.h
//  ipos
//
//  Created by bob on 16/10/12.
//
//

#import <Foundation/Foundation.h>
#import "EZDB.h"


@interface AppDataBase : NSObject

SINGLETON_FOR_HEADER

@property (strong, nonatomic) EZDatabase *dataDB;
@property (nonatomic, copy) NSString *ownerID;
@property (nonatomic, copy) NSString *eCaseID;

/**
 *only for sqs to record selected planid.
 **/
@property (nonatomic, copy) NSString *insuredID;
@property (nonatomic, copy) NSString *basicPlanCode;
@property (nonatomic, copy) NSString *planID;
@property (nonatomic, copy) NSString *packageID;

- (void)clearID;

@property (assign, nonatomic) BOOL forgotPassword;

- (void)initDB;
- (BOOL)creatDBWithAgentCode:(NSString *)agentCode masterKey:(NSString *)masterKey;
- (void)deleteAgentDBWithAgentCode:(NSString *)agentCode;

@end
