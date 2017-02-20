//
//  AppDataBase.m
//  ipos
//
//  Created by bob on 16/10/12.
//
//

#import "AppDataBase.h"
#import "OpenFileDao.h"

@interface AppDataBase () {
    NSString *DATA_DB_PATH;
    NSString *COMMON_DB_PATH;
}

@end

@implementation AppDataBase

SINGLETON_FOR_CLASS

- (void)clearID {
    self.ownerID = nil;
    
    self.eCaseID = nil;
    
    self.insuredID = nil;
    self.basicPlanCode = nil;
    self.planID = nil;
    self.packageID = nil;
}

//跳过登录初始化DB
- (void)initDB
{
    DATA_DB_PATH = [[NSString alloc] initWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.db"]];
    self.dataDB = [EZDatabase databaseWithPath:DATA_DB_PATH];
    NSLog(@"%@",DATA_DB_PATH);
    [self initAgentDB];
//    [self addTrigger];
    [self deleteInvalidData];
}

//不跳过登录初始化DB (from BPLAC iCare)
- (BOOL)creatDBWithAgentCode:(NSString *)agentCode masterKey:(NSString *)masterKey {
//    if (agentCode.length == 0) {
//        return NO;
//    }
//    NSString *encryptDBName = [Repeat32Key encryptGoal:agentCode withSourceKey:agentCode];
//    encryptDBName = [encryptDBName stringByReplacingOccurrencesOfString:@"/" withString:@"A"];
//    
//    DATA_DB_PATH = [[NSString alloc] initWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:FORMAT(@"%@", encryptDBName)]];
//    COMMON_DB_PATH = [[NSString alloc] initWithString:[[NSBundle mainBundle] resourcePath]];
//    
//    if (![BaseFileManager fileExits:DATA_DB_PATH]) {
//        [BaseFileManager createDirectoryAtPath:DATA_DB_PATH];
//    }
//    if (![BaseFileManager fileExits:COMMON_DB_PATH]) {
//        [BaseFileManager createDirectoryAtPath:COMMON_DB_PATH];
//    }
//    
//    DATA_DB_PATH = [DATA_DB_PATH stringByAppendingPathComponent:FORMAT(@"%@.db3",encryptDBName)];
//    COMMON_DB_PATH = [COMMON_DB_PATH stringByAppendingPathComponent:FORMAT(@"Common.db")];
//    
//    self.dataDB = [EZDatabase databaseWithPath:DATA_DB_PATH key:masterKey];
//
//    
//    [self initAgentDB];
////    [self addTrigger];
//    [self deleteInvalidData];
    
    return YES;
}

- (void)initAgentDB {
//    [[CaptureNameDao getInstance] initWithDatabase:self.commonDB];
//    [[AgentProfileDao getInstance] initWithDatabase:self.dataDB];
//    [[AgentProfileDao getInstance] updateTableAddColumn];
    
    /***init common db***/
    [[OpenFileDao getInstance] initWithDatabase:self.dataDB];
}

- (void)addTrigger {
  
}


- (void)timeBomb {
//    [self deleteAgentDBWithAgentCode:[AppDataBase getInstance].agentProfileBean.agentCode];
}

- (void)deleteInvalidData {
//    [[ECaseDao getInstance] deleteECaseBeanWithTimeBombDay:60];
//    [[IMOContactDao getInstance] deleteIMOContactBeanWithTimeBombDay:60];
}

- (void)deleteAgentDBWithAgentCode:(NSString *)agentCode {
//    NSString *encryptDBName = [Repeat32Key encryptGoal:agentCode withSourceKey:agentCode];
//    encryptDBName = [encryptDBName stringByReplacingOccurrencesOfString:@"/" withString:@"A"];
//    
//    NSString *dbPath = [[NSString alloc] initWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:FORMAT(@"%@", encryptDBName)]];
//    [BaseFileManager deleteFile:dbPath];
}

@end
