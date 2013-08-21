//
//  SliderCell.h
//  
//
//  Created by Deheng.Xu on 13-8-19.
//  Copyright (c) 2013年 Deheng.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

// cell identifier for this custom cell
extern NSString *kSliderCell_ID;

@interface SliderCell : UITableViewCell
@property (nonatomic, retain) UISlider *slider;

@end
