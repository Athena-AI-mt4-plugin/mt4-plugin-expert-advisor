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

   // Remove any trailing dot (e.g. "7255.") which is invalid in JSON
   if (StringLen(s) > 0 && StringSubstr(s, StringLen(s)-1, 1) == ".")
   {
      // Add a zero if digits > 0, else remove the dot entirely
      if (digits > 0)
         s += "0";
      else
         s = StringSubstr(s, 0, StringLen(s)-1);
   }
   // If string has no decimal and digits > 0, add .00 etc.
   int dot = StringFind(s, ".");
   if (dot < 0 && digits > 0)
   {
      s += ".";
      for(int j=0;j<digits;j++) s += "0";
   }
   else if (dot >= 0)
   {
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
