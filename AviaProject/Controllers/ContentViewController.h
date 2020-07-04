//
//  ContentViewController.h
//  AviaProject
//
//  Created by Kirill Anisimov on 04.07.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : UIViewController

@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) int index;

@end

NS_ASSUME_NONNULL_END
