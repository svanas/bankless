program bankless;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Types,
  main in 'main.pas' {frmMain},
  apyCache in 'apyCache.pas';

{$R *.res}

begin
  GlobalUseMetal := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
