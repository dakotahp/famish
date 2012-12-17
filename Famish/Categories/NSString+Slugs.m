//
//  NSString+NSString_Slugs.m
//  Famish
//
//  Created by Francisco Flores on 12/16/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "NSString+Slugs.h"

@implementation NSString (NSString_Slugs)

- (NSString *)fromSlug
{
    return [self stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

- (NSString *)toSlug
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@"_"];
}

@end
