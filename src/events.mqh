//+------------------------------------------------------------------+
//|                                                       events.mqh |
//|                                                    Omid Varahram |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Omid Varahram"
#property link      "https://www.mql5.com"
#property strict


#include "bridge.mqh"
#include "types.mqh"
#include "utils.mqh"
#include "trading.mqh"
#include "historical.mqh"

// Outbound events (EA -> Node.js)
void FirePriceChange()
{
   string json = StringConcatenate(
      "{\"type\":\"", EVT_PRICE_CHANGE, "\",",
      "\"payload\":{",
      "\"symbol\":\"", Symbol(), "\",",
      "\"bid\":", FormatDouble(Bid, Digits), ",",
      "\"ask\":", FormatDouble(Ask, Digits), ",",
      "\"open\":", FormatDouble(iOpen(Symbol(), 0, 0), Digits), ",",
      "\"high\":", FormatDouble(iHigh(Symbol(), 0, 0), Digits), ",",
      "\"low\":", FormatDouble(iLow(Symbol(), 0, 0), Digits), ",",
      "\"close\":", FormatDouble(iClose(Symbol(), 0, 0), Digits), ",",
      "\"volume\":", FormatDouble(iVolume(Symbol(), 0, 0), 0), ",",
      "\"time\":\"", GetIsoTime(), "\"",
      "}}"
   );
   Bridge_Send(json);
}

void FirePositionChange(string action, int ticket, double lot, double openPrice, double stopLoss, double takeProfit, string reason="")
{
   string json = StringConcatenate(
      "{\"type\":\"", EVT_POSITION_CHANGE, "\",",
      "\"payload\":{",
      "\"action\":\"", action, "\",",
      "\"ticket\":", ticket, ",",
      "\"symbol\":\"", Symbol(), "\",",
      "\"lot\":", FormatDouble(lot, 2), ",",
      "\"openPrice\":", FormatDouble(openPrice, Digits), ",",
      "\"stopLoss\":", FormatDouble(stopLoss, Digits), ",",
      "\"takeProfit\":", FormatDouble(takeProfit, Digits), ",",
      "\"time\":\"", GetIsoTime(), "\"",
      (StringLen(reason)>0 ? StringConcatenate(",\"reason\":\"", reason, "\"") : ""),
      "}}"
   );
   Bridge_Send(json);
}

void FireAccountUpdate()
{
   string json = StringConcatenate(
      "{\"type\":\"", EVT_ACCOUNT_UPDATE, "\",",
      "\"payload\":{",
      "\"balance\":", FormatDouble(AccountBalance(),2), ",",
      "\"equity\":", FormatDouble(AccountEquity(),2), ",",
      "\"freeMargin\":", FormatDouble(AccountFreeMargin(),2), ",",
      "\"marginLevel\":", (AccountMargin() > 0 ? FormatDouble(AccountEquity() / AccountMargin() * 100, 2) : "0.00"), ",",
      "\"currency\":\"", AccountCurrency(), "\",",
      "\"leverage\":", AccountLeverage(),
      "}}"
   );
   Bridge_Send(json);
}

// Inbound events (Node.js -> EA)
void HandleInboundEvent(string json)
{
   if(StringFind(json, EVT_EXECUTE_TRADE) >= 0)
      HandleExecuteTrade(json);
   else if(StringFind(json, EVT_MODIFY_TRADE) >= 0)
      HandleModifyTrade(json);
   else if(StringFind(json, EVT_CLOSE_TRADE) >= 0)
      HandleCloseTrade(json);
   else if(StringFind(json, EVT_HISTORICAL_DATA_REQUEST) >= 0)
      HandleHistoricalDataRequest(json);
}
