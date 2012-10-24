//
//  PVDataManager.h
//  Password Vault
//
//  Created by Brian Leibreich on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVDataManager : NSObject
+(PVDataManager *)sharedDataManager;
-(BOOL) doPasswordsExist;
-(void) insertPassword:(NSString *)password;
-(NSString *)getPassword:(NSString *)password;
-(NSArray *)getSitesList;
-(void)insertSite:(NSString *)url withUser:(NSString *)username withPass:(NSString *)password;
-(NSArray *)getSiteDetails:(NSString *)siteName;
-(void)removeSite:(NSString *)siteName;
-(void)createChatUser:(NSString *)username;
-(BOOL)chatUserExist;
-(NSString *)getChatUser;
-(void)addMessageSender:(NSString *)sender recipient:(NSString *)receipient otherMember:(NSString *)other message:(NSString *)message time:(NSString *)time;
-(NSMutableArray *)getConvoList;
-(NSMutableArray *)getConversation:(NSString *)other;
@end
