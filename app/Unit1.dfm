object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Client-server test, all in one.'
  ClientHeight = 643
  ClientWidth = 886
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 305
    Width = 886
    Height = 3
    Cursor = crVSplit
    Align = alTop
    MinSize = 3
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 624
    Width = 886
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 886
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitLeft = -8
    ExplicitTop = -4
    object CheckBoxStart: TCheckBox
      Left = 9
      Top = 12
      Width = 65
      Height = 17
      Caption = 'Start'
      TabOrder = 0
      OnClick = CheckBoxStartClick
    end
    object ButtonSend: TButton
      Left = 80
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Send'
      TabOrder = 1
      OnClick = ButtonSendClick
    end
    object ButtonReplay: TButton
      Left = 168
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Replay'
      TabOrder = 2
      OnClick = ButtonReplayClick
    end
    object ButtonClear: TButton
      Left = 256
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Clear'
      TabOrder = 3
      OnClick = ButtonClearClick
    end
    object CheckBoxConnectDB: TCheckBox
      Left = 347
      Top = 12
      Width = 97
      Height = 17
      Caption = 'Connect DB'
      TabOrder = 4
      OnClick = CheckBoxConnectDBClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 308
    Width = 886
    Height = 316
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 2
    object Chart1: TChart
      Left = 1
      Top = 1
      Width = 884
      Height = 314
      Legend.Visible = False
      Title.Text.Strings = (
        'TChart')
      View3D = False
      Align = alClient
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series1: TFastLineSeries
        LinePen.Color = 10708548
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series2: TFastLineSeries
        LinePen.Color = 3513587
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 41
    Width = 886
    Height = 264
    Align = alTop
    Caption = 'Panel5'
    TabOrder = 3
    object Splitter2: TSplitter
      Left = 493
      Top = 1
      Height = 262
      Align = alRight
      ExplicitLeft = 480
      ExplicitTop = 120
      ExplicitHeight = 100
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 492
      Height = 262
      Align = alClient
      Caption = 'Panel4'
      TabOrder = 0
      object ListBox1: TListBox
        Left = 1
        Top = 1
        Width = 490
        Height = 260
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object Panel3: TPanel
      Left = 496
      Top = 1
      Width = 389
      Height = 262
      Align = alRight
      Caption = 'Panel3'
      TabOrder = 1
      object DBGrid1: TDBGrid
        Left = 1
        Top = 1
        Width = 387
        Height = 260
        Align = alClient
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'GAS_VAL_ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GAS_VAL_DATE'
            Width = 117
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'H2_VAL'
            Width = 59
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'O2_VAL'
            Width = 54
            Visible = True
          end>
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 32
    Top = 80
  end
  object IdUDPClientSlave: TIdUDPClient
    Host = '127.0.0.1'
    Port = 8000
    Left = 32
    Top = 144
  end
  object IdUDPServerMaster: TIdUDPServer
    Bindings = <>
    DefaultPort = 8000
    OnUDPRead = IdUDPServerMasterUDPRead
    Left = 152
    Top = 144
  end
  object IdUDPClientMaster: TIdUDPClient
    Host = '127.0.0.1'
    Port = 8001
    Left = 152
    Top = 208
  end
  object IdUDPServerSlave: TIdUDPServer
    Bindings = <>
    DefaultPort = 8001
    OnUDPRead = IdUDPServerSlaveUDPRead
    Left = 32
    Top = 208
  end
  object SQLConnection1: TSQLConnection
    ConnectionName = 'OracleConnection'
    DriverName = 'Oracle'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXOracle'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DBXCommonDriver250.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=24.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXOracleMetaDataCommandFactory,DbxOracle' +
        'Driver250.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXOracleMetaDataCommandFac' +
        'tory,Borland.Data.DbxOracleDriver,Version=24.0.0.0,Culture=neutr' +
        'al,PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverORACLE'
      'LibraryName=dbxora.dll'
      'LibraryNameOsx=libsqlora.dylib'
      'VendorLib=oci.dll'
      'VendorLibWin64=oci.dll'
      'VendorLibOsx=libociei.dylib'
      'MaxBlobSize=-1'
      'OSAuthentication=False'
      'MultipleTransactions=False'
      'TrimChar=False'
      'DriverName=Oracle'
      'Database=XE'
      'User_Name=stal'
      'Password=stal'
      'RowsetSize=20'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'IsolationLevel=ReadCommitted'
      'OS Authentication=False'
      'Multiple Transaction=False'
      'Trim Char=False'
      'Decimal Separator=.'
      'HostName=127.0.0.1')
    Left = 328
    Top = 72
  end
  object SimpleDataSet1: TSimpleDataSet
    Aggregates = <>
    Connection = SQLConnection1
    DataSet.CommandText = 'select * from GAS_VALUES order by  gas_val_date desc'
    DataSet.DataSource = DataSource1
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 400
    Top = 72
  end
  object DataSource1: TDataSource
    DataSet = SimpleDataSet1
    Left = 320
    Top = 120
  end
  object SQLQuery1: TSQLQuery
    DataSource = DataSource1
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 392
    Top = 128
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 10000
    Left = 104
    Top = 80
  end
end
