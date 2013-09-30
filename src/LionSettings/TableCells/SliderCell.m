//
//  SliderCell.m
//  LRSettings
//
//  Created by Deheng.Xu on 13-8-19.
//  Copyright (c) 2013年 Deheng.Xu. All rights reserved.
//

#import "SliderCell.h"

// cell identifier for this custom cell
NSString *kSliderCell_ID = @"SliderCell_ID";

@implementation SliderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSlider:(UISlider *)slider
{
    if (_slider != slider) {
        if (_slider) {
            [_slider removeFromSuperview];
            [_slider release];
        }
        _slider = [slider retain];
        [self.contentView addSubview:_slider];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect  sliderBounds    = _slider.bounds;
    CGPoint sliderCenter    = _slider.center;
    const double superViewWidth = _slider.superview.frame.size.width;
    
    sliderCenter.x = superViewWidth / 2;
    sliderCenter.y = self.contentView.center.y;
    //kIASKSliderNoImagesPadding = 11
    sliderBounds.size.width = superViewWidth - 11/*kIASKSliderNoImagesPadding*/ * 2;
    
    _slider.center = sliderCenter;
    _slider.bounds = sliderBounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_slider release];
    [super dealloc];
}

@end
