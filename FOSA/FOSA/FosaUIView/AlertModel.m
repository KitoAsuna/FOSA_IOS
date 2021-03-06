//
//  AlertModel.m
//  fosa1.0
//
//  Created by hs on 2019/10/16.
//  Copyright © 2019 hs. All rights reserved.
//

#import "AlertModel.h"

@implementation AlertModel

+(instancetype)modelWithName:(NSString *)food_name device_name:(NSString *)device_name icon:(NSString *)icon expire_date:(NSString *)expire_date remind_date:(NSString *)remind_date{
    return [[self alloc] initWithName:food_name device_name:device_name icon:icon expire_date:expire_date remind_date:remind_date];
}
- (instancetype) initWithName:(NSString *) food_name device_name:(NSString *) device_name icon:(NSString *)icon expire_date:(NSString *) expire_date remind_date:(NSString *)remind_date{
    if(self == [super init]){
        self.food_name = food_name;
        self.icon = icon;
        self.device_name = device_name;
        self.expire_date = expire_date;
        self.remind_date = remind_date;
    }
    return self;
}
@end
