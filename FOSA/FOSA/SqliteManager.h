//
//  SqliteManager.h
//  FOSA
//
//  Created by hs on 2019/11/11.
//  Copyright © 2019 hs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
NS_ASSUME_NONNULL_BEGIN

@interface SqliteManager : NSObject

+(sqlite3 *)InitSqliteWithName:(NSString *)databaseName; //根据变量名创建并初始化数据库
+(void)InitTableWithName:(NSString *)CreateSql database:(sqlite3 *)db;    //根据变量名在对应的表中创建并初始化数据表
+(NSString *)getPathWithName:(NSString *)databaseName;
+(void)InsertDataIntoTable:(NSString *)InsertSql database:(sqlite3 *)db;//插入操作
+(sqlite3_stmt *)SelectDataFromTable:(NSString *)SelectSql database:(sqlite3 *)db;//选择操作
+(int)SelectFromTable:(NSString *)SelectSql database:(sqlite3 *)db stmt:(sqlite3_stmt *)stmt;//选择操作
+(void)DeleteDataFromTable:(NSString *)DeleteSql database:(sqlite3 *)db;//删除操作
+(void)UpdataDataFromTable:(NSString *)UpdateSql database:(sqlite3 *)db;//更新操作
+(void)CloseSql:(sqlite3 *)db;

@end

NS_ASSUME_NONNULL_END
