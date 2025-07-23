//+------------------------------------------------------------------+
//|                                                        utils.mqh |
//|                                                    Omid Varahram |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Omid Varahram"
#property link      ""
#property strict

string FormatDouble(double val, int digits)
{
   string s = DoubleToString(val, digits);
   int dot = StringFind(s, ".");
   if(dot < 0) {
      s += ".";
      for(int j=0;j<digits;j++) s += "0";
   } else {
      int after = StringLen(s) - (dot+1);
      for(int k=after; k<digits; k++) s += "0";
   }
   return s;
}

string GetIsoTime(datetime t=0)
{
   if(t == 0) t = TimeCurrent();
   return TimeToString(t, TIME_DATE|TIME_SECONDS);
}

string FindStringInJson(string json, string key)
{
   int idx = StringFind(json, StringFormat("\"%s\":\"", key));
   if(idx<0) return "";
   int start = idx + StringLen(key) + 4;
   int end = StringFind(json, "\"", start);
   if(end<0) return "";
   return StringSubstr(json, start, end-start);
}

double FindDoubleInJson(string json, string key)
{
   int idx = StringFind(json, StringFormat("\"%s\":", key));
   if(idx<0) return 0;
   int start = idx + StringLen(key) + 3;
   int end = StringFind(json, ",", start);
   if(end < 0) end = StringFind(json, "}", start);
   if(end < 0) return 0;
   string num = StringSubstr(json, start, end-start);
   return StrToDouble(num);
}

string GenRequestId()
{
   return IntegerToString(GetTickCount()) + "_" + IntegerToString(TimeLocal());
}
