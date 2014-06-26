//
//  chatC.h
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatClientDelegate <NSObject>

@optional

- (void)recvData:(NSString *)recvStr;

@end


@interface chatC : NSObject

@property(nonatomic, strong)id <ChatClientDelegate>delegate;

- (BOOL)buildClientChat;
- (void)sendDataToSerVer:(NSString*)contentS;

@end
