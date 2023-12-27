unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdUDPServer,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, Vcl.ExtCtrls, IdGlobal,
  IdSocketHandle, LogFile, Model, VclTee.TeeGDIPlus, VclTee.TeEngine,
  VclTee.Series, VclTee.TeeProcs, VclTee.Chart, Data.DBXOracle, Data.DB,
  Datasnap.DBClient, SimpleDS, Data.SqlExpr, Vcl.Grids, Vcl.DBGrids,
  Data.FMTBcd,
  Vcl.ComCtrls;

type

  TForm1 = class(TForm)
    Timer1: TTimer;
    IdUDPServerMaster: TIdUDPServer;
    IdUDPClientMaster: TIdUDPClient;
    IdUDPServerSlave: TIdUDPServer;
    IdUDPClientSlave: TIdUDPClient;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    CheckBoxStart: TCheckBox;
    ButtonSend: TButton;
    ButtonReplay: TButton;
    ButtonClear: TButton;
    CheckBoxConnectDB: TCheckBox;
    Panel2: TPanel;
    Chart1: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    SQLConnection1: TSQLConnection;
    SimpleDataSet1: TSimpleDataSet;
    DataSource1: TDataSource;
    SQLQuery1: TSQLQuery;
    Timer2: TTimer;
    Panel5: TPanel;
    Panel4: TPanel;
    ListBox1: TListBox;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    procedure ButtonSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdUDPServerMasterUDPRead(AThread: TIdUDPListenerThread;
      const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure ButtonReplayClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure IdUDPServerSlaveUDPRead(AThread: TIdUDPListenerThread;
      const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure CheckBoxStartClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure CheckBoxConnectDBClick(Sender: TObject);
  private
    { Private declarations }
    SendMsg: TData;
    RecvMsg: TData;
    procedure Log(s: String);
    procedure AddChart(Data: TData);
    procedure AddDB(Data: TData);
    procedure SendData(udpClient: TIdUDPClient; s: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Log(s: String);
begin
  ListBox1.Items.Insert(0, s);
  LogFile.WriteLog(s);
end;

procedure TForm1.SendData(udpClient: TIdUDPClient; s: String);
begin
  try
    udpClient.Connect;
    if udpClient.Connected then
    begin
      udpClient.Send(s);
      Log(udpClient.Name + 'Send: ' + s);
    end;
    udpClient.Active := False;
  except
    on E: Exception do
      Log('Send Error: ' + E.Message);
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  SendData(IdUDPClientSlave, SendMsg.NextS);
end;

procedure TForm1.CheckBoxStartClick(Sender: TObject);
begin
  Timer1.Enabled := (Sender as TCheckBox).Checked;
end;

procedure TForm1.CheckBoxConnectDBClick(Sender: TObject);
begin
  SQLConnection1.Connected := (Sender as TCheckBox).Checked;
  SimpleDataSet1.Active := (Sender as TCheckBox).Checked;
end;

procedure TForm1.ButtonSendClick(Sender: TObject);
begin
  SendData(IdUDPClientSlave, SendMsg.NextS);
end;

procedure TForm1.ButtonReplayClick(Sender: TObject);
begin
  SendData(IdUDPClientMaster, format('%d, %s', [Random(100), ToS(Now)]));
end;

procedure TForm1.ButtonClearClick(Sender: TObject);
begin
  ListBox1.Items.Clear;
  with Chart1 do
  begin
    Series[0].Clear;
    Series[1].Clear;
  end;
end;


procedure TForm1.AddDB(Data: TData);
var
  r: Integer;
begin
  if CheckBoxConnectDB.Checked then
     try
      SendMsg.Next;

      with SQLQuery1 do
      begin
        SQL.Text :=
          format('insert into GAS_VALUES(gas_val_id, gas_val_date, h2_val, o2_val) values(%d, TIMESTAMP ''%s'', %f, %f)',
          [Data.N, ToS(Data.T), Data.H, Data.O]);
        Log(SQL.Text);
        r := ExecSQL(True);
        Log(format('insert rows: %d', [r]));
      end;
    except
      on E: Exception do
      begin
        Log('SQL Error: ' + E.Message);
        SQLConnection1.Connected := false;
        Timer2.Enabled := true;
      end;
    end


end;



procedure TForm1.AddChart(Data: TData);
begin
  with Chart1 do
  begin
    if SendMsg.N > 100 then
    begin
      Series[0].Delete(0);
      Series[1].Delete(0);
    end;
    Series[0].AddXY(SendMsg.N, SendMsg.H, '', clRed);
    Series[1].AddXY(SendMsg.N, SendMsg.O, '', clBlue);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SendMsg := TData.Create;
  RecvMsg := TData.Create;
  IdUDPServerMaster.Active := true;
  IdUDPClientMaster.Active := true;
  IdUDPServerSlave.Active := true;
  IdUDPClientSlave.Active := true;
end;

procedure TForm1.IdUDPServerMasterUDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  s: String;
begin
  try
    s := TEncoding.UTF8.GetString(AData);
    Log('Master read slave data: ' + s);
    RecvMsg.FromString(s);
    AddChart(RecvMsg);
    AddDB(RecvMsg);
    SendData(IdUDPClientMaster, format('%d, %s', [RecvMsg.N, ToS(Now)]));
  except
    on E: Exception do
      Log('Recv Error: ' + E.Message);
  end;
end;

procedure TForm1.IdUDPServerSlaveUDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
begin
  try
    Log('Slave read master reply: ' + TEncoding.UTF8.GetString(AData));
  except
    on E: Exception do
      Log('Recv Error: ' + E.Message);
  end;
end;

end.
