//
//  FMDBMigration.h
//  MIACorpUMSApp
//
//  Created by 杨鹏 on 16/3/19.
//  Copyright © 2016年 上海名扬科技股份有限公司. All rights reserved.
//

#ifndef FMDBMigration_h
#define FMDBMigration_h

#import <Foundation/Foundation.h>
#import "FMDBMigrationManager.h"


@interface FMDBMigration : NSObject

+ (NSBundle *)FMDBMigrationsBundle;

+ (NSString *)FMDBMigrationsPath;

+ (NSArray *)getAllSQLFileNames:(NSString *)path;

+ (NSArray *)getAllSQLFilePaths:(NSString *)path;

+ (void)CreateMigrations:(NSString *)dbpath;

@end

#endif /* FMDBMigration_h */
