//
//  AddViewController.h
//  FOSA
//
//  Created by hs on 2019/11/11.
//  Copyright © 2019 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController

//底层视图
@property (nonatomic,strong) UIScrollView *rootScrollview;

//顶部控件
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIImageView *imageView1,*imageView2,*imageView3,*imageView4;
@property (nonatomic,strong) UIScrollView *picturePlayer;   //图片轮播器
@property (nonatomic,strong) UIPageControl *pageControl;    //页面指示器
@property (nonatomic,strong) NSMutableArray<UIImage *> *food_image;
@property (nonatomic,strong) UIButton *share,*like;
@property (nonatomic,strong) UITextView *deviceName;

//
@property (nonatomic,strong) UIView *foodNameView,*aboutFoodView,*expireView,*remindView,*locationView,*weightView,*calorieView;
@property (nonatomic,strong) UITextField *foodName,*aboutFood;
@property (nonatomic,strong) UITextView *expireDate,*remindDate,*location,*weight,*calorie;
@property (nonatomic,strong) UIButton *expireBtn,*remindBtn,*locationBtn,*weightBtn,*calBtn;

//屏幕尺度
@property (nonatomic,assign) CGFloat mainWidth,mainheight,navHeight;

@end

NS_ASSUME_NONNULL_END
