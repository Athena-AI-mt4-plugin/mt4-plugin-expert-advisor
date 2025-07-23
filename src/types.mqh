//+------------------------------------------------------------------+
//|                                                        types.mqh |
//|                                                    Omid Varahram |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Omid Varahram"
#property link      ""
#property strict


#define EVT_PRICE_CHANGE               "mt4_price_change"
#define EVT_POSITION_CHANGE            "mt4_position_change"
#define EVT_ACCOUNT_UPDATE             "mt4_account_update"
#define EVT_EXECUTE_TRADE              "mt4_execute_trade"
#define EVT_MODIFY_TRADE               "mt4_modify_trade"
#define EVT_CLOSE_TRADE                "mt4_close_trade"
#define EVT_HISTORICAL_DATA_REQUEST    "mt4_historical_data_request"
#define EVT_HISTORICAL_DATA_RESPONSE   "mt4_historical_data_response"

// New: confirmation event types for Node.js correlation
#define EVT_ORDER_EXECUTION_RESULT     "order_execution_result"
#define EVT_MODIFY_RESULT              "order_modify_result"
#define EVT_CLOSE_RESULT               "order_close_result"

#define ORDER_TYPE_MARKET     "market"
#define ORDER_TYPE_BUY_LIMIT  "buy_limit"
#define ORDER_TYPE_SELL_LIMIT "sell_limit"
#define ORDER_TYPE_BUY_STOP   "buy_stop"
#define ORDER_TYPE_SELL_STOP  "sell_stop"
