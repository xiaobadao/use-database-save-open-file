//
//  OpenFileDao.h
//  记录最近打开的文件
//
//  Created by apple on 2017/2/16.
//  Copyright © 2017年 Chuckie. All rights reserved.
//

#import "EZDao.h"
#import "OpenFileBean.h"

@interface OpenFileDao : EZDao

- (OpenFileBean *)queryReadFileBeanWith:(NSString *)fileName;

@end
