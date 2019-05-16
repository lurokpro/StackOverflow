//
//  WebApi.m
//  Stackoverflow Lite
//
//  Created by Сергей Мирошниченко on 08/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import "WebApi.h"



NSString *const StackServerAddress = STACK_SERVER_ADDRESS;

@implementation WebApi

+ (void)request:(NSString *)request completion:(void (^)(NSDictionary *data))completion {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest new];
    [urlRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", StackServerAddress, request]]];
    [urlRequest setHTTPMethod:@"GET"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:&error];
          if([httpResponse statusCode] == 200){
              completion(responseDictionary);
          }
      }] resume];
}

@end
