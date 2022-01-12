//+------------------------------------------------------------------+
//|                                                     template.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window


//インジケータ名を使って一括で削除すると楽
string indicator_name = "tanetakumi";

double sell[], buy[];
int OnInit(){

   IndicatorBuffers(2);
   SetIndexBuffer(0, sell);
   SetIndexEmptyValue(0, EMPTY_VALUE);
	SetIndexDrawBegin(0, 0);
	SetIndexArrow(0, 234);
	SetIndexStyle(0, DRAW_ARROW ,0, 2 , clrBlue);
	
	SetIndexBuffer(1, buy);
	SetIndexEmptyValue(1, EMPTY_VALUE);
	SetIndexDrawBegin(1, 0);
	SetIndexArrow(1, 233);
	SetIndexStyle(1, DRAW_ARROW ,0, 2, clrRed);
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
   
   //全バー数が100以上の場合初期化関数
   static bool initialized =false;
   if(!initialized){
      //something to do
        
      initialized=true;
   }
   
   int limit = Bars-IndicatorCounted();
   //limit = MathMin(limit,p);
   for(int i=limit-1; i>=0; i--){ 
      
   }
   
   //新しいろうそく足関数
   static datetime tmp_time = Time[0];
   if(tmp_time!=Time[0]){
      //something to do
       
      tmp_time=Time[0];
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