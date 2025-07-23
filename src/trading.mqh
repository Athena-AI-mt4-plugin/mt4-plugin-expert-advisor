//+------------------------------------------------------------------+
//|                                                      trading.mqh |
//|                                                    Omid Varahram |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Omid Varahram"
#property link      ""
#property strict

#include "utils.mqh"
#include "types.mqh"
#include "bridge.mqh"

void HandleExecuteTrade(string json)
{
   string symbol = FindStringInJson(json, "symbol");
   string orderType = FindStringInJson(json, "orderType");
   double lot = FindDoubleInJson(json, "lot");
   double price = FindDoubleInJson(json, "price");
   double stopLoss = FindDoubleInJson(json, "stopLoss");
   double takeProfit = FindDoubleInJson(json, "takeProfit");
   string comment = FindStringInJson(json, "comment");
   string requestId = FindStringInJson(json, "requestId");

   int op = OP_BUY;
   double execPrice = Ask;
   if(orderType == ORDER_TYPE_MARKET)      { op = OP_BUY; execPrice = Ask; }
   else if(orderType == ORDER_TYPE_BUY_LIMIT)  { op = OP_BUYLIMIT; execPrice = price; }
   else if(orderType == ORDER_TYPE_SELL_LIMIT) { op = OP_SELLLIMIT; execPrice = price; }
   else if(orderType == ORDER_TYPE_BUY_STOP)   { op = OP_BUYSTOP; execPrice = price; }
   else if(orderType == ORDER_TYPE_SELL_STOP)  { op = OP_SELLSTOP; execPrice = price; }

   int ticket = OrderSend(symbol, op, lot, execPrice, 3, stopLoss, takeProfit, comment, 12345, 0, clrGreen);
   if(ticket < 0) {
      int err = GetLastError();
      Print("❌ OrderSend failed: ", err);
      string resp = StringConcatenate(
         "{\"type\":\"", EVT_ORDER_EXECUTION_RESULT, "\",",
         "\"payload\":{",
         "\"requestId\":\"", requestId, "\",",
         "\"success\":false,",
         "\"errorCode\":", err, ",",
         "\"errorMessage\":\"OrderSend failed\"}}"
      );
      Bridge_Send(resp);
   } else {
      Print("✅ Trade executed. Ticket: ", ticket);
      string resp = StringConcatenate(
         "{\"type\":\"", EVT_ORDER_EXECUTION_RESULT, "\",",
         "\"payload\":{",
         "\"requestId\":\"", requestId, "\",",
         "\"success\":true,",
         "\"ticket\":", ticket, "}}"
      );
      Bridge_Send(resp);
   }
}

void HandleModifyTrade(string json)
{
   int ticket = (int)FindDoubleInJson(json, "ticket");
   double stopLoss = FindDoubleInJson(json, "stopLoss");
   double takeProfit = FindDoubleInJson(json, "takeProfit");
   string requestId = FindStringInJson(json, "requestId");
   bool ok = false; int err = 0;

   if(OrderSelect(ticket, SELECT_BY_TICKET))
   {
      ok = OrderModify(ticket, OrderOpenPrice(), stopLoss, takeProfit, 0, clrNONE);
      err = GetLastError();
   }
   else
      err = GetLastError();

   if(!ok)
   {
      Print("❌ OrderModify failed: ", err);
      string resp = StringConcatenate(
         "{\"type\":\"", EVT_MODIFY_RESULT, "\",",
         "\"payload\":{",
         "\"requestId\":\"", requestId, "\",",
         "\"success\":false,",
         "\"errorCode\":", err, ",",
         "\"errorMessage\":\"OrderModify failed\"}}"
      );
      Bridge_Send(resp);
   }
   else
   {
      Print("✅ Order modified. Ticket: ", ticket);
      string resp = StringConcatenate(
         "{\"type\":\"", EVT_MODIFY_RESULT, "\",",
         "\"payload\":{",
         "\"requestId\":\"", requestId, "\",",
         "\"success\":true,",
         "\"ticket\":", ticket, "}}"
      );
      Bridge_Send(resp);
   }
}

void HandleCloseTrade(string json)
{
   int ticket = (int)FindDoubleInJson(json, "ticket");
   string requestId = FindStringInJson(json, "requestId");
   bool closed = false; int err = 0;
   double lots = 0; int op = 0; double closePrice = 0;

   if(OrderSelect(ticket, SELECT_BY_TICKET))
   {
      lots = OrderLots();
      op = OrderType();
      closePrice = (op == OP_BUY) ? Bid : Ask;
      closed = OrderClose(ticket, lots, closePrice, 3, clrRed);
      err = GetLastError();
   }
   else
      err = GetLastError();

   if(!closed)
   {
      Print("❌ OrderClose failed: ", err);
      string resp = StringConcatenate(
         "{\"type\":\"", EVT_CLOSE_RESULT, "\",",
         "\"payload\":{",
         "\"requestId\":\"", requestId, "\",",
         "\"success\":false,",
         "\"errorCode\":", err, ",",
         "\"errorMessage\":\"OrderClose failed\"}}"
      );
      Bridge_Send(resp);
   }
   else
   {
      Print("✅ Order closed. Ticket: ", ticket);
      string resp = StringConcatenate(
         "{\"type\":\"", EVT_CLOSE_RESULT, "\",",
         "\"payload\":{",
         "\"requestId\":\"", requestId, "\",",
         "\"success\":true,",
         "\"ticket\":", ticket, "}}"
      );
      Bridge_Send(resp);
   }
}
