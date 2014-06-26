//
//  ViewController.m
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import "ViewController.h"
#import "chatC.h"
#import "ChatS.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    chatClient = [[chatC alloc] init];
    chatClient.delegate = self;
    [chatClient buildClientChat];
    chatRoomTV.text = @"";
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [chatClient sendDataToSerVer:textField.text];
    [textField becomeFirstResponder];
    return YES;
}

- (void)recvData:(NSString *)recvStr
{
    chatRoomTV.text = [NSString stringWithFormat:@"%@\n%@", chatRoomTV.text, recvStr];
}



@end
