//
//  ReqHTTP.m
//  ResSample
//
//  Created by OhnumaRina on 2015/10/12.
//  Copyright (c) 2015年 OhnumaRina. All rights reserved.
//

#import "ReqHTTP.h"

@implementation ReqHTTP
{
    void (^requestDoneHandler)(NSDictionary *data);
    void (^requestFailHandler)(NSInteger status);
}
- (void)postMultiDataWithImageDictionary:(NSDictionary*)imageDictionary
                                    url:(NSURL*)url done:(void(^)(NSDictionary *responseData)) doneHandler
                                   fail:(void(^)(NSInteger status)) failHandler
{
    requestDoneHandler = doneHandler;
    requestFailHandler = failHandler;
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString* boundary = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    config.HTTPAdditionalHeaders =
    @{
      @"Content-Type" : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
      };
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    // postデータの作成
    NSMutableData* data = [NSMutableData data];
    
    // 画像の設定
    for (int i = 0; i < [imageDictionary count]; i++)
    {
        NSString* key = [[imageDictionary allKeys] objectAtIndex:i];
        NSData* value = [imageDictionary valueForKey:key];
        NSString* name = [NSString stringWithFormat:@"upload_file%d", i];
        
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"name=\"%@\";", name] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"filename=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:value];
        [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // 最後にバウンダリを付ける
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [session invalidateAndCancel];//メモリリーク対策
        if(error){
            requestFailHandler(-1);
        }else{
            NSError *err = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            if (err) {
                requestFailHandler(-1);
                return;
            }
            requestDoneHandler(json);
        }
        
    }];
    
    [task resume];
}
@end
