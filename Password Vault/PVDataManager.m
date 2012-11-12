//
//  PVDataManager.m
//  Password Vault
//
//  Created by Brian Leibreich on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PVDataManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

@interface PVDataManager ()
@property (nonatomic, strong) NSString *databaseName;
@end

@implementation PVDataManager
@synthesize databaseName = databaseName_;

+(PVDataManager *)sharedDataManager{
    static PVDataManager *sharedDataManager = nil;
    @synchronized(self){
        if(sharedDataManager == nil)
            sharedDataManager = [[PVDataManager alloc] init];
    }
    return sharedDataManager;
}

-(id)init{
    if((self = [super init])){
        databaseName_ = @"password.db";
        [self copyDatabaseIfNeeded];
    }
    return self;
}

-(NSString *)databasePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:databaseName_];
}

#pragma mark - Utility Methods
-(void) copyDatabaseIfNeeded{
    // Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	if(![fileManager fileExistsAtPath:[self databasePath]]){    
        // Get the path to the database in the application package
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName_];
        
        // Copy the database from the package to the users filesystem
		[fileManager copyItemAtPath:databasePathFromApp toPath:[self databasePath] error:nil];
        
    }
    else
		{
		}
}

-(BOOL) doPasswordsExist{
	FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	FMResultSet *results = [db executeQuery:@"SELECT * FROM password"];
	BOOL res = [results next];
	[results close];
	[db close];
	return res;
}

-(void) insertPassword:(NSString *)password{
	FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	NSString *command = [[NSString alloc] initWithFormat:@"INSERT INTO password(password) VALUES ('%@')", password];
	[db executeUpdate:command];
	[db close];
}

-(NSString *)getPassword:(NSString *)password{
	NSString *pass = @"";
	FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	NSString *command = [[NSString alloc] initWithFormat:@"SELECT * FROM password WHERE password='%@'", password];
	FMResultSet *results = [db executeQuery:command];
	if([results next]){
		pass = [results stringForColumn:@"password"];
	}
	[results close];
	[db close];
	return pass;
}

-(NSArray *)getSitesList{
	NSMutableArray *sites = [[NSMutableArray alloc] init];
	FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	NSString *command = [[NSString alloc] initWithFormat:@"SELECT url FROM sites"];
	FMResultSet *results = [db executeQuery:command];
	while([results next]){
		[sites addObject:[results stringForColumn:@"url"]];
	}
	[results close];
	[db close];
	return (NSArray *)sites;
}

-(void)insertSite:(NSString *)url withUser:(NSString *)username withPass:(NSString *)password{
	FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	NSString *command = [[NSString alloc] initWithFormat:@"INSERT INTO sites(url, username, password) VALUES ('%@', '%@', '%@')", url, username, password];
	[db executeUpdate:command];
	[db close];
}

-(NSArray *)getSiteDetails:(NSString *)siteName{
	NSMutableArray *sites = [[NSMutableArray alloc] init];
	FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	NSString *command = [[NSString alloc] initWithFormat:@"SELECT url, username, password FROM sites WHERE url='%@'", siteName];
	FMResultSet *results = [db executeQuery:command];
	if([results next]){
		[sites addObject:[results stringForColumn:@"url"]];
		[sites addObject:[results stringForColumn:@"username"]];
		[sites addObject:[results stringForColumn:@"password"]];
	}
	[results close];
	[db close];
	return (NSArray *)sites;
}

-(void)removeSite:(NSString *)siteName{
	FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	NSString *command = [[NSString alloc] initWithFormat:@"DELETE FROM sites WHERE url='%@'", siteName];
	[db executeUpdate:command];
	[db close];

}

-(void)createChatUser:(NSString *)username{
    FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	NSString *command = [[NSString alloc] initWithFormat:@"INSERT INTO chat_user(username) VALUES ('%@')", username];
	[db executeUpdate:command];
	[db close];
}

-(BOOL)chatUserExist{
    FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	FMResultSet *results = [db executeQuery:@"SELECT * FROM chat_user"];
	BOOL res = [results next];
	[results close];
	[db close];
	return res;
}

-(NSString *)getChatUser{
    NSString *user = @"";
	FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
	NSString *command = [[NSString alloc] initWithFormat:@"SELECT username FROM chat_user"];
	FMResultSet *results = [db executeQuery:command];
	if([results next]){
		user = [results stringForColumn:@"username"];
	}
	[results close];
	[db close];
	return user;
}

-(void)addMessageSender:(NSString *)sender recipient:(NSString *)receipient otherMember:(NSString *)other message:(NSString *)message time:(NSString *)time{
    NSString *command = [[NSString alloc] initWithFormat:@"INSERT INTO conversations(sender, recipient, other_member, message, timestamp) VALUES ('%@', '%@', '%@', '%@', '%@')", sender, receipient, other, message, time];
    NSLog(@"%@", command);
    FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
	[db open];
    [db executeUpdate:command];
    [db close];
}

-(NSMutableArray *)getConvoList{
    FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
    [db open];
    NSString *command = [[NSString alloc] initWithFormat:@"SELECT DISTINCT other_member FROM conversations"];
    FMResultSet *results = [db executeQuery:command];
    NSMutableArray *convos = [[NSMutableArray alloc] init];
    NSMutableArray *users = [[NSMutableArray alloc] init];
    while([results next]){
        [users addObject:[results stringForColumn:@"other_member"]];
    }
    [results close];
    
    for(NSString *user in users){
        command = [[NSString alloc] initWithFormat:@"SELECT * FROM conversations WHERE other_member='%@' ORDER BY _id DESC", user];
        results = [db executeQuery:command];
        if([results next]){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[results stringForColumn:@"sender"] forKey:@"sender"];
            [dict setObject:[results stringForColumn:@"recipient"] forKey:@"recipient"];
            [dict setObject:[results stringForColumn:@"other_member"] forKey:@"other_member"];
            [dict setObject:[results stringForColumn:@"message"] forKey:@"message"];
            [dict setObject:[results stringForColumn:@"timestamp"] forKey:@"timestamp"];
            [convos addObject:dict];
        }
    }
    [results close];
    [db close];
    NSLog(@"%@", convos);
    return convos;
}

-(NSMutableArray *)getConversation:(NSString *)other{
    NSString *command = [[NSString alloc] initWithFormat:@"SELECT * FROM conversations WHERE other_member='%@' ORDER BY _id ASC", other];
    NSMutableArray *convo = [[NSMutableArray alloc] init];
    FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:command];
    while([results next]){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[results stringForColumn:@"sender"] forKey:@"sender"];
        [dict setObject:[results stringForColumn:@"recipient"] forKey:@"recipient"];
        [dict setObject:[results stringForColumn:@"other_member"] forKey:@"other_member"];
        [dict setObject:[results stringForColumn:@"message"] forKey:@"message"];
        [dict setObject:[results stringForColumn:@"timestamp"] forKey:@"time"];
        [convo addObject:dict];
    }
    [results close];
    [db close];
    return convo;
}

-(void)deleteConvo:(NSString *)otherUser{
    NSString *command = [[NSString alloc] initWithFormat:@"DELETE FROM conversations WHERE other_member='%@'", otherUser];
    FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
    [db open];
    [db executeUpdate:command];
    [db close];
}

-(int)getLastPost{
    int time = 0;
    NSString *command = [[NSString alloc] initWithFormat:@"SELECT * FROM time_interval"];
    FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:command];
    if([results next]){
        time = [results intForColumn:@"last_time"];
    }
    [results close];
    [db close];
    return time;
}

-(void)setLastPost:(int)timer{
    NSString *command = [[NSString alloc] initWithFormat:@"DELETE FROM time_interval"];
    NSString *inCom = [[NSString alloc] initWithFormat:@"INSERT INTO time_interval(last_time) VALUES ('%d')", timer];
    FMDatabase *db = [[FMDatabase alloc] initWithPath:[self databasePath]];
    [db open];
    NSLog(@"DELETE: %d", [db executeUpdate:command]);
    NSLog(@"INSERT: %d", [db executeUpdate:inCom]);
    [db close];
}

@end
