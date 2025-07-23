//+------------------------------------------------------------------+
//|                                                       account.mqh |
//|                                                    Omid Varahram |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Omid Varahram"
#property link      ""
#property strict

#include "events.mqh"

void FireAccountUpdateEvent()
{
   FireAccountUpdate();
}
