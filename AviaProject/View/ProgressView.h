//
//  ProgressView.h
//  AviaProject
//
//  Created by Kirill Anisimov on 04.07.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;


@end

NS_ASSUME_NONNULL_END
