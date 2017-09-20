//
//  YHAFNHelper.m
//  即时通讯
//
//  Created by apple on 17/2/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YHAFNHelper.h"

@implementation YHAFNHelper


//单例实现
+ (YHAFNHelper *)sharedManager {
    
    static YHAFNHelper *YHmanager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YHmanager = [YHAFNHelper manager];
        // 设置可接受的类型
        
        YHmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/vnd.henzfin.api+json", nil];
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //连接超时设置
        requestSerializer.timeoutInterval = 15;
        
        //header添加验证
        NSString *DefaultToken = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1MDgyOTcxNTcsInVzZXJuYW1lIjoiMTg1NTkyMjMyNzIiLCJvcmlnX2lhdCI6MTUwNTcwNTE1NywiZW1haWwiOiIiLCJtb2JpbGUiOiIxODU1OTIyMzI3MiIsInVzZXJfaWQiOiJhZWI3NDA5MS1mYzgzLTQ3YWYtOTBiMi0zMmY1NDk1Y2NmNjgifQ.YG4b8Zs_epEIDtjVomLC5n7IPTcdIegArUfoBzEiYt4";
        
        NSString *setToken = [@"JWT " stringByAppendingString:DefaultToken];
        [requestSerializer setValue:setToken forHTTPHeaderField:@"Authorization"];

        
        //请求头还需要附加这个 Accept
        [requestSerializer setValue:@"application/vnd.henzfin.api+json;version=1.0" forHTTPHeaderField:@"Accept"];
        
        YHmanager.requestSerializer = requestSerializer;
    });
    
    return YHmanager;
    
}


//get请求:注意传递的url是否是全路径，不是的话在拼接
+ (void )get:(NSString *)url parameter:(id)parameters success:(void (^)(id responseObject))success faliure:(void (^)(id error))failure
{
    
    //GET:url :如果传的是完整的接口就直接用，如果是需要拼接的，再拼接[HOST stringByAppendingString:url]
    [[YHAFNHelper sharedManager] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if(responseObject)  {
            
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}

//post请求
+ (void)post:(NSString *)url parameters:(id)parameters success:(void(^)(id responseObject))success faliure:(void(^)(id error))failure {
    
    [[YHAFNHelper sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if(responseObject)  {
            
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}



@end
