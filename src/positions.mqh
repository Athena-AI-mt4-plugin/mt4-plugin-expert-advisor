//+------------------------------------------------------------------+
//|                                                    positions.mqh |
//|                                                    Omid Varahram |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Omid Varahram"
#property link      ""
#property strict

#include "events.mqh"

void FireAllOpenPositions()
{
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         string action = (OrderType() == OP_BUY) ? "buy" : "sell";
         FirePositionChange(
            action,
            OrderTicket(),
            OrderLots(),
            OrderOpenPrice(),
            OrderStopLoss(),
            OrderTakeProfit(),
            ""
         );
      }
   }
}
