//
//  TicketsViewController.m
//  AviaProject
//
//  Created by Kirill Anisimov on 30.05.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()
@property (nonatomic, strong) NSArray *tickets;
@end

@implementation TicketsViewController {
    BOOL isFavorites;
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        self.tickets = [NSArray new];
        self.title = @"Избранное";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}


- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        _tickets = tickets;
        self.title = @"Tickets";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        _tickets = [[CoreDataHelper sharedInstance] favorites];
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    
    if (isFavorites) {
        cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
    } else {
        cell.ticket = [_tickets objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
//    cell.ticket = [_tickets objectAtIndex:indexPath.row];
//    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) return;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что необходимо сделать с выбранным билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavorite: [_tickets objectAtIndex:indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];//self->
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavorite:[self->_tickets objectAtIndex:indexPath.row]];//self->
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
