unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,Winapi.ShellAPI, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    btn1: TBitBtn;
    btn2: TBitBtn;
    btn3: TBitBtn;
    img1: TImage;
    tmr1: TTimer;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmr1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  main;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
ShellExecute(Handle, 'open','https://www.facebook.com/Yamada.Fakir1',nil,nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
form1.Hide;
fMain.Show;
fMain.tmr2.Enabled:=False;
tmr1.Enabled := False;
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
  form1.Hide;
fmain.Show;
fmain.tmr2.Enabled:=False;
tmr1.Enabled := False;
end;

end.
