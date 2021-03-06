//+------------------------------------------------------------------+
//|                                                    Namedpipe.mqh |
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

bool WriteOnNamedpipe(string pipeName, string message){
   int pipe_handle = FileOpen("\\\\.\\pipe\\" + pipeName, FILE_READ | FILE_WRITE | FILE_BIN | FILE_ANSI);
   
   if(pipe_handle!=INVALID_HANDLE){
      // 文字列をパイプに書き込む
      FileWriteString(pipe_handle, message + "\r\n");
      // パイプを閉じる。
      FileClose(pipe_handle);
      return true;
   } else {
      Print("パイプ接続失敗 : "+pipeName);
      return false;
   }
}