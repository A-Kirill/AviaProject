//
//  CoreDataHelper.h
//  AviaProject
//
//  Created by Kirill Anisimov on 27.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "Ticket.h"
#import "MapPrice.h"
#import "FavoriteMapPrice+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

- (BOOL)isFavoriteMapPrice:(MapPrice *)mapPrice;
- (NSArray *)favoritesMapPrice;
- (void)addToFavoriteMapPrice:(MapPrice *)mapPrice;
- (void)removeFromFavoriteMapPrice:(MapPrice *)mapPrice;

@end

NS_ASSUME_NONNULL_END
