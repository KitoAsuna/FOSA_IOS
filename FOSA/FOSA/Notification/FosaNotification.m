//
//  FosaNotification.m
//  FOSA
//
//  Created by hs on 2019/11/14.
//  Copyright © 2019 hs. All rights reserved.
//

#import "FosaNotification.h"
#import <UserNotifications/UserNotifications.h>
#import <CoreImage/CoreImage.h>
#import "SqliteManager.h"
//图片宽高的最大值
#define KCompressibilityFactor 1280.00
@interface FosaNotification()<UNUserNotificationCenterDelegate>
@property (nonatomic,strong) UIImage *image,*codeImage;
@end

@implementation FosaNotification

/** 屏幕高度 */
#define screen_height [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define screen_width [UIScreen mainScreen].bounds.size.width

//仿照系统通知绘制UIview
- (UIView *)CreatNotificatonView:(NSString *)title body:(NSString *)body{
    NSLog(@"begin creating");

    CGFloat mainwidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mainHeight = [UIScreen mainScreen].bounds.size.height;

    UIView *notification = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainwidth,mainHeight)];
    notification.backgroundColor = [UIColor whiteColor];

    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(mainwidth/12, mainwidth/12, mainwidth/6, mainwidth/6)];
    UILabel *brand = [[UILabel alloc]initWithFrame:CGRectMake(mainwidth/4, mainwidth/8, mainwidth/4, mainwidth)];
    UIImageView *InfoCodeView = [[UIImageView alloc]initWithFrame:CGRectMake(mainwidth*4/5-10, 5, mainwidth/5, mainwidth/5)];

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0,mainHeight/4, mainwidth, mainHeight/2)];
    UILabel *Ntitle = [[UILabel alloc]initWithFrame:CGRectMake(5,mainHeight*3/4+10, mainwidth, 20)];
    UILabel *Nbody = [[UILabel alloc]initWithFrame:CGRectMake(5, mainHeight*3/4+40, mainwidth, 20)];

    [notification addSubview:logo];
    [notification addSubview:brand];
    [notification addSubview:InfoCodeView];
    [notification addSubview:Ntitle];
    [notification addSubview:image];
    [notification addSubview:Nbody];

    logo.image  = [UIImage imageNamed:@"logo"];
    image.image = self.image;
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;

    InfoCodeView.image = self.codeImage;
    InfoCodeView.backgroundColor = [UIColor redColor];
    InfoCodeView.contentMode = UIViewContentModeScaleAspectFill;
    InfoCodeView.clipsToBounds = YES;

    brand.font  = [UIFont systemFontOfSize:10];
    brand.textAlignment = NSTextAlignmentCenter;
    brand.text  = @"FOSA";

    Ntitle.font  = [UIFont systemFontOfSize:12];
    Ntitle.textColor = [UIColor redColor];
    Ntitle.text = title;

    Nbody.font   = [UIFont systemFontOfSize:12];
    Nbody.text = body;

    return notification;
//    
//    NSLog(@"begin creating");
//    
//    int mainwidth = screen_width;
//    int mainHeight = screen_height;
//    
//    UIView *notification = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainwidth,mainHeight)];
//    notification.backgroundColor = [UIColor whiteColor];
//
//    //食物图片
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0,mainHeight/8, mainwidth, mainHeight/2)];
//    
//    //FOSA的logo
//    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(mainwidth*2/5, mainHeight-mainwidth*3/10, mainwidth/5, mainwidth/5)];
//    
//    //FOSA
//    UILabel *brand = [[UILabel alloc]initWithFrame:CGRectMake(mainwidth/15, mainHeight*11/16, mainwidth/4, mainHeight/16)];
//    
//    //食物信息二维码
//    UIImageView *InfoCodeView = [[UIImageView alloc]initWithFrame:CGRectMake(mainwidth*4/5-20, mainHeight*11/16, mainwidth/5, mainwidth/5)];
//
//    //提醒内容
//    UITextView *Nbody = [[UITextView alloc]initWithFrame:CGRectMake(mainwidth/15, mainHeight*3/4+5, mainwidth*3/5, mainwidth/5)];
//    Nbody.userInteractionEnabled = NO;
//
//    [notification addSubview:logo];
//    [notification addSubview:brand];
//    [notification addSubview:InfoCodeView];
//    [notification addSubview:image];
//    [notification addSubview:Nbody];
//
//    logo.image  = [UIImage imageNamed:@"icon_logoHL"];
//    NSLog(@"食物图片被添加到分享视图上:%@",self.image);
//    image.image = self.image;
//    image.contentMode = UIViewContentModeScaleAspectFill;
//    image.clipsToBounds = YES;
//    InfoCodeView.image = self.codeImage;
//    InfoCodeView.backgroundColor = [UIColor redColor];
//    InfoCodeView.contentMode = UIViewContentModeScaleAspectFill;
//    InfoCodeView.clipsToBounds = YES;
//    
//    brand.font  = [UIFont systemFontOfSize:15];
//    brand.textAlignment = NSTextAlignmentCenter;
//    brand.text  = @"FOSA";
//    
//    Nbody.font   = [UIFont systemFontOfSize:12];
//    Nbody.text = body;
//    
//    return notification;
}

//将UIView转化为图片并保存在相册
- (UIImage *)SaveViewAsPicture:(UIView *)view{
    NSLog(@"begin saving");
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageRet;
}
- (UIImage *)GenerateQRCodeByMessage:(NSString *)message{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    //[self createNonInterpolatedUIImageFormCIImage:image withSize:];
    return [UIImage imageWithCIImage:image];
}
//获得高清的二维码图片
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)initNotification{
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            // 必须写代理，不然无法监听通知的接收与点击
    center.delegate = self;
        //设置预设好的交互类型，NSSet里面是设置好的UNNotificationCategory
    [center setNotificationCategories:[self createNotificationCategoryActions]];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    if (settings.authorizationStatus==UNAuthorizationStatusNotDetermined){
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error){
                if (granted) {
                    } else {
                    }
                }];
            }
        else{
           //do other things
        }
    }];
}
//代理回调方法，通知即将展示的时候
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"即将展示通知");
//    UNNotificationRequest *request = notification.request; // 原始请求
//    NSDictionary * userInfo = notification.request.content.userInfo;//userInfo数据
//    UNNotificationContent *content = request.content; // 原始内容
//    NSString *title = content.title;  // 标题
//    NSString *subtitle = content.subtitle;  // 副标题
//    NSNumber *badge = content.badge;  // 角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 指定的声音
//建议将根据Notification进行处理的逻辑统一封装，后期可在Extension中复用~
completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 回调block，将设置传入
}
//用户与通知进行交互后的response，比如说用户直接点开通知打开App、用户点击通知的按钮或者进行输入文本框的文本
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
   //获取通知相关内容
    UNNotificationRequest *request = response.notification.request; // 原始请求
    UNNotificationContent *content = request.content; // 原始内容
    NSString *title = content.title;  // 标题
    NSString *body = content.body;    // 推送消息体

//在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        UNTextInputNotificationResponse * textResponse = (UNTextInputNotificationResponse*)response;
        NSString * text = textResponse.userText;
        NSLog(@"%@",text);
    }
    else{
        if ([response.actionIdentifier isEqualToString:@"see1"]){
            NSLog(@"Save UIView as photo");
            UIImage *notificationImage = [self SaveViewAsPicture: [self CreatNotificatonView:title body:body]];
            //[self beginShare:image];
            UIImageWriteToSavedPhotosAlbum(notificationImage, self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
            
//            ScanOneCodeViewController *scan = [[ScanOneCodeViewController alloc]init];
//            scan.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:scan animated:NO];
//            //[self beginShare];
        }
        if ([response.actionIdentifier isEqualToString:@"see2"]) {
            //I don't care~
            NSLog(@"I know");
            [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[response.notification.request.identifier]];
        }
    }
    completionHandler();
//
//    UNNotificationRequest *request = response.notification.request; // 原始请求
////NSDictionary * userInfo = notification.request.content.userInfo;//userInfo数据
//    UNNotificationContent *content = request.content; // 原始内容
//    NSString *title = content.title;  // 标题
//    NSString *subtitle = content.subtitle;  // 副标题
//    NSNumber *badge = content.badge;  // 角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;
//在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调

}
- (void)sendNotificationByDate:(NSString *)foodName body:(NSString *)body path:(NSString *)photo deviceName:(NSString *)device date:(NSString *)mdate{
    NSLog(@"我将发送一个系统通知");
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"\"Reminding\"";
    content.subtitle = @"by Fosa";
    content.body = body;
    content.badge = @0;
    //获取沙盒中的图片
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@.png",photo];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    self.image = img;
    NSLog(@"%@",imagePath);
    NSError *error = nil;
    //将本地图片的路径形成一个图片附件，加入到content中
    UNNotificationAttachment *img_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:imagePath] options:nil error:&error];
    if (error) {
        NSLog(@"%@", error);
       }
    content.attachments = @[img_attachment];
    //设置为@""以后，进入app将没有启动页
    content.launchImageName = @"";
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    //设置时间间隔的触发器
    //格式化时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd/HH:mm"];
    NSDate * date = [formatter dateFromString:mdate];
    NSDateComponents * components = [[NSCalendar currentCalendar]
                                                components:NSCalendarUnitYear |
                                                NSCalendarUnitMonth |
                                                NSCalendarUnitWeekday |
                                                NSCalendarUnitDay |
                                                NSCalendarUnitHour |
                                                NSCalendarUnitMinute |
                                                NSCalendarUnitSecond
                                                fromDate:date];
    UNCalendarNotificationTrigger *date_trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    NSString *requestIdentifer = photo;
           //content.categoryIdentifier = @"textCategory";
    content.categoryIdentifier = @"seeCategory";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:date_trigger];
       
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
           NSLog(@"%@",error);
    }];
    [self Savephoto:img name:photo];
}
- (void)sendNotification:(NSString *)foodName body:(NSString *)body path:(UIImage *)image deviceName:(NSString *)device {
    NSLog(@"我将发送一个系统通知");
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"\"Reminding\"";
    content.subtitle = @"by Fosa";
    content.body = body;
    content.badge = @0;
    //获取沙盒中的图片
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photopath = [NSString stringWithFormat:@"%@.png",foodName];
    NSString *imagePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",photopath]];
    NSError *error = nil;
    //将本地图片的路径形成一个图片附件，加入到content中
    UNNotificationAttachment *img_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:imagePath] options:nil error:&error];
 
    if (error) {
        NSLog(@"%@", error);
    }
    content.attachments = @[img_attachment];
    //设置为@""以后，进入app将没有启动页
    content.launchImageName = @"";
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    //设置时间间隔的触发器
    UNTimeIntervalNotificationTrigger *time_trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    NSString *requestIdentifer = foodName;
        //content.categoryIdentifier = @"textCategory";
    content.categoryIdentifier = @"seeCategory";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:time_trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
    UIImage *img = image;
    self.image = img;
    [self Savephoto:image name:foodName];//重新保存图片
    [self SelectSql:device foodname:foodName];
}
- (void)SelectSql:(NSString *)device foodname:(NSString *)name{
    //打开数据库
    sqlite3 *database = [SqliteManager InitSqliteWithName:@"Fosa.db"];
    sqlite3_stmt *stmt;
     NSString *sql = [NSString stringWithFormat:@"select foodName,deviceName,aboutFood,expireDate,remindDate,photoPath from Fosa2 where deviceName = '%@' and foodName = '%@'",device,name];
    stmt = [SqliteManager SelectDataFromTable:sql database:database];
    if (stmt != NULL) {
     while (sqlite3_step(stmt) == SQLITE_ROW) {
        const char *food_name = (const char *)sqlite3_column_text(stmt, 0);
        const char *device_name = (const char*)sqlite3_column_text(stmt,1);
        const char *about_food = (const char*) sqlite3_column_text(stmt,2);
        const char *expired_date = (const char *)sqlite3_column_text(stmt,3);
        const char *remind_date = (const char*)sqlite3_column_text(stmt,4);
        const char *photo_path = (const char *)sqlite3_column_text(stmt,5);
         NSLog(@"<<<<<<<<<<<<<<<<<<<<<<==========%@",[NSString stringWithUTF8String:photo_path]);
         NSString *foodName = [NSString stringWithUTF8String:food_name];
         NSString *deviceName = [NSString stringWithUTF8String:device_name];
         NSString *aboutFood = [NSString stringWithUTF8String:about_food];
         NSString *expireDate = [NSString stringWithUTF8String:expired_date];
         NSString *remindDate = [NSString stringWithUTF8String:remind_date];
         NSString *FoodInfo = [NSString stringWithFormat:@"FOSA&%@&%@&%@&%@&%@&",foodName,deviceName,aboutFood,expireDate,remindDate];
         NSLog(@"<<<<<<<<<<<<<<<<%@",FoodInfo);
         self.codeImage = [self GenerateQRCodeByMessage:FoodInfo];
         break;
            }
        }else{
            NSLog(@"查询失败");
        }
    [SqliteManager CloseSql:database];
}
-(NSSet *)createNotificationCategoryActions{
    //定义按钮的交互button action
    UNNotificationAction * likeButton = [UNNotificationAction actionWithIdentifier:@"see1" title:@"Save as Picture" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    UNNotificationAction * dislikeButton = [UNNotificationAction actionWithIdentifier:@"see2" title:@"I don't care~" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    //定义文本框的action
    UNTextInputNotificationAction * text = [UNTextInputNotificationAction actionWithIdentifier:@"text" title:@"How about it~?" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    //将这些action带入category
    UNNotificationCategory * choseCategory = [UNNotificationCategory categoryWithIdentifier:@"seeCategory" actions:@[likeButton,dislikeButton] intentIdentifiers:@[@"see1",@"see2"] options:UNNotificationCategoryOptionNone];
    UNNotificationCategory * comment = [UNNotificationCategory categoryWithIdentifier:@"textCategory" actions:@[text] intentIdentifiers:@[@"text"] options:UNNotificationCategoryOptionNone];
    return [NSSet setWithObjects:choseCategory,comment,nil];
}
#pragma mark - <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        NSLog(@"%@",msg);
    }else{
        msg = @"保存图片成功" ;
        [self SystemAlert:msg];
    }
}
//保存到沙盒
-(NSString *)Savephoto:(UIImage *)image name:(NSString *)foodname{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *photoName = [NSString stringWithFormat:@"%@.png",foodname];
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent: photoName];// 保存文件的路径
    NSLog(@"这个是照片的保存地址:%@",filePath);
    BOOL result =[UIImagePNGRepresentation(image) writeToFile:filePath  atomically:YES];// 保存成功会返回YES
    if(result == YES) {
        NSLog(@"保存成功");
    }
    return filePath;
}
//弹出系统提示
-(void)SystemAlert:(NSString *)message{
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$SystemAlert");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
}
-(void)beginShare:(UIImage *)image{
    NSLog(@"点击了分享");
    //UIImage *sharephoto = [self getJPEGImagerImg:self.food_image];
    //UIImage *sharephoto1 = [self getJPEGImagerImg:[UIImage imageNamed:@"启动图2"]];
    //NSArray *activityItems = @[image];
    //UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
}
#pragma mark - 压缩图片
- (UIImage *)getJPEGImagerImg:(UIImage *)image{
 CGFloat oldImg_WID = image.size.width;
 CGFloat oldImg_HEI = image.size.height;
 //CGFloat aspectRatio = oldImg_WID/oldImg_HEI;//宽高比
 if(oldImg_WID > KCompressibilityFactor || oldImg_HEI > KCompressibilityFactor){
 //超过设置的最大宽度 先判断那个边最长
 if(oldImg_WID > oldImg_HEI){
  //宽度大于高度
  oldImg_HEI = (KCompressibilityFactor * oldImg_HEI)/oldImg_WID;
  oldImg_WID = KCompressibilityFactor;
 }else{
  oldImg_WID = (KCompressibilityFactor * oldImg_WID)/oldImg_HEI;
  oldImg_HEI = KCompressibilityFactor;
 }
 }
 UIImage *newImg = [self imageWithImage:image scaledToSize:CGSizeMake(oldImg_WID, oldImg_HEI)];
 NSData *dJpeg = nil;
 if (UIImagePNGRepresentation(newImg)==nil) {
 dJpeg = UIImageJPEGRepresentation(newImg, 0.5);
 }else{
 dJpeg = UIImagePNGRepresentation(newImg);
 }
 return [UIImage imageWithData:dJpeg];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
 UIGraphicsBeginImageContext(newSize);
 [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
 UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 return newImage;
}

@end
