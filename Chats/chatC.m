//
//  chatC.m
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import "chatC.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@implementation chatC

fd_set fdSet;
int fd;


- (BOOL)buildClientChat
{
	/*1 Client Socket*/
    fd = socket(AF_INET,SOCK_STREAM,0);
	if(fd==-1)
    {
        printf("sockett err:%m\n");
        return NO;
    }
	printf("socket ok!\n");
	/*2*/
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(9000);
	addr.sin_addr.s_addr=inet_addr("192.168.1.229");
	int r=connect(fd,(struct sockaddr*)&addr,sizeof addr);
	if(r==-1)
    {
        printf("connect err:%m\n");
        return NO;
    }
	printf("connect ok!\n");
	
    [NSThread detachNewThreadSelector:@selector(recvData) toTarget:self withObject:nil];
    return YES;
}

- (void)sendDataToSerVer:(NSString*)contentS
{
    [NSThread detachNewThreadSelector:@selector(threadSendData:) toTarget:self withObject:contentS];
}

- (void)threadSendData:(NSString*)contentS
{
    const char *contC = [contentS cStringUsingEncoding:NSUTF8StringEncoding];
    int r = send(fd, contC, strlen(contC), 0);
    if (r < 0) {
        NSLog(@"send error");
    }
    NSLog(@"send success!");
}

- (void)recvData
{
    char buf[255];
    int lenght;
    FD_SET(fd, &fdSet);
    
    while (1)
    {
        int r = select(fd+1, &fdSet, 0, 0, 0);
        if (r == -1)
        {
            NSLog(@"select 失败");
            return;
        }
        int tt = FD_ISSET(fd, &fdSet);
        NSLog(@"%d", tt);
        if (tt)
        {
            NSLog(@"---->%d", tt);
            NSLog(@"recv data!!");
            lenght = recv(fd, buf, 255, 0);
            if (lenght <= 0)
            {
                
            }
            else
            {
                buf[lenght] = 0;
                NSString *recvC = [NSString stringWithUTF8String:buf];
                [self performSelectorOnMainThread:@selector(recvDataToView:) withObject:recvC waitUntilDone:YES];
            }
        }
    }
    close(fd);
    printf("recv Over!");
}

- (void)recvDataToView:(NSString*)content
{
    [self.delegate recvData:content];
}

@end
