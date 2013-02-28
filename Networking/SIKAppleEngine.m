//
//  SIKAppleEngine.m
//  iCloud Status
//
//  Created by Thomas Hajcak on 12/18/12.
//  Copyright (c) 2012 Simple Ink. All rights reserved.
//

#import "SIKAppleEngine.h"

@implementation SIKAppleEngine

- (MKNetworkOperation *)currentStatus:(StatusResponse)completionBlock onError:(MKNKErrorBlock)errorBlock
{
    NSString *userLanguage = NSLocalizedString(@"StatusLanguage", @"Status Language");
    NSLog(@"User Language: %@ / %@", [[NSLocale preferredLanguages] objectAtIndex:0], userLanguage);
    
    MKNetworkOperation *operation = [self operationWithPath:[NSString stringWithFormat:@"support/systemstatus/data/system_status_%@.js", userLanguage]
                                                     params:nil
                                                 httpMethod:@"GET"];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation)
     {
         NSDictionary *response = [completedOperation responseJSON];
         
         completionBlock(response);
     }
     onError:^(NSError *error)
     {
         errorBlock(error);
     }];
    
    [self enqueueOperation:operation];
    
    return operation;
}

@end