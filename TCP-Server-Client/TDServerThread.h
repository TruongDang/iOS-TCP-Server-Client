//
//  TDServerThread.h
//  TCP-Server-Client
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#import <Cocoa/Cocoa.h>

@interface TDServerThread : NSThread {
    CFSocketRef objServer;
}

-(void)initializeServer:(NSTextField *) textField;

-(void)main;

-(void)stopServer;
@end
