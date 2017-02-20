//
//  OpenFileBean.h
//  记录最近打开的文件
//
//  Created by apple on 2017/2/16.
//  Copyright © 2017年 Chuckie. All rights reserved.
//

#import "EZBean.h"

@interface OpenFileBean : EZBean

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileData;

@end
