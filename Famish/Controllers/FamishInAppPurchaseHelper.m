//
//  FamishInAppPurchaseHelper.m
//  Famish
//
//  Created by Dakotah Peña on 12/22/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "FamishInAppPurchaseHelper.h"

@implementation FamishInAppPurchaseHelper

+ (FamishInAppPurchaseHelper *)sharedInstance {
    static dispatch_once_t once;
    static FamishInAppPurchaseHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.adr.enal.in.famish.pro",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
