unit LogFile;

interface

type
  TLogFileMsgType = (LFM_ERR, LFM_INF, LFN_WARN);

procedure WriteLog(Message: String);

implementation

uses
  Sysutils, Dialogs, Syncobjs, Windows;

var
  LogFileName: String;
  CS: TCriticalSection;

const
  MsgTypeStr: array [TLogFileMsgType] of string = ('Ошибка', 'Сообщение',
    'Предупреждение');

procedure WriteLog(Message: String);
var
  F: TextFile;
  stime: string;
begin
  try
    CS.Enter;
    LogFileName := 'Logs\' + FormatDateTime('yyyy.mm.dd', Date) + '.log';
    AssignFile(F, LogFileName);
    if FileExists(LogFileName) then
      Append(F)
    else
      Rewrite(F);
    DateTimeToString(stime, 'hh:mm:ss.zzz', Now);
    Writeln(F, stime, '# ', Message);
    Close(F);
  finally
    CS.Leave;
  end;
end;

procedure ClearLogs;
var
  dt, dtf: TDateTime;
  sr: TSearchRec;
begin
  dt := Date - 30;
  ChDir('Logs');
  if FindFirst('*.log', 0, sr) = 0 then
    repeat
      {$WARN SYMBOL_PLATFORM OFF}
      dtf := FileDateToDateTime(sr.Time);
      {$WARN SYMBOL_PLATFORM ON}
      if dtf < dt then
        Sysutils.DeleteFile(sr.Name) until FindNext(sr) <> 0;
      Sysutils.FindClose(sr);
      ChDir('..');
    end;

  procedure CheckDirLogs;
  var
    sr: TSearchRec;
  begin
    if FindFirst('Logs', faDirectory, sr) <> 0 then
      MkDir('Logs');
    Sysutils.FindClose(sr);
  end;

initialization

try
  CS := TCriticalSection.Create;
  CheckDirLogs;
  ClearLogs;
except
  on E: Exception do
  begin
    ShowMessage('Ошибка инициализации модуля поддержки журнальных файлов'#13#10
      + E.Message);
  end;
end;

finalization

try
  ClearLogs;
  CS.Free;
except
  on E: Exception do
  begin
    ShowMessage
      ('Ошибка деинициализации модуля поддержки журнальных файлов'#13#10 +
      E.Message);
  end;
end;

end.
