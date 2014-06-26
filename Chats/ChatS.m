//
//  ChatS.m
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import "ChatS.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@implementation ChatS

fd_set allfd;//存放所有链接的客户对应的描述符号
int maxfd=-1;//存放链接客户中得最大描述符号

fd_set fds;//存放被监视的描述符号
int maxfds=-1;//存放被监视的最大描述符号

int serverfd;

+ (void)chatS
{
	/*1，建立服务器 socket*/
	serverfd=socket(AF_INET,SOCK_STREAM,0);
	if(serverfd==-1) printf("socket err:%m\n"),exit(-1);
	printf("服务器建立成功\n");
	/*2.绑定地址 */
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(9019);
	addr.sin_addr.s_addr=inet_addr("192.168.1.3");
	int r=bind(serverfd,(struct sockaddr*)&addr,sizeof(addr));
	if(r==-1) printf("bind err:%m\n"),exit(-1);
	printf("地址绑定成功!\n");
	/*3.º‡Ã˝*/
	r=listen(serverfd,10);
	if(r==-1) printf("listen err:%m\n"),exit(-1);
	printf("监听成功，可以聊天!\n");
	
	while(1)
	{
		/*4.开始使用select监视服务器描述符号于客户描述符号*/
		//4.1.初始化监听描述符号集合
		FD_ZERO(&fds);
		maxfds=-1;
		//4.2.添加服务器描述符号到监视集合
		FD_SET(serverfd,&fds);
		maxfds=maxfds<serverfd?serverfd:maxfds;
		//4.3.添加链接客户的描述符号到监视集合
		int i;
		for(i=0;i<=maxfd;i++)
		{
			if(FD_ISSET(i,&allfd))
			{
				FD_SET(i,&fds);
				maxfds=maxfds<i?i:maxfds;
			}
		}
		//4.4.开始监视描述符号结合的描述符号改变
		r=select(maxfds+1,&fds,0,0,0);
		if(r==-1)
		{
			printf("select 失败!\n");
			break;
		}
		//fds
		//
		//4.5.
		if(FD_ISSET(serverfd,&fds))
		{
			printf("有人链接上了!\n");
			int fd=accept(serverfd,0,0);
			if(fd==-1)
			{
				printf("accept 失败\n");
				break;
			}
			maxfd=maxfd<fd?fd:maxfd;
			FD_SET(fd,&allfd);
		}
		//4.6. 接收数据
		char buf[256];
		for(i=0;i<=maxfd;i++)
		{
			if(FD_ISSET(i,&allfd) && FD_ISSET(i,&fds))
			{
				//4.7.有数据来了
				r=recv(i,buf,255,0);
				if(r<=0)//
				{
					FD_CLR(i,&allfd);
					printf("有人断开了!\n");
				}
				buf[r]='\0';
				printf("有数据%d:%s\n",r,buf);
				//4. 广播数据
				int j;
				for(j=0;j<=maxfd;j++)
				{
					if(FD_ISSET(j,&allfd))
					{
						r = send(j,buf,strlen(buf),0);
                        printf("send::%d\n", r);
					}
				}
			}
			
		}
	}
}

@end
