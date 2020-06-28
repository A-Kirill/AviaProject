//
//  TicketsViewController.h
//  AviaProject
//
//  Created by Kirill Anisimov on 30.05.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;

@end

NS_ASSUME_NONNULL_END
