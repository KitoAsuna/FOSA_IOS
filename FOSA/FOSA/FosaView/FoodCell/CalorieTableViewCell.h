//
//  CalorieTableViewCell.h
//  FOSA
//
//  Created by hs on 2019/12/4.
//  Copyright © 2019 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalorieTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton *delete_cell,*select,*units;
@property (nonatomic,strong) UILabel *foodName;
@property (nonatomic,strong) UITextView *weight,*calorie;

@end

NS_ASSUME_NONNULL_END
