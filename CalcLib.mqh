//+------------------------------------------------------------------+
//|                                                      CalcLib.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

#include "CustomObjects.mqh"
#include "Namedpipe.mqh"
 
class Logic{

   #define HIGH   -1
   #define LOW    1
   
   private:
      
      //variables
      string         logic_name;             //logic name
      string         highExHours[];          //Excluded hour high entry
      string         lowExHours[];           //Excluded hour low entry
      bool           alerted;                //Alerted or not
      bool           entry;                  //Entered or not
      int            fb;                     //First buffer number
      
      int            bwin[24];               //24時間それぞれの buy win 
      int            blose[24];              //24時間それぞれの buy lose
      int            swin[24];               //24時間それぞれの sell win
      int            slose[24];              //24時間それぞれの sell lose
      
      int            consecutive_wins;       //連勝記録
      int            hist[10];               //勝ち負け履歴　勝ち：１　負け：－１
      
      bool           setLabel;               //set up winrate labels or not
      
      //functions
      bool           CheckHour(int shift, int direction);
      void           AddHistory(int value);
      datetime       MT4toJPYtime(datetime time);
      int            getHour(int shift);           //Calculate time hour considering SummerTime
      void           WriteToLabel(string label_name, int win, int lose);   //勝率の書き込み
      double         sell[], buy[], sell_win[], sell_lose[], buy_win[], buy_lose[];
      
   public:
      string         button_name;
      //ユーザー指定--------
      color          up_color;   
      color          down_color;
      color          judge_color;
      double         arrow_dis;              //矢印位置
      double         non_judge;              //抑止本数
      int            num_judge;              //判定本数
      int            sp;                     //スプレッド               
      double         exp_winper;             //期待する勝率
      bool           detail_winrate;         //詳細勝率
      bool           useJPYtime;             //日本時間を使うかどうか
      
      
      void           Logic();             //constraction
      void           InitLogic(string inp_logic_name);
      void           AddExHour(string hours, int direction);   //low=1, high=-1
      void           Reset();                                  //Reset Array
      void           SetBuffer(int buffer_num);                //buffer set
      void           SetArrow(int shift, int ram, int rom);    //arrow set
      void           AlertCurrentStick();                      //現在足での一回のみのアラート  
      void           AlertPreviousStick();                     //足確定時の一回のみのアラート
      void           EntryPreviousStick(string pipename, int price, int num);  //足確定時の一回のみのエントリー
      void           ResetAlerted();                           //アラートされたかのリセット
      void           ResetEntry();                             //エントリーされたかのリセット
      void           DeleteArrow(int shift);                   //後ろの矢印の削除(勝率計算のため)
      void           DeinitLogic();                            //このロジックに関するオブジェクトの削除
      //Function about Display
      void           ShowLogicTitle(string title,int LabelX,int LabelY);
      void           SetWinrateLabel(int LabelX, int LabelY, int corner=CORNER_RIGHT_UPPER);
      void           WriteWinrate();
};


void Logic::Logic(){
   
   ArrayInitialize(bwin,0);
   ArrayInitialize(blose,0);
   ArrayInitialize(swin,0);
   ArrayInitialize(slose,0);
   ArrayInitialize(hist,0);
   
   alerted           = false; //Alerted or not
   entry             = false; //Entered or not
   consecutive_wins  = 0;     //連勝
   //ユーザー指定--------
   up_color             = clrRed;   
   down_color           = clrBlue;
   judge_color          = clrWhite;
   
   arrow_dis      = 5;                 //矢印位置
   non_judge      = 0;                 //抑止本数
   num_judge      = 1;                 //判定本数
   sp             = 0;                 //スプレッド               
   exp_winper     = 0;                 //期待する勝率
   detail_winrate = false;             //詳細勝率
   useJPYtime     = true;              //日本時間を使うかどうか
}

void Logic::InitLogic(string inp_logic_name){
   logic_name = inp_logic_name;
}

void Logic::DeinitLogic(void){
   ObjectsDeleteAll(0,logic_name);
}

void Logic::AddExHour(string hours, int direction){
   if(direction==LOW){
      StringSplit(hours, StringGetCharacter(",", 0), lowExHours);
   } else if(direction == HIGH){
      StringSplit(hours, StringGetCharacter(",", 0), highExHours);
   }
}

void Logic::AddHistory(int value){
   for(int hist_number=ArraySize(hist)-1;hist_number>=0;hist_number--){
      if(hist_number == 0)hist[hist_number]=value;
      else hist[hist_number] = hist[hist_number-1];
   }
}
   
int Logic::getHour(int shift){
   if(useJPYtime){
      return TimeHour(MT4toJPYtime(iTime(NULL,0,shift)));
   } else {
      return TimeHour(iTime(NULL,0,shift));
   }
}

bool Logic::CheckHour(int shift, int direction){
   int hour = getHour(shift);
   if(direction == HIGH){
      for (int i=0; i < ArraySize(highExHours); i++) {
         if(hour == (int)StringToInteger(highExHours[i])) return false;
      }
   } else if(direction == LOW){
      for (int i=0; i < ArraySize(lowExHours); i++) {
         if(hour == (int)StringToInteger(lowExHours[i])) return false;
      }
   }
   return true;
}

void Logic::Reset(){
   ArrayInitialize(bwin,0);
   ArrayInitialize(blose,0);
   ArrayInitialize(swin,0);
   ArrayInitialize(slose,0);
   ArrayInitialize(sell,EMPTY_VALUE);
   ArrayInitialize(buy,EMPTY_VALUE);
   ArrayInitialize(sell_win,EMPTY_VALUE);
   ArrayInitialize(buy_win,EMPTY_VALUE);
   ArrayInitialize(sell_lose,EMPTY_VALUE);
   ArrayInitialize(buy_lose,EMPTY_VALUE);  
   ArrayInitialize(hist,0);
}


void Logic::SetBuffer(int buffer_num){
   fb = buffer_num;
   SetIndexBuffer(fb, sell);
   SetIndexEmptyValue(fb, EMPTY_VALUE);
	SetIndexDrawBegin(fb, 0);
	SetIndexArrow(fb, 234);
	SetIndexStyle(fb, DRAW_ARROW ,0, 2 , down_color);
	
	SetIndexBuffer(fb+1, buy);
	SetIndexEmptyValue(fb+1, EMPTY_VALUE);
	SetIndexDrawBegin(fb+1, 0);
	SetIndexArrow(fb+1, 233);
	SetIndexStyle(fb+1, DRAW_ARROW ,0, 2, up_color);

	SetIndexBuffer(fb+2, sell_win);
	SetIndexEmptyValue(fb+2, EMPTY_VALUE);
	SetIndexDrawBegin(fb+2, 0);
	SetIndexArrow(fb+2, 161);
	SetIndexStyle(fb+2, DRAW_ARROW ,0, 2 , judge_color);
	
	SetIndexBuffer(fb+3, buy_win);
	SetIndexEmptyValue(fb+3, EMPTY_VALUE);
	SetIndexDrawBegin(fb+3, 0);
	SetIndexArrow(fb+3, 161);
	SetIndexStyle(fb+3, DRAW_ARROW ,0, 2 , judge_color);
	
	SetIndexBuffer(fb+4, sell_lose);
	SetIndexEmptyValue(fb+4, EMPTY_VALUE);
	SetIndexDrawBegin(fb+4, 0);
	SetIndexArrow(fb+4, 251);
	SetIndexStyle(fb+4, DRAW_ARROW ,0, 2 , judge_color);

	SetIndexBuffer(fb+5, buy_lose);
	SetIndexEmptyValue(fb+5, EMPTY_VALUE);
	SetIndexDrawBegin(fb+5, 0);
	SetIndexArrow(fb+5, 251);
	SetIndexStyle(fb+5, DRAW_ARROW ,0, 2 , judge_color);
}


void Logic::SetArrow( int shift,int ram,int rom){
   //If there are arrows during the specified number of candlesticks,
   //No arrow will be set on the current candlesticks.
   int flag=0;   
   if(non_judge>0){
      for(int j=1;j<non_judge+1;j++){
         if(buy[shift+j]!=EMPTY_VALUE || sell[shift+j]!=EMPTY_VALUE )flag++; 
      }         
   }
   if(flag==0){
      //set low direction arrow
      if(ram==rom){
         if(CheckHour(shift, LOW)){
            sell[shift]=iHigh(NULL,0,shift)+arrow_dis*_Point;
            buy[shift]=EMPTY_VALUE;            
         }
         else{
            sell[shift]=EMPTY_VALUE;
            buy[shift]=EMPTY_VALUE;               
         }
      }
      //set high direction arrow
      else if(ram==-rom){
         if(CheckHour(shift, HIGH)){
            buy[shift]=iLow(NULL,0,shift)-arrow_dis*_Point;
            sell[shift]=EMPTY_VALUE;            
         }
         else {
            sell[shift]=EMPTY_VALUE;
            buy[shift]=EMPTY_VALUE;
         }
      }
      //It is not set to either buy or sell. 
      else {
         sell[shift]=EMPTY_VALUE;
         buy[shift]=EMPTY_VALUE;
      }         
   }
   else {
      sell[shift]=EMPTY_VALUE;
      buy[shift]=EMPTY_VALUE;
   } 

   if(shift>0){
      int h = getHour(shift+num_judge);
      if(sell[shift+num_judge]!=EMPTY_VALUE){
         if(iOpen(NULL,0,shift+num_judge-1)-iClose(NULL,0,shift)>_Point*sp){//Lowエントリー
            sell_win[shift]=iLow(NULL,0,shift)-arrow_dis*_Point;
            swin[h]++;
            consecutive_wins++;
            AddHistory(1);
         }
         else {
            sell_lose[shift]=iLow(NULL,0,shift)-arrow_dis*_Point;     
            slose[h]++;
            consecutive_wins = 0;
            AddHistory(-1);
         }
      }
      else if(buy[shift+num_judge]!=EMPTY_VALUE){
         if(iClose(NULL,0,shift)-iOpen(NULL,0,shift+num_judge-1)>_Point*sp){
            buy_win[shift]=iHigh(NULL,0,shift)+arrow_dis*_Point;
            bwin[h]++;
            consecutive_wins++;
            AddHistory(1);
         }
         else {
            buy_lose[shift]=iHigh(NULL,0,shift)+arrow_dis*_Point;
            blose[h]++;
            consecutive_wins = 0;
            AddHistory(-1);
         }
      }       
   } 
}  

void Logic::AlertCurrentStick(void){
   if(!alerted){
      if(sell[0]!=EMPTY_VALUE){
         Alert(_Symbol+" "+logic_name+" :Low");
         alerted = true;
      }
      else if(buy[0]!=EMPTY_VALUE){
         Alert(_Symbol+" "+logic_name+" :High");
         alerted = true;
      }
   }
}
   
void Logic::AlertPreviousStick(void){
   if(!alerted){
      if(sell[1]!=EMPTY_VALUE){
         Alert(_Symbol+" "+logic_name+" :Low");
         alerted = true;
      }
      else if(buy[1]!=EMPTY_VALUE){
         Alert(_Symbol+" "+logic_name+" :High");
         alerted = true;
      }
   }      
}

void Logic::EntryPreviousStick(string pipename, int price, int num){
   if(!entry){
      if(sell[1]!=EMPTY_VALUE){
         WriteOnNamedpipe(pipename, _Symbol+"#down#"+IntegerToString(price)+"#"+IntegerToString(num));
         entry = true;
      }
      else if(buy[1]!=EMPTY_VALUE){
         WriteOnNamedpipe(pipename, _Symbol+"#up#"+IntegerToString(price)+"#"+IntegerToString(num));
         entry = true;
      }
   }      
}

void Logic::ResetAlerted(void){
   alerted = false;
}
void Logic::ResetEntry(void){
   entry = false;
}

void Logic::DeleteArrow(int shift){
   int h = getHour(shift+num_judge);
   if(sell_win[shift]!=EMPTY_VALUE){
      swin[h]--;
      sell_win[shift]=EMPTY_VALUE;
      sell[shift+num_judge]=EMPTY_VALUE;
   }   
   else if(sell_lose[shift]!=EMPTY_VALUE){
      slose[h]--;
      sell_lose[shift]=EMPTY_VALUE;
      sell[shift+num_judge]=EMPTY_VALUE;
   } 
   else if(buy_win[shift]!=EMPTY_VALUE){
      bwin[h]--;
      buy_win[shift]=EMPTY_VALUE;
      buy[shift+num_judge]=EMPTY_VALUE;
   }  
   else if(buy_lose[shift]!=EMPTY_VALUE){
      blose[h]--;
      buy_lose[shift]=EMPTY_VALUE;
      buy[shift+num_judge]=EMPTY_VALUE;
   }    
}


void Logic::ShowLogicTitle(string title,int LabelX,int LabelY){
   label(logic_name+"label",title, LabelX, LabelY, clrWhite, CORNER_LEFT_UPPER, 10);  
}

//ロジックの勝率表示
void Logic::SetWinrateLabel(int LabelX, int LabelY, int corner=CORNER_RIGHT_UPPER){
   if(detail_winrate){
      label(logic_name+"DetailLabelH","High",LabelX+100,5,clrWhite, corner);
      label(logic_name+"DetailLabelL","Low",LabelX,5,clrWhite, corner);
      for(int hour=0;hour<24;hour++){
         label(logic_name+"DetailHour"+IntegerToString(hour),IntegerToString(hour)+"時",LabelX+150,20+15*hour,clrWhite, corner);
         label(logic_name+"DetailHigh"+IntegerToString(hour),"計算中",LabelX+100,20+15*hour,clrWhite, corner);
         label(logic_name+"DetailLow"+IntegerToString(hour),"計算中",LabelX,20+15*hour,clrWhite, corner);
      }
      label(logic_name+"DetailHour24","総合",LabelX+150,25+15*24,clrMagenta, corner);
      label(logic_name+"DetailHigh24","計算中",LabelX+100,25+15*24,clrWhite, corner);
      label(logic_name+"DetailLow24","計算中",LabelX,25+15*24,clrWhite, corner);       
   }
   else {
      label(logic_name+"header","計算中",LabelX,LabelY,clrWhite, corner,10);      
   }
   setLabel=true;
}

//勝率書き込み
void Logic::WriteWinrate(void){
   if(setLabel){
      if(detail_winrate){
         for(int hour=0;hour<25;hour++){
            string label_nameH = logic_name+"DetailHigh"+IntegerToString(hour);
            string label_nameL = logic_name+"DetailLow"+IntegerToString(hour);
            
            //総計値は24番目のラベルにセットする
            if(hour==24){
               int sum_bwin=0,sum_blose=0,sum_swin=0,sum_slose=0;
               for(int _hour = 0;_hour<24;_hour++){
                  sum_bwin    += bwin[_hour]; 
                  sum_blose   += blose[_hour]; 
                  sum_swin    += swin[_hour]; 
                  sum_slose   += slose[_hour];
               } 
               
               WriteToLabel(label_nameH,sum_bwin,sum_blose);
               WriteToLabel(label_nameL,sum_swin,sum_slose);                       
            }
            //0-23時
            else{
               ObjectSetInteger(NULL,logic_name+"DetailHour"+IntegerToString(hour),OBJPROP_COLOR,clrWhite);
               WriteToLabel(label_nameH,bwin[hour],blose[hour]);
               WriteToLabel(label_nameL,swin[hour],slose[hour]);            
            } 
            //Change color for hour
            if(getHour(0)==hour){
               ObjectSetInteger(NULL,logic_name+"DetailHour"+IntegerToString(hour),OBJPROP_COLOR,clrCyan);
            }
         }
      }
      else {
         int sum_win=0, sum_lose=0;
         for(int hour = 0;hour<24;hour++){
            sum_win += bwin[hour]; 
            sum_lose += blose[hour]; 
            sum_win += swin[hour]; 
            sum_lose += slose[hour];
         }
         WriteToLabel(logic_name+"header",sum_win,sum_lose);
      }   
   }

}

void Logic::WriteToLabel(string label_name,int win,int lose){
   double calc_winper = 0;
   if(win+lose!=0)calc_winper = (double)win/(double)(win+lose)*100;
   ObjectSetString(NULL,label_name,OBJPROP_TEXT,StringFormat("%3.2f / %3d",calc_winper,win+lose));
   
   if(calc_winper>=exp_winper) {
      ObjectSetInteger(NULL, label_name,OBJPROP_COLOR,clrLemonChiffon);
   }
   else {
      ObjectSetInteger(NULL, label_name,OBJPROP_COLOR,clrWhite);
   }   
}

datetime Logic::MT4toJPYtime(datetime time){
   //3月第2日曜日午前2時〜11月第1日曜日午前2時　夏時間
   
   int month = TimeMonth(time);
   if(month<3 || 11< month ){
      //冬時間
      return time+D'1970.01.01 7:00:00';
      
   }
   else if(month ==3){
      int day = TimeDay(time);
      int week = TimeDayOfWeek(time);
      if((day-week-1)/7>=1){
         //夏時間
         return time+D'1970.01.01 6:00:00';
      }
      else {
         //冬時間
         return time+D'1970.01.01 7:00:00';
      }
   }
   else if(month ==11){
      int day = TimeDay(time);
      int week = TimeDayOfWeek(time);
      if(1>day-week){
         //夏時間
         return time+D'1970.01.01 6:00:00';
      }
      else {
         //冬時間
         return time+D'1970.01.01 7:00:00';
      }
   }
   else {
      //夏時間
      return time+D'1970.01.01 6:00:00';
   }
}
