//
//  NSString+Localize.m
//  AviaProject
//
//  Created by Kirill Anisimov on 10.07.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localize {
    return NSLocalizedString(self, "");
}

@end

