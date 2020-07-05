//
//  FavoriteViewController.m
//  AviaProject
//
//  Created by Kirill Anisimov on 28.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "FavoriteViewController.h"
#import "CoreDataHelper.h"
#import "TicketTableViewCell.h"

#define MapCellReuseIdentifier @"MapCellIdentifier"

@interface FavoriteViewController ()
@property (nonatomic, strong) NSArray *prices;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation FavoriteViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _prices = [NSArray new];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:MapCellReuseIdentifier];
    self.navigationController.navigationBar.prefersLargeTitles = NO;

    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"MapPrices", @"Tickets"]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc]
                           initWithTitle:NSLocalizedString(@"Clear", @"")
                           style:UIBarButtonItemStylePlain
                           target:self
                           action:@selector(removeAllFavorites)];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)changeSource
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _prices = [[CoreDataHelper sharedInstance] favoritesMapPrice];
            break;
        case 1:
            _prices = [[CoreDataHelper sharedInstance] favorites];
            break;
        default:
            break;
    }

    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}

-(void)removeAllFavorites {
    if (_segmentedControl.selectedSegmentIndex == 0){
        [[CoreDataHelper sharedInstance] removeAllMapPrice];
    } else {
        [[CoreDataHelper sharedInstance] removeAll];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _prices.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MapCellReuseIdentifier forIndexPath:indexPath];
    if (_segmentedControl.selectedSegmentIndex == 0){
        cell.favoriteMapPrice = [_prices objectAtIndex:indexPath.row];
    } else {
        cell.favoriteTicket = [_prices objectAtIndex:indexPath.row];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
