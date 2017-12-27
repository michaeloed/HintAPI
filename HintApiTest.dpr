program HintApiTest;

uses
  Vcl.Forms,
  HintApiTestFrm in 'HintApiTestFrm.pas' {Form1},
  TrackingTooltip in 'TrackingTooltip.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
