//
//  FavoriteTicket+CoreDataProperties.m
//  AviaProject
//
//  Created by Kirill Anisimov on 28.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
}

@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic returnDate;
@dynamic airline;
@dynamic from;
@dynamic to;
@dynamic price;
@dynamic flightNumber;

@end
