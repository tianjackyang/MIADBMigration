//
//  FMDBMigration.m
//  MIACorpUMSApp
//
//  Created by 杨鹏 on 16/3/19.
//  Copyright © 2016年 上海名扬科技股份有限公司. All rights reserved.
//

#import "FMDBMigration.h"

@implementation FMDBMigration

+  (NSBundle *)FMDBMigrationsBundle
{
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Migrations" ofType:@"bundle"]];
}

+ (NSString *)FMDBMigrationsPath {
    return [[NSBundle mainBundle] pathForResource:@"Migrations" ofType:@"bundle"];
}

+ (NSArray *)getAllSQLFileNames:(NSString *)path
{
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    NSMutableArray *sqlfiles = [NSMutableArray array];
    for (NSString *name in files) {
        if ([[name pathExtension] isEqualToString:@"sql"]) {
            [sqlfiles addObject:name];
        }
    }
    
    return sqlfiles;
}

+ (NSArray *)getAllSQLFilePaths:(NSString *)path {
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    NSMutableArray *sqlfiles = [NSMutableArray array];
    for (NSString *name in files) {
        if ([[name pathExtension] isEqualToString:@"sql"]) {
            
            [sqlfiles addObject:[NSString stringWithFormat:@"%@/%@", path, name]];
        }
    }
    
    return sqlfiles;
}

+ (void)CreateMigrations:(NSString *)dbpath {
    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:dbpath  migrationsBundle:[FMDBMigration FMDBMigrationsBundle]];
    
    if (manager.needsMigration)
    {
        BOOL resultState = NO;
        NSError *error = nil;
        if (!manager.hasMigrationsTable) {
            resultState = [manager createMigrationsTable:&error];
        }
        
        resultState = [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];//迁移函数
        
        DDLogInfo(@"Has `schema_migrations` table?: %@", manager.hasMigrationsTable ? @"YES" : @"NO");
        DDLogInfo(@"Origin Version: %llu", manager.originVersion);
        DDLogInfo(@"Current version: %llu", manager.currentVersion);
        DDLogInfo(@"All migrations: %@", manager.migrations);
        DDLogInfo(@"Applied versions: %@", manager.appliedVersions);
        DDLogInfo(@"Pending versions: %@", manager.pendingVersions);
    }
}

@end