//+------------------------------------------------------------------+
//|                                               AthenaBridgeEA.mq4 |
//|                                                    Omid Varahram |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Omid Varahram"
#property link      ""
#property strict

#include "bridge.mqh"
#include "types.mqh"
#include "utils.mqh"
#include "events.mqh"
#include "trading.mqh"
#include "account.mqh"
#include "positions.mqh"
#include "historical.mqh"

input int TimerSeconds = 1; // Minimum polling interval for Node.js events

int OnInit()
{
   Print("🔌 AthenaBridgeEA initialized.");
   EventSetTimer(TimerSeconds);
   FireAccountUpdateEvent();
   FireAllOpenPositions();
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   Print("🛑 AthenaBridgeEA stopped.");
}

// OnTimer: Send status updates, and also poll for inbound Node.js events
void OnTimer()
{
   // 1. Fire outbound events
   FirePriceChange();
   FireAccountUpdateEvent();
   FireAllOpenPositions();

   // 2. Listen for inbound events from Node.js
   AthenaBridge_PollInboundEvents();
}

// OnTick: Listen for inbound events from Node.js (as soon as a tick comes in)
void OnTick()
{
   AthenaBridge_PollInboundEvents();
}

// Poll for all buffered messages from Node.js
void AthenaBridge_PollInboundEvents()
{
   while (true)
   {
      string response = Bridge_Receive();
      if (StringLen(response) == 0 || StringFind(response, "error") >= 0)
         break;
      Print("📥 Received from Node: ", response);
      HandleInboundEvent(response);
   }
}
