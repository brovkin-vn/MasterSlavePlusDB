program MasterSlavePlusDB;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  LogFile in 'LogFile.pas',
  Model in 'Model.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
