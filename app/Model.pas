unit Model;



interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Math;



type
  TData = class
    N: Integer;
    T: TDateTime;
    H: Real;
    O: Real;
  public
    Constructor Create; overload;
    function ToString: String; override;
    procedure FromString(s: String);
    procedure Next;
    function NextS: String;

  end;

function ToS(dt: TDateTime): String;
function ToD(s :string): TDateTime;


implementation

function ToS(dt: TDateTime): String;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', dt);
end;

function ToD(s :string): TDateTime;
var
  fs: TFormatSettings;
begin
  fs := TFormatSettings.Create;
  fs.DateSeparator := '-';
  fs.ShortDateFormat := 'yyyy-mm-dd';
  fs.TimeSeparator := ':';
  fs.ShortTimeFormat := 'hh:mm';
  fs.LongTimeFormat := 'hh:mm:ss.zzz';

  Result := StrToDateTime(s, fs);
end;

Constructor TData.Create;
begin
  N := 0;
  Next;
end;


function TData.ToString: String;
begin
  try
    Result := String.Join(',', [N, ToS(T), H, O] );
  except
    raise Exception.Create('Error convert data to string');
  end;
end;

procedure TData.FromString(s: String);
var
  ss: TArray<String>;
begin
  try
    ss := Trim(s).Split([','], 4);
    N := StrToInt(ss[0]);
    T := ToD(ss[1]);
    H := StrToFloat(ss[2]);
    O := StrToFloat(ss[3]);
  except
    raise Exception.Create('Error parse data from string: ' + String.Join('|', ss));
  end;
end;

procedure TData.Next;
begin
  Inc(N);
  T := Now;
  H := 1.0 + SimpleRoundTo(Random, -2);
  O := 2.0 + SimpleRoundTo(Random, -2);
end;

function TData.NextS: String;
begin
  Next;
  Result := ToString;
end;

end.
