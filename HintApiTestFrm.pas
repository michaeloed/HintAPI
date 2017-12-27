unit HintApiTestFrm;

interface

uses
	TrackingTooltip
	, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
	  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
	TForm1 = class(TForm)
		btn1: TButton;
		btn2: TButton;
		btn3: TButton;
		btn4: TButton;
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
	procedure btn1MouseEnter(Sender: TObject);
    procedure btn1MouseLeave(Sender: TObject);

	strict private
		FToolTip: TTrackingToolTip;

	end;

var
	Form1: TForm1;

implementation
uses
	Winapi.CommCtrl
	;

{$R *.dfm}

procedure TForm1.btn1MouseEnter(Sender: TObject);
var
	btn: TButton;
begin
	btn := (Sender as TButton);
	FToolTip.setText(Format('Über dem Button "%s"', [ btn.Caption ]));
	FToolTip.setTitle(btn.Caption, TTI_INFO);
	FToolTip.setPosition(ClientToScreen(btn.BoundsRect.TopLeft));
	FToolTip.show();
end;

procedure TForm1.btn1MouseLeave(Sender: TObject);
begin
//	FToolTip.hide();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
	FToolTip := TTrackingToolTip.Create(Self.Handle, True);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
	FreeAndNil(FToolTip);
end;

end.
