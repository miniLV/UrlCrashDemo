//
//  ProvinceModel.h
//  CityTest
//
//  Created by Felix on 2017/9/20.
//  Copyright © 2017年 Felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *areacode;
@property (nonatomic, copy) NSString *depth;
@property (nonatomic, copy) NSString *full_name;
@property (nonatomic, copy) NSString *parentid;
@property (nonatomic, copy) NSString *parentname;
@property (nonatomic, copy) NSString *sub_areas;
@property (nonatomic, copy) NSString *zipcode;

@property (nonatomic, copy) NSString *letterName;
@property (nonatomic, assign) BOOL expand;//该节点是否处于展开状态

+ (NSMutableArray *)letterArrayFromProvince:(NSArray *)provinceArray;

@end
