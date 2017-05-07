//
//  TDClientThread.m
//  TCP-Server-Client
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import "TDClientThread.h"

@implementation TDClientThread

void TCPClientCallBackHandler(CFSocketRef socketRef, CFSocketCallBackType callBackType, CFDataRef address, const void *data, void *info){
    switch (callBackType) {
        case kCFSocketNoCallBack: {
            NSLog(@"kCFSocketNoCallBack");
            break;
        }
            
        case kCFSocketReadCallBack: {
            char buf[1];
            read(CFSocketGetNative(socketRef), &buf, 1);
            if ((int)*buf == 2) {
                TDClientThread *objClientPrt = (__bridge TDClientThread*)info;
                char *recvData = [objClientPrt readData];
                free(recvData);
            }
            break;
        }
            
        case kCFSocketAcceptCallBack: {
            NSLog(@"kCFSocketAcceptCallBack");
            break;
        }
            
        case kCFSocketDataCallBack: {
            NSLog(@"kCFSocketDataCallBack");
            break;
        }
            
        case kCFSocketConnectCallBack: {
            if (data) {
                CFSocketIsValid(socketRef);
                CFRelease(socketRef);
                CFRunLoopStop(CFRunLoopGetCurrent());
                
            }else{
                NSLog(@"Client connected to server.");
            }
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

-(void)initializeClient{
    CFSocketContext socketContext = {0, (__bridge void *)(self), NULL, NULL, NULL};
    objClient = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, TCPClientCallBackHandler, &socketContext);
    
    struct sockaddr_in socketAddress;
    memset(&socketAddress, 0, sizeof(socketAddress));
    socketAddress.sin_len = sizeof(socketAddress);
    socketAddress.sin_family = AF_INET;
    socketAddress.sin_port = htons(6658);
    inet_pton(AF_INET, "127.0.0.1", &socketAddress);
    CFDataRef dataRef = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&socketAddress, sizeof(socketAddress));
    CFSocketConnectToAddress(objClient, dataRef, -1);
    CFRelease(dataRef);
}

-(void)initializeNative:(CFSocketNativeHandle)nativeSocket{
    CFSocketContext socketContext = {0, (__bridge void *)(self), NULL, NULL, NULL};
    objClient = CFSocketCreateWithNative(kCFAllocatorDefault, nativeSocket, kCFSocketReadCallBack, TCPClientCallBackHandler, &socketContext);
}

-(void)main{
    
    CFRunLoopSourceRef runLoopsourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, objClient, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopsourceRef, kCFRunLoopDefaultMode);
    CFRelease(runLoopsourceRef);
    CFRunLoopRun();
}

-(void)disconnectFromServer{
    CFSocketIsValid(objClient);
    CFRelease(objClient);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

-(void)sendTCPDataPacket:(const char*)data{
    int initialize[1] = {2};
    int separator[1] = {4};
    int dataLength = (int)strlen(data);
    int targetLength = snprintf(NULL, 0, "%d", dataLength);
    char *dataLengthChar = malloc(targetLength+1);
    snprintf(dataLengthChar, targetLength+1, "%d",  dataLength);
   
    int eleCount = (int)strlen(dataLengthChar);
    int *sizeBuff = (int *)malloc(eleCount*sizeof(int));
    for (int counter = 0; counter < eleCount; counter++) {
        sizeBuff[counter] = (int)dataLengthChar[counter];
    }
    int packetLength = 1+1+eleCount+(int)strlen(data);
    UInt8 *packet = (UInt8 *)malloc(packetLength *sizeof(UInt8));
    memcpy(&packet[0], initialize, 1);
    for (int counter = 0; counter < eleCount; counter++) {
        memcpy(&packet[counter +1], &sizeBuff[counter], 1);

    }
    memcpy(&packet[0+1+eleCount], separator, 1);
    memcpy(&packet[0+1+eleCount+1], data, strlen(data));
    CFDataRef dataRef = CFDataCreate(kCFAllocatorDefault, packet, packetLength);
    CFSocketSendData(objClient, NULL, dataRef, -1);
    free(packet);
    free(sizeBuff);
    free(dataLengthChar);
    CFRelease(dataRef);
    
}

-(char *)readData {
    char *dataBuff;
    NSMutableString *buffLength = [[NSMutableString alloc]init];
    char buf[1];
    read(CFSocketGetNative(objClient), &buf, 1);
    while ((int) *buf != 4) {
        [buffLength appendFormat:@"%c",(char)(int)*buf];
        read(CFSocketGetNative(objClient), &buf, 1);
    }
    int datalength = [[buffLength stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet]invertedSet]]intValue];
    dataBuff = (char*)malloc(datalength*sizeof(char));
    ssize_t byteRead = 0;
    ssize_t byteOffset = 0;
    while (byteOffset < datalength) {
        byteRead = read(CFSocketGetNative(objClient), dataBuff+byteOffset, 50);
        byteOffset += byteRead;
    }
    return dataBuff;
}

@end







