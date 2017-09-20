//
//  ProvinceModel.m
//  CityTest
//
//  Created by Felix on 2017/9/20.
//  Copyright © 2017年 Felix. All rights reserved.
//

#import "CommonModel.h"

#import <YYModel.h>
@implementation CommonModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id"
             };
}

- (NSString *)letterName {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:_full_name];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

+ (NSMutableArray *)letterArrayFromProvince:(NSArray *)provinceArray {
    NSMutableArray *sourseArray = provinceArray.mutableCopy;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < sourseArray.count; i ++) {
        CommonModel *currentModel = sourseArray[i];
        NSMutableArray *currentArray = @[].mutableCopy;
        [currentArray addObject:currentModel];
        for (int j = i + 1; j < sourseArray.count; j ++) {
            CommonModel *preModel = sourseArray[j];
            if([currentModel.letterName isEqualToString:preModel.letterName]){
                [currentArray addObject:preModel];
                [sourseArray removeObjectAtIndex:j];
                j = j -1;
            }
        }
        [tempArray addObject:currentArray];
    }
    
    NSLog(@"tempArray --- %@", tempArray);
    return tempArray.copy;
}

- (NSString *)description {
    return [self yy_modelDescription];
}
@end
