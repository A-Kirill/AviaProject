//
//  FavoriteMapPrice+CoreDataProperties.h
//  AviaProject
//
//  Created by Kirill Anisimov on 28.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//
//

#import "FavoriteMapPrice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *destination;
@property (nullable, nonatomic, copy) NSString *origin;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nonatomic) int16_t numberOfChanges;
@property (nonatomic) int64_t value;
@property (nonatomic) int64_t distance;
@property (nonatomic) BOOL actual;
@property (nullable, nonatomic, copy) NSDate *created;

@end

NS_ASSUME_NONNULL_END
