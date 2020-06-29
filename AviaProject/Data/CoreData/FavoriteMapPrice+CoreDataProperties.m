//
//  FavoriteMapPrice+CoreDataProperties.m
//  AviaProject
//
//  Created by Kirill Anisimov on 28.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//
//

#import "FavoriteMapPrice+CoreDataProperties.h"

@implementation FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
}

@dynamic destination;
@dynamic origin;
@dynamic departure;
@dynamic returnDate;
@dynamic numberOfChanges;
@dynamic value;
@dynamic distance;
@dynamic actual;
@dynamic created;

@end
