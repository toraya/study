//
//  ViewController.m
//  ResSample
//
//  Created by OhnumaRina on 2015/10/05.
//  Copyright (c) 2015年 OhnumaRina. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.3:5000/classify"];
//    UIImage *sampleImage = [UIImage imageNamed:@"vlcsnap-2015-05-31-00h33m14s99.png"];
//    NSData *pngDate = UIImagePNGRepresentation(sampleImage);
//    
//    NSMutableDictionary* images = [NSMutableDictionary dictionary];
//    [images setObject:pngDate forKey:@"image"];
//    
//    ReqHTTP *reqHttp = [[ReqHTTP alloc] init];
//    
//    [reqHttp postMultiDataWithImageDictionary:images
//                                          url:url
//                                         done:^(NSDictionary *responseData) {
//                                             NSInteger status = [[responseData objectForKey:@"score"] integerValue];
//                                             if (status < 0) {
//                                                 NSLog(@"失敗");
//                                                 return;
//                                             }
//                                             //成功
//                                             NSLog(@"success %@", responseData);
//                                             
//                                         } fail:^(NSInteger status) {
//                                             NSLog(@"画像のUploadに失敗");
//                                         }];
    
    NSURL* url = [NSURL URLWithString:@"http://192.168.1.3:5000/classify"];
    NSString* boundary = @"MyBoundaryString";
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders =
    @{
      @"Content-Type" : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
      };
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    // アップロードする画像
    NSString* path = [[NSBundle mainBundle] pathForResource:@"vlcsnap-2015-05-31-00h33m14s99" ofType:@"png"];
    NSData* imageData = [NSData dataWithContentsOfFile:path];
    
    // postデータの作成
    NSMutableData* data = [NSMutableData data];

    // 画像の設定
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\";", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"filename=\"%@\"\r\n", @"vlcsnap-2015-05-31-00h33m14s99.png"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:imageData];
    [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 最後にバウンダリを付ける
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                // 完了時の処理
                                                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                //NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                NSLog(@"%@",array);
                                                NSLog(@"%@,%@", [array valueForKeyPath:@"label"], [array valueForKeyPath:@"label_name"]);
                                                
//                                                for (NSDictionary *obj in array)
//                                                {
//                                                    [data addObject:[obj objectForKey:@"key名"]];
//                                                }
                                            }];
   // NSLog(@"%@",task);
    [task resume];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperationWithBlock:^{
//        
//        NSString *image = @"vlcsnap-2015-05-31-00h33m14s99.png";
//        UIImage *sampleImage = [UIImage imageNamed:image];
//        NSData *pngDate = UIImagePNGRepresentation(sampleImage);
//        
//        NSString *url = @"http://192.168.1.3:5000/classify";
//        NSString *param = [NSString stringWithFormat:@"image=%@",pngDate];
//        
//        NSMutableURLRequest *request;
//        request = [[NSMutableURLRequest alloc] init];
//        [request setHTTPMethod:@"POST"];
//        [request setURL:[NSURL URLWithString:url]];
//        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
//        [request setTimeoutInterval:20];
//        [request setHTTPShouldHandleCookies:FALSE];
//        [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSURLResponse *response = nil;
//        NSError *error = nil;
//        NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                             returningResponse:&response
//                                                         error:&error];
//        if(error != nil){
//            NSLog(@"Error");
//            return;
//        }
//        
//        NSError *e = nil;
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
//                                                             options:NSJSONReadingMutableContainers
//                                                               error:&e];
//        NSString *token = [dict objectForKey:@"label_name"];
//        NSLog(@"%@",dict);
//    
//    
//    }];
    
//    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.dateStr]];
//    
//    if(connection) [connection cancel];
//        connection = [[NSURLConnection alloc] initWithRequest:self.request
//                                                     delegate:self
//                                             startImmediately:NO];
//    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//    [connection start];
    // Do any additional setup after loading the view, typically from a nib.
}
//
////レスポンスを受けとってから呼び出される
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    [getDate setLength:0];
//}
//
////データを受け取るたびに呼ばれる
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [getDate appendData:data];
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSString *json_str = [[NSString alloc] initWithData:getDate encoding:NSUTF8StringEncoding];
//    self.imgDate = [json_str dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    
//    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:self.imgDate
//                                                               options:NSJSONReadingAllowFragments
//                                                                 error:&error];
//    NSLog(@"%@",jsonObject);
//}
//


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
