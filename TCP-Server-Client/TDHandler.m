//
//  TDHandler.m
//  TCP-Server-Client
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import "TDHandler.h"

@implementation TDHandler

- (IBAction)startServerClicked:(NSButton *)sender {
    objServerThread = [[TDServerThread alloc]init];
    [objServerThread initializeServer:dataRecevedText];
    [objServerThread start];
    
}

- (IBAction)stopServerClicked:(NSButton *)sender {
    [objServerThread stopServer];
}

- (IBAction)ConnectToServerClicked:(NSButton *)sender {
    objClientThread = [[TDClientThread alloc]init];
    [objClientThread initializeClient];
    [objClientThread start];
    
}

- (IBAction)DisconnectFromServerClicked:(NSButton *)sender {
    [objClientThread disconnectFromServer];
}

- (IBAction)sendDataClicked:(NSButton *)sender {
    [objClientThread sendTCPDataPacket:[[dataSendText stringValue] UTF8String]];
    
}

@end
