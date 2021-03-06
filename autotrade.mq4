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
input int inp_non_judge = 1;//抑止本数
input int p = 1500;//計算バー本数
enum period{ 
    turbo30s = 0,       //ターボ30秒
    turbo1m = 1,        //ターボ1分
    turbo3m = 2,        //ターボ3分
    turbo5m = 3,        //ターボ5分
    highlow15ms = 4,    //Highlow15分短期
    highlow15mm = 5,    //Highlow15分中期
    highlow15ml = 6,    //Highlow15分長期
    highlow1h = 7,      //Highlow1時間
    highlow1d = 8,      //Highlow1日
    turbosp30s = 9,     //ターボスプ30秒
    turbosp1m = 10,     //ターボスプ1分
    turbosp3m = 11,     //ターボスプ3分
    turbosp5m = 12,     //ターボスプ5分
    highlowsp15ms = 13, //Highlowスプ15分短期
    highlowsp15mm = 14, //Highlowスプ15分中期
    highlowsp15ml = 15, //Highlowスプ15分長期
    highlowsp1h = 16,   //Highlowスプ1時間
    highlowsp1d = 17,   //Highlowスプ1日
};
input period inp_num = 4;//期間選択
input int inp_price = 1500;//金額指定(1000円以上)
bool PreBarAlert = false;
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
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
   //オブジェクトの削除
   ObjectsDeleteAll(0,indicator_name);
   //コメントの削除
   Comment("");
   // タイマーの削除
   EventKillTimer();
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
   

   //Function to be executed when a new stick is formed.
   static datetime tmp_time = iTime(NULL,0,0);
   if(tmp_time!=iTime(NULL,0,0)){
      //something to do
      lg.ResetAlerted();
      lg.ResetEntry();
      if(PreBarAlert)lg.AlertPreviousStick();
      lg.EntryPreviousStick("highlowpipe",inp_price,inp_num);
      tmp_time=iTime(NULL,0,0);
   }
   
   
   return(rates_total);
}

void OnTimer(){
   //x回に１回の実行関数
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


