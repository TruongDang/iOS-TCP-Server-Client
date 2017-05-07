//
//  TDHandler.h
//  TCP-Server-Client
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "TDClientThread.h"
#import "TDServerThread.h"
@interface TDHandler : NSObject{
    TDServerThread *objServerThread;
    TDClientThread *objClientThread;
    __weak IBOutlet NSTextField *dataSendText;
    __weak IBOutlet NSTextField *dataRecevedText;

}

@end
