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
        
        NSLog(@"Has `schema_migrations` table?: %@", manager.hasMigrationsTable ? @"YES" : @"NO");
        NSLog(@"Origin Version: %llu", manager.originVersion);
        NSLog(@"Current version: %llu", manager.currentVersion);
        NSLog(@"All migrations: %@", manager.migrations);
        NSLog(@"Applied versions: %@", manager.appliedVersions);
        NSLog(@"Pending versions: %@", manager.pendingVersions);
    }
}

@end