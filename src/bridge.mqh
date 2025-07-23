//+------------------------------------------------------------------+
//|                                                       bridge.mqh |
//|                                                    Omid Varahram |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Omid Varahram"
#property link      ""
#property strict

#import "EventBridgeDLL.dll"
   bool SendBridgeMessage(string message);
   string ReceiveBridgeMessage();
#import

bool Bridge_Send(string json) { return SendBridgeMessage(json); }
string Bridge_Receive() { return ReceiveBridgeMessage(); }


