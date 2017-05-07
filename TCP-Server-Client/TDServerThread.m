//
//  TDServerThread.m
//  TCP-Server-Client
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import "TDServerThread.h"
#import "TDClientThread.h"

@implementation TDServerThread

void TCPServerCallBackHandler(CFSocketRef socketRef, CFSocketCallBackType callBackType, CFDataRef address, const void *data, void *info){
    switch (callBackType) {
        case kCFSocketNoCallBack: {
            NSLog(@"kCFSocketNoCallBack");
            break;
        }
            
        case kCFSocketReadCallBack: {
            NSLog(@"kCFSocketReadCallBack");
            break;
        }
            
        case kCFSocketAcceptCallBack: {
            TDClientThread *objAcceptedSocket = [[TDClientThread  alloc]init];
            [objAcceptedSocket initializeNative: *(CFSocketNativeHandle *)data];
            break;
        }
            
        case kCFSocketDataCallBack: {
            NSLog(@"kCFSocketDataCallBack");
            break;
        }
            
        case kCFSocketConnectCallBack: {
            NSLog(@"kCFSocketConnectCallBack");
            break;
        }
            
        case kCFSocketWriteCallBack: {
            NSLog(@"CFSocketWriteCallBack");
            break;
        }
            
        default:
            break;
    }
}

-(void)initializeServer:(NSTextField *) textField{
    CFSocketContext socketContext = {0, (__bridge void *)(self), NULL, NULL, NULL};
    objServer = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, TCPServerCallBackHandler, &socketContext);
    
    struct sockaddr_in socketAddress;
    memset(&socketAddress, 0, sizeof(socketAddress));
    socketAddress.sin_len = sizeof(socketAddress);
    socketAddress.sin_family = AF_INET;
    socketAddress.sin_port = htons(6658);
    socketAddress.sin_addr.s_addr = INADDR_ANY;
    
    CFDataRef dataRef = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&socketAddress, sizeof(socketAddress));
    CFSocketSetAddress(objServer, dataRef);
    CFRelease(dataRef);
    
}

-(void)main{

    CFRunLoopSourceRef runLoopsourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, objServer, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopsourceRef, kCFRunLoopDefaultMode);
    CFRelease(runLoopsourceRef);
    CFRunLoopRun();
}

-(void)stopServer{
    CFSocketIsValid(objServer);
    CFRelease(objServer);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
