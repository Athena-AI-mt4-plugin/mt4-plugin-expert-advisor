//+------------------------------------------------------------------+
//|                                                   historical.mqh |
//|                                                    Omid Varahram |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Omid Varahram"
#property link      ""
#property strict

#include "bridge.mqh"
#include "types.mqh"
#include "utils.mqh"

// Handles inbound historical data requests and fires response
void HandleHistoricalDataRequest(string json)
{
   string requestId = FindStringInJson(json, "requestId");
   string symbol = FindStringInJson(json, "symbol");
   string timeframe = FindStringInJson(json, "timeframe");
   int from = (int)FindDoubleInJson(json, "from");
   int to   = (int)FindDoubleInJson(json, "to");
   int tf = PERIOD_M1;
   if(timeframe == "M5") tf = PERIOD_M5;
   else if(timeframe == "M15") tf = PERIOD_M15;
   else if(timeframe == "M30") tf = PERIOD_M30;
   else if(timeframe == "H1") tf = PERIOD_H1;
   else if(timeframe == "H4") tf = PERIOD_H4;
   else if(timeframe == "D1") tf = PERIOD_D1;
   else if(timeframe == "W1") tf = PERIOD_W1;
   else if(timeframe == "MN") tf = PERIOD_MN1;

   int bars = iBars(symbol, tf);
   string barsJson = "[";
   bool first = true;
   for(int i=0;i<bars;i++)
   {
      datetime barTime = iTime(symbol, tf, i);
      if(barTime < from || barTime > to) continue;
      if(!first) barsJson += ",";
      barsJson += StringConcatenate(
         "{\"time\":", barTime,
         ",\"open\":", FormatDouble(iOpen(symbol, tf, i), Digits),
         ",\"high\":", FormatDouble(iHigh(symbol, tf, i), Digits),
         ",\"low\":", FormatDouble(iLow(symbol, tf, i), Digits),
         ",\"close\":", FormatDouble(iClose(symbol, tf, i), Digits),
         ",\"volume\":", FormatDouble(iVolume(symbol, tf, i), 0),
         "}"
      );
      first = false;
   }
   barsJson += "]";

   string response = StringConcatenate(
      "{\"type\":\"", EVT_HISTORICAL_DATA_RESPONSE, "\",",
      "\"payload\":{",
      "\"requestId\":\"", requestId, "\",",
      "\"symbol\":\"", symbol, "\",",
      "\"timeframe\":\"", timeframe, "\",",
      "\"bars\":", barsJson,
      "}}"
   );
   Bridge_Send(response);
}
