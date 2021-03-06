#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 8
#include "CalcLib.mqh"
datetime limittime = D'2022.02.20';
//インジケータ名を使って一括で削除すると楽
string indicator_name = "template";
input int inp_non_judge = 5;//抑止本数
input int p = 1500;//計算バー本数
bool PreBarAlert = true;
bool CurBarAlert = false;
Logic lg;
int OnInit(){
      if(limittime<TimeLocal() || limittime<TimeCurrent()){
      Comment(
         "=================================\n"
         +"使用期間が過ぎています。\n"
         +"インジケータはチャートから削除されました。\n"
         +"================================="
      );
      return 1;
   } //日付制限
   lg.InitLogic("logi_tmp");
   lg.SetBuffer(0);
   lg.non_judge = inp_non_judge;
   //　OBJECT DELTE 検出するための初期化
   //ChartSetInteger(0,CHART_EVENT_OBJECT_DELETE,true);
   // タイマーのセット
   //EventSetTimer(1);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
   //オブジェクトの削除
   ObjectsDeleteAll(0,indicator_name);
   //コメントの削除
   Comment("");
   // タイマーの削除
   //EventKillTimer();
}


int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
   
   //全バー数が100以下の場合OnTick　は動かさない
   if(Bars(_Symbol,_Period)<100)return 0;
   if(Bars-100<p){
      Comment("計算するろうそく足の本数が多すぎます。最大バー数:",Bars-100);
      return 0;
   }
   
   //-----------------------------------------
   //全バー数が100以上の場合初期化関数
   static bool initialized =false;
   if(!initialized){
      //something to do
   
      initialized=true;
   }

   int limit = MathMin(rates_total - IndicatorCounted(), p);
   //再計算関数
   if(limit>2){
      Print("再計算　"+IntegerToString(limit)+"   "+TimeToStr(TimeLocal())); 
      limit = p;
      lg.Reset();
   }
   for(int i=limit-1; i>=0; i--){ 
      int flag=0;
      int base=0;
      flag +=rsicon(i);base++;
      
      lg.SetArrow(i,flag, base);
   }
   if(IndicatorCounted()>0){
      for(int k=p;k<limit+p;k++){
         lg.DeleteArrow(k);
      }   
   }
   
   if(CurBarAlert)lg.AlertCurrentStick();
   if(PreBarAlert)lg.AlertPreviousStick();
   lg.EntryPreviousStick("highlowpipe",1500,5);

   //Function to be executed when a new stick is formed.
   static datetime tmp_time = iTime(NULL,0,0);
   if(tmp_time!=iTime(NULL,0,0)){
      //something to do
      lg.ResetAlerted();
      lg.ResetEntry();
      tmp_time=iTime(NULL,0,0);
   }
   return(rates_total);
}

void OnTimer(){
   //x回に１回の実行関数
   int interval = 60;//このタイマーのインターバル
   static int timer = interval;
   if(timer > 0){
      timer--;
   } else if(timer == 0){
      //something to do
      //Comment(getRequest("https://www.mql5.com/en/forum/154189"));
      timer = interval;
   }
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam){

   if(id == CHARTEVENT_OBJECT_CLICK){
      long obj_type = ObjectGetInteger(0, sparam, OBJPROP_TYPE);//オブジェクトタイプ
      if(obj_type == OBJ_BUTTON){
         if(sparam == indicator_name + "name"){
            //something to do
         }
      }
   }
   if(id == CHARTEVENT_OBJECT_DRAG){
      
   }
   
   if(id == CHARTEVENT_OBJECT_DELETE){
      
   }
   ChartRedraw(0);
}


int rsicon(int i){
   double rsi = iRSI(NULL,0,14,PRICE_CLOSE,i);
   if(rsi > 65)return 1;
   else if(rsi < 35)return -1;
   else return 0;
}



/*

   チャートに表示させたとき（バーの数を1000とします）
   rates_total = 1000
   Bars = 1000
   prev_calculated = 0
   IndicatorCounted() = 0
   
   Bars - IndicatorCounted() = 1000
   Bars - prev_calculated = 1000    
   
   ↓
   次の瞬間（tickが来た瞬間）
   rates_total = 1000
   Bars = 1000
   prev_calculated = 1000
   IndicatorCounted() = 999
   
   Bars - IndicatorCounted() = 1
   Bars - prev_calculated = 0
   
   ・
   ・
   ・
   新しいロウソク足が出現
   rates_total = 1001
   Bars = 1001
   prev_calculated = 1000
   IndicatorCounted() = 999
   
   Bars - IndicatorCounted() = 2
   Bars - prev_calculated = 1
   
   ↓
   次の瞬間
   rates_total = 1001
   Bars = 1001
   prev_calculated = 1001
   IndicatorCounted() = 1000
   
   Bars - IndicatorCounted() = 1
   Bars - prev_calculated = 0

2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: Bars - prev_calculated = 0
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: Bars - IndicatorCounted() = 1
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: IndicatorCounted() = 102
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: prev_calculated = 103
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: Bars = 103
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: rates_total = 103
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: 新しい足の次tick

2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: Bars - prev_calculated = 1
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: Bars - IndicatorCounted() = 2
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: IndicatorCounted() = 101
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: prev_calculated = 102
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: Bars = 103
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: rates_total = 103
2022.01.16 02:04:37.478	2021.10.05 02:35:00  template USDJPY,M5: 新しい足

2022.01.16 02:04:28.021	2021.10.05 02:30:29  template USDJPY,M5: Bars - prev_calculated = 0
2022.01.16 02:04:28.021	2021.10.05 02:30:29  template USDJPY,M5: Bars - IndicatorCounted() = 1
2022.01.16 02:04:28.021	2021.10.05 02:30:29  template USDJPY,M5: IndicatorCounted() = 101
2022.01.16 02:04:28.021	2021.10.05 02:30:29  template USDJPY,M5: prev_calculated = 102
2022.01.16 02:04:28.021	2021.10.05 02:30:29  template USDJPY,M5: Bars = 102
2022.01.16 02:04:28.021	2021.10.05 02:30:29  template USDJPY,M5: rates_total = 102
2022.01.16 02:04:28.021	2021.10.05 02:30:29  template USDJPY,M5: 二回目

2022.01.16 02:04:19.595	2021.10.05 02:30:25  template USDJPY,M5: Bars - prev_calculated = 102
2022.01.16 02:04:19.595	2021.10.05 02:30:25  template USDJPY,M5: Bars - IndicatorCounted() = 102
2022.01.16 02:04:19.595	2021.10.05 02:30:25  template USDJPY,M5: IndicatorCounted() = 0
2022.01.16 02:04:19.595	2021.10.05 02:30:25  template USDJPY,M5: prev_calculated = 0
2022.01.16 02:04:19.595	2021.10.05 02:30:25  template USDJPY,M5: Bars = 102
2022.01.16 02:04:19.595	2021.10.05 02:30:25  template USDJPY,M5: rates_total = 102
2022.01.16 02:04:19.595	2021.10.05 02:30:25  template USDJPY,M5: 初期


//コード
      Print("新しい足");
      Print("rates_total = ",rates_total);
      Print("Bars = ",Bars);
      Print("prev_calculated = ",prev_calculated);
      Print("IndicatorCounted() = ",IndicatorCounted());
      Print("Bars - IndicatorCounted() = ",Bars - IndicatorCounted());
      Print("Bars - prev_calculated = ",Bars - prev_calculated);




*/