//
//  SIKAppleEngine.h
//  iCloud Status
//
//  Created by Thomas Hajcak on 12/18/12.
//  Copyright (c) 2012 Simple Ink. All rights reserved.
//

#import "MKNetworkEngine.h"

typedef void (^StatusResponse)(NSDictionary *response);

@interface SIKAppleEngine : MKNetworkEngine

- (MKNetworkOperation *)currentStatus:(StatusResponse)completionBlock onError:(MKNKErrorBlock)errorBlock;

@end
