//
//  TicketTableViewCell.h
//  AviaProject
//
//  Created by Kirill Anisimov on 30.05.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "FavoriteTicket+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;

@end

NS_ASSUME_NONNULL_END
