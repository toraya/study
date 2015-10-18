//
//  ReqHTTP.h
//  ResSample
//
//  Created by OhnumaRina on 2015/10/12.
//  Copyright (c) 2015年 OhnumaRina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface ReqHTTP : NSObject

- (void)postMultiDataWithImageDictionary:(NSDictionary*)imageDictionary
                                     url:(NSURL*)url done:(void(^)(NSDictionary *responseData)) doneHandler
                                    fail:(void(^)(NSInteger status)) failHandler;

@end
