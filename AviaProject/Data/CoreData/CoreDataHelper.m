//
//  CoreDataHelper.m
//  AviaProject
//
//  Created by Kirill Anisimov on 27.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end


@implementation CoreDataHelper

+ (instancetype)sharedInstance
{
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AviaProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    
    NSPersistentStore* store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    if (!store) {
        abort();
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
    NSError *error;
    [_managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

//Predicates with object type NSNumber
- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %@ AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %@", [NSNumber numberWithLong:ticket.price.integerValue], ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, [NSNumber numberWithLong:ticket.flightNumber.integerValue]];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}


- (FavoriteMapPrice *)favoriteFromMapPrice:(MapPrice *)mapPrice {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
    request.predicate = [NSPredicate predicateWithFormat:@"destination == %@ AND origin == %@ AND departure == %@ AND returnDate == %@ AND numberOfChanges == %@ AND value == %@ AND distance == %@", mapPrice.destination.name, mapPrice.origin.name, mapPrice.departure, mapPrice.returnDate, [NSNumber numberWithLong:mapPrice.numberOfChanges], [NSNumber numberWithLong:mapPrice.value], [NSNumber numberWithLong:mapPrice.distance]];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}


- (BOOL)isFavoriteMapPrice:(MapPrice *)mapPrice {
    return [self favoriteFromMapPrice:mapPrice] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    [self save];
}


- (void)addToFavoriteMapPrice:(MapPrice *)mapPrice {
    FavoriteMapPrice *favoriteMapPrice = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteMapPrice" inManagedObjectContext:_managedObjectContext];
    favoriteMapPrice.destination = mapPrice.destination.name;
    favoriteMapPrice.origin = mapPrice.origin.name;
    favoriteMapPrice.departure = mapPrice.departure;
    favoriteMapPrice.returnDate = mapPrice.returnDate;
    favoriteMapPrice.numberOfChanges = mapPrice.numberOfChanges;
    favoriteMapPrice.value = mapPrice.value;
    favoriteMapPrice.distance = mapPrice.distance;
    favoriteMapPrice.actual = mapPrice.actual;
    favoriteMapPrice.created = [NSDate date];
    [self save];
    NSLog(@"added item to Core Data");
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save];
    }
}


- (void)removeFromFavoriteMapPrice:(MapPrice *)mapPrice {
    FavoriteMapPrice *favoriteMapPrice = [self favoriteFromMapPrice:mapPrice];
    if (favoriteMapPrice) {
        [_managedObjectContext deleteObject:favoriteMapPrice];
        [self save];
        NSLog(@"removed item from Core Data");
    }
}

- (NSArray *)favorites {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}


- (NSArray *)favoritesMapPrice {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

-(void)removeAll {
    for (NSManagedObject* i in self.favorites) {
        [_managedObjectContext deleteObject:i];
    }
    [self save];
}

-(void)removeAllMapPrice {
    for (NSManagedObject* i in self.favoritesMapPrice) {
        [_managedObjectContext deleteObject:i];
    }
    [self save];
}
//- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
//    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
//    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
//}

//- (FavoriteMapPrice *)favoriteFromMapPrice:(MapPrice *)mapPrice {
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
//    request.predicate = [NSPredicate predicateWithFormat:@"destination == %@ AND origin == %@ AND departure == %@ AND returnDate == %@ AND numberOfChanges == %ld AND value == %ld AND distance == %ld", mapPrice.destination.name, mapPrice.origin.name, mapPrice.departure, mapPrice.returnDate, mapPrice.numberOfChanges, mapPrice.value, mapPrice.distance];
//    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
//}
@end
