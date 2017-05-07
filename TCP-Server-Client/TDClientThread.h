//
//  TDClientThread.h
//  TCP-Server-Client
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface TDClientThread : NSThread{
    CFSocketRef objClient;
}

-(void)initializeClient;

-(void)initializeNative:(CFSocketNativeHandle)nativeSocket;
-(void)main;

-(void)disconnectFromServer;

-(void)sendTCPDataPacket:(const char*)data;
-(char*)readData;
@end
