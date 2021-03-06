//+------------------------------------------------------------------+
//|                                                 ObjectCustom.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
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
void button(string name,string text, int x ,int y,int x_size,int y_size ,color c=clrDarkBlue,int corner=CORNER_LEFT_UPPER,int font_size=8){
   ObjectCreate(NULL,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,clrWhite);    // text色設定
   //ObjectSetInteger(NULL,name,OBJPROP_BACK,true);            // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
   //ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);            // オブジェクトのチャートクリックイベント優先順位
   ObjectSetString(NULL,name,OBJPROP_TEXT,text);            // 表示するテキスト
   ObjectSetString(NULL,name,OBJPROP_FONT,"ＭＳ　ゴシック");          // フォント
   ObjectSetInteger(NULL,name,OBJPROP_FONTSIZE,font_size);                   // フォントサイズ
   ObjectSetInteger(NULL,name,OBJPROP_CORNER,corner);  // コーナーアンカー設定
   ObjectSetInteger(NULL,name,OBJPROP_XDISTANCE,x);                // X座標
   ObjectSetInteger(NULL,name,OBJPROP_YDISTANCE,y);                 // Y座標
   ObjectSetInteger(NULL,name,OBJPROP_XSIZE,x_size);                    // ボタンサイズ幅
   ObjectSetInteger(NULL,name,OBJPROP_YSIZE,y_size);                     // ボタンサイズ高さ
   ObjectSetInteger(NULL,name,OBJPROP_BGCOLOR,c);              // ボタン色
   ObjectSetInteger(NULL,name,OBJPROP_BORDER_COLOR,clrWhite);       // ボタン枠色
   ObjectSetInteger(NULL,name,OBJPROP_STATE,false);                  // ボタン押下状態
}

void label(string name,string text, int x, int y,color c=clrWhite,int corner=CORNER_RIGHT_UPPER,int font_size=8){
   ObjectCreate(NULL,name,OBJ_LABEL,0,0,0); 
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,c);    // 色設定
   ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,false);         // オブジェクトリスト表示設定
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);            // オブジェクトのチャートクリックイベント優先順位
   ObjectSetString(NULL,name,OBJPROP_TEXT,text);    // 表示するテキスト
   ObjectSetString(NULL,name,OBJPROP_FONT,"ＭＳ　ゴシック");  // フォント
   ObjectSetInteger(NULL,name,OBJPROP_FONTSIZE,font_size);                   // フォントサイズ
   ObjectSetInteger(NULL,name,OBJPROP_CORNER,corner);  // コーナーアンカー設定
   ObjectSetInteger(NULL,name,OBJPROP_XDISTANCE,x);                // X座標
   ObjectSetInteger(NULL,name,OBJPROP_YDISTANCE,y);                 // Y座標
}

void arrow(string name,int arrow_code, datetime time, double price,color c=clrWhite){
   ObjectCreate(NULL,name,OBJ_ARROW_DOWN,0,time,price);
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,c);    // 色設定
   ObjectSetInteger(NULL,name,OBJPROP_WIDTH,1);             // 幅設定
   ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
   ObjectSetInteger(NULL,name,OBJPROP_ANCHOR,ANCHOR_BOTTOM);   // アンカータイプ
   ObjectSetInteger(NULL,name,OBJPROP_ARROWCODE,arrow_code);      // アローコード
}

void h_line(string name,double value,color c){
    ObjectCreate(NULL,name,OBJ_HLINE,0,0,value);
    ObjectSetInteger(NULL,name,OBJPROP_COLOR,c);    // ラインの色設定
    ObjectSetInteger(NULL,name,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
    ObjectSetInteger(NULL,name,OBJPROP_WIDTH,1);              // ラインの幅設定
    ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
    ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
    ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
    ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
    ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);      // オブジェクトのチャートクリックイベント優先順位
}

void image(string name,int x ,int y,string path,int corner=CORNER_RIGHT_UPPER){
   ObjectCreate(NULL,name,OBJ_BITMAP_LABEL,0,0,0);           // OBJ_BITMAP_LABELオブジェクト作成
   ObjectSetInteger(NULL,name,OBJPROP_CORNER,corner); // アンカー設定：チャート右上
   ObjectSetInteger(NULL,name,OBJPROP_XDISTANCE,x);              // アンカーからのX軸距離：100pixel
   ObjectSetInteger(NULL,name,OBJPROP_YDISTANCE,y);  
   ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
   bool res = ObjectSetString(NULL,name,OBJPROP_BMPFILE,0,path); 
   if( res == false ) {                                                 // 画像ファイル設定失敗
      PrintFormat("%s の画像ファイルを設定出来ませんでした。 エラーコード： %d",path ,GetLastError());
   }
}

void edit(string name,int x ,int y,int x_size = 80,int y_size=20,int corner=CORNER_LEFT_UPPER){
   ObjectCreate(NULL,name, OBJ_EDIT,0,0,0);
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,clrWhite);    // 色設定
   ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
   ObjectSetString(NULL,name,OBJPROP_TEXT,"");            // 表示するテキスト
   ObjectSetString(NULL,name,OBJPROP_FONT,"ＭＳ　ゴシック");        // フォント
   ObjectSetInteger(NULL,name,OBJPROP_FONTSIZE,12);                 // フォントサイズ
   ObjectSetInteger(NULL,name,OBJPROP_CORNER,corner);// コーナーアンカー設定
   ObjectSetInteger(NULL,name,OBJPROP_XDISTANCE,x);             // X座標
   ObjectSetInteger(NULL,name,OBJPROP_YDISTANCE,y);              // Y座標
   ObjectSetInteger(NULL,name,OBJPROP_XSIZE,x_size);                  // ボタンサイズ幅
   ObjectSetInteger(NULL,name,OBJPROP_YSIZE,y_size);                   // ボタンサイズ高さ
   ObjectSetInteger(NULL,name,OBJPROP_BGCOLOR,clrGray);           // ボタン色
   //ObjectSetInteger(NULL,name,OBJPROP_BORDER_COLOR,clrAqua);     // ボタン枠色
   ObjectSetInteger(NULL,name,OBJPROP_ALIGN,ALIGN_RIGHT);        // テキスト整列
   ObjectSetInteger(NULL,name,OBJPROP_READONLY,false);            // 読み取り専用設定
}

void rectangle(string name, datetime time1, double price1, datetime time2, double price2){
   ObjectCreate(NULL,name,OBJ_RECTANGLE,0,time1, price1, time2, price2);
   ObjectSetInteger(NULL,name,OBJPROP_COLOR,clrYellow);    // ラインの色設定
   ObjectSetInteger(NULL,name,OBJPROP_STYLE,STYLE_SOLID);  // ラインのスタイル設定
   ObjectSetInteger(NULL,name,OBJPROP_WIDTH,1);              // ラインの幅設定
   ObjectSetInteger(NULL,name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
   ObjectSetInteger(NULL,name,OBJPROP_SELECTED,true);       // オブジェクトの選択状態
   ObjectSetInteger(NULL,name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
   ObjectSetInteger(NULL,name,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位
   
   ObjectSetInteger(NULL,name,OBJPROP_FILL,false);          // 埋め(塗りつぶし)設定
}