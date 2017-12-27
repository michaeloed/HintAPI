{
MIT License

Copyright (c) 2017 Michael Oed

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
}

unit TrackingTooltip;

interface
uses
	Winapi.Windows
	, Winapi.CommCtrl
	;

type
	TTrackingToolTip = class
	strict private
		FHwndTool: HWND;
		FParent: HWND;
		FToolInfo: TOOLINFO;
		FIsBalloon: Boolean;

		procedure initTooltip();

	public
		constructor Create(_parent: HWND; _isBalloon: Boolean = True);

		procedure setPosition(_position: TPoint);
		procedure setTitle(_title: string; _icon: Integer);
		procedure setText(_text: string);
		procedure show();
		procedure hide();
	end;

implementation

constructor TTrackingToolTip.Create(_parent: HWND; _isBalloon: Boolean = True);
begin
	FParent := _parent;
	FIsBalloon := _isBalloon;
	FHwndTool := 0;
	ZeroMemory(@FToolInfo, SizeOf(TOOLINFO));
end;

procedure TTrackingToolTip.initTooltip();
var
	tipStyle: Integer;
begin
	if (FHwndTool = 0) then
	begin
		tipStyle := WS_POPUP or TTS_NOPREFIX or TTS_ALWAYSTIP;
		if (FIsBalloon) then
		begin
			tipStyle := tipStyle or TTS_BALLOON;
		end;

		// https://msdn.microsoft.com/de-de/library/windows/desktop/hh298405(v=vs.85).aspx
		FHwndTool := CreateWindowEx(WS_EX_TOPMOST, TOOLTIPS_CLASS, nil,
								   tipStyle,
								   CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
								   FParent, 0, HInstance, nil);
		FToolInfo.cbSize := SizeOf(TOOLINFO);
		FToolInfo.uFlags := TTF_IDISHWND or TTF_TRACK or TTF_ABSOLUTE;
		FToolInfo.hwnd := FParent;
		FToolInfo.hinst := HInstance;
		FToolInfo.lpszText := '';
		FToolInfo.uId := FParent;
		GetClientRect(FParent, &FToolInfo.rect);
		SendMessage(FHwndTool, TTM_ADDTOOL, 0, Integer(@FToolInfo));
	end;
end;

procedure TTrackingToolTip.setPosition(_position: TPoint);
begin
	initTooltip();
	SendMessage(FHwndTool, TTM_TRACKPOSITION, 0, MakeLParam(_position.X, _position.Y));
end;

procedure TTrackingToolTip.setTitle(_title: string; _icon: Integer);
begin
	initTooltip();
	SendMessage(FHwndTool, TTM_SETTITLE, _icon, Integer(PChar(_title)));
end;

procedure TTrackingToolTip.setText(_text: string);
begin
	initTooltip();
	FToolInfo.lpszText := PChar(_text);
	SendMessage(FHwndTool, TTM_UPDATETIPTEXT, 0, Integer(@FToolInfo))
end;

procedure TTrackingToolTip.show();
begin
	initTooltip();
	SendMessage(FHwndTool, TTM_TRACKACTIVATE, 1, Integer(@FToolInfo));
end;

procedure TTrackingToolTip.hide();
begin
	initTooltip();
	SendMessage(FHwndTool, TTM_TRACKACTIVATE, 0, Integer(@FToolInfo));
end;
end.
