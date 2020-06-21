//
//  ImageCollectionCell.m
//  AviaProject
//
//  Created by Kirill Anisimov on 21.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "ImageCollectionCell.h"


@implementation ImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void) addSubviews {
    [self addImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat w = self.contentView.bounds.size.width - 16 * 2;
    self.myImage.frame = CGRectMake(self.contentView.bounds.origin.x + 16, y + 16, w, w);
}

- (void) addImage {
    if (nil != self.myImage) { return; }
    UIImageView *image = [UIImageView new];
    [self.contentView addSubview: image];
    self.myImage = image;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
