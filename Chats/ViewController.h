//
//  ViewController.h
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatC.h"

@interface ViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, ChatClientDelegate>
{
    IBOutlet UITextView *chatRoomTV;
    IBOutlet UITextField *chatCEditTF;
    
    chatC *chatClient;
    
}
@end
