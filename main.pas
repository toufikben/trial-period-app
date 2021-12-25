unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXCtrls,system.UITypes;

type
  TFmain = class(TForm)
    sw: TToggleSwitch;
    edt8: TEdit;
    btn6: TButton;
    FireTaskList: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    tmr4: TTimer;
    tmr3: TTimer;
    FDQuery1: TFDQuery;
    edt7: TEdit;
    tmr2: TTimer;
    procedure FireTaskListAfterConnect(Sender: TObject);
    procedure FireTaskListBeforeConnect(Sender: TObject);
    procedure tmr3Timer(Sender: TObject);
    procedure tmr4Timer(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure edt8Change(Sender: TObject);
    procedure tmr2Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmain: TFmain;

implementation

{$R *.dfm}

uses Unit1;

function getserial : string;
var v1,v2,v3,v4 : longword;
begin
asm
push edx
push ecx
push ebx
push eax
mov eax,2
db $f
db $a2
mov v1,edx
mov v2,eax
mov v3,ebx
mov v4,ecx
pop eax
pop ebx
pop ecx
pop edx
end;
getserial :=
inttohex(v1,8)+'-'+inttohex(v2,8)+'-'+inttohex(v3,8)+'-'+inttohex(v4,8);
end;
function GetSerialIDEx: string;
var
VolumeSerialNumber : DWORD;
MaximumComponentLength : DWORD;
FileSystemFlags : DWORD;
SerialNumber : string;
begin
GetVolumeInformation('C:',nil,0,@VolumeSerialNumber,
MaximumComponentLength,
FileSystemFlags,nil,0);
SerialNumber := IntToHex(HiWord(VolumeSerialNumber), 4) +'-' +
IntToHex(LoWord(VolumeSerialNumber), 4);
Result:=SerialNumber;
end;

procedure TFmain.btn6Click(Sender: TObject);
begin
if edt8.Text = '1234' then
begin
FDQuery1.Active := False;
FDQuery1.SQL.Clear;
FDQuery1.SQL.add('delete from diskdurtable');
FDQuery1.ExecSQL;
sw.State:= tssOff;
MessageDlg('La version d essai a été activée pendant 7 jours supplémentaires', mtInformation, [mbOK], 0) ;
edt8.Text := '';
end;
end;

procedure TFmain.edt8Change(Sender: TObject);
begin
if (edt8.Text = '1234')then
begin
sw.ReadOnly := False;
sw.State :=  tssOn;
end else
sw.ReadOnly := True;
if ( Length(edt8.Text)<> 4) then
sw.State :=  tssOff;

end;

procedure TFmain.FireTaskListAfterConnect(Sender: TObject);
begin
 FireTaskList.ExecSQL ('CREATE TABLE IF NOT EXISTS diskdurtable (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,diskkey  VARCHAR(100),dateexp DateTime)');
end;

procedure TFmain.FireTaskListBeforeConnect(Sender: TObject);
begin
  try
//FireTaskList.Connected := False;
//FireTaskList.Params.Clear;
//FireTaskList.LoginPrompt := false;
FireTaskList.Params.DriverID := 'SQLite';
FireTaskList.Params.Values['Database'] := 'tasks.s3db';//or //FireTaskList.Params.Add('Database'+'='+ExtractFilePath (application.ExeName)+'tasks.s3db');
FireTaskList.Params.Values['Encrypt'] := 'aes-256'; //encrepty database
FireTaskList.Params.Password := 'Fatwa@!alHoda';   //password database
  except
    on E: EDatabaseError do
      ShowMessage('ÍÏË ÎØÃ ÇËäÇÁ ÇáÇÊÕÇá ÈÞÇÚÏÉ ÇáÈíÇäÇÊ' + E.Message);
  end;


end;

procedure TFmain.FormActivate(Sender: TObject);
begin
 if sw.State = tssOff  then
begin
Tmr2.Enabled:=True;
end else
if edt8.Text = '1234' then
begin
Tmr2.Enabled:=false;
Tmr3.Enabled:=True;
end;
end;

procedure TFmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 FDQuery1.SQL.Clear;
FDQuery1.SQL.add('select * from diskdurtable');
FDQuery1.Open;
if FDQuery1.IsEmpty then
begin
 with FDQuery1 do
 begin
Active := False;
SQL.Clear;
FDQuery1.SQL.add('INSERT INTO diskdurtable (dateexp,diskkey) VALUES (Date(),"'+  edt7.text + '")');
FDQuery1.ExecSQL;
end;
end;
end;

procedure TFmain.FormCreate(Sender: TObject);
begin
  FireTaskList.Connected := True;
end;

procedure TFmain.FormShow(Sender: TObject);
begin
  if (edt7.Text = '') then
   edt7.Text := getserial;
end;

procedure TFmain.tmr2Timer(Sender: TObject);
begin
FDQuery1.Close;
FDQuery1.SQL.clear;
FDQuery1.SQL.Text :='Select *from diskdurtable where cast ((julianday("now") - julianday(dateexp)) as integer) = 1';
FDQuery1.Open;
if not FDQuery1.IsEmpty    then
begin
form1.Caption := 'La date d expiration du programme (AdsVer) est sur le point d expirer';
form1.Show;
fmain.hide;
tmr2.Enabled:=False;
Form1.tmr1.Enabled := True;
end
else
FDQuery1.Close;
FDQuery1.SQL.clear;
FDQuery1.SQL.add('Select *from diskdurtable where cast ((julianday("now") - julianday(dateexp)) as integer) = 2');
FDQuery1.Open;
if not FDQuery1.IsEmpty    then
begin
form1.Caption := 'La date d expiration du programme (AdsVer) est sur le point d expirer, pour les (07) jours restants';
form1.Show;
fmain.hide;
tmr2.Enabled:=False;
Form1.tmr1.Enabled := True;
end
else
FDQuery1.Close;
FDQuery1.SQL.clear;
FDQuery1.SQL.add('Select *from diskdurtable where cast ((julianday("now") - julianday(dateexp)) as integer) = 3');
FDQuery1.Open;
if not FDQuery1.IsEmpty    then
begin
form1.Caption := 'La date d expiration du programme (AdsVer) est sur le point d expirer, pour les (06) jours restants';
form1.Show;
fmain.hide;
tmr2.Enabled:=False;
Form1.tmr1.Enabled := True;
end
else
FDQuery1.Close;
FDQuery1.SQL.clear;
FDQuery1.SQL.add('Select *from diskdurtable where cast ((julianday("now") - julianday(dateexp)) as integer) = 4');
FDQuery1.Open;
if not FDQuery1.IsEmpty    then
begin
form1.Caption := 'La date d expiration du programme (AdsVer) est sur le point d expirer, pour les (05) jours restants';
form1.Show;
fmain.hide;
tmr2.Enabled:=False;
Form1.tmr1.Enabled := True;
end
else
FDQuery1.Close;
FDQuery1.SQL.clear;
FDQuery1.SQL.add('Select *from diskdurtable where cast ((julianday("now") - julianday(dateexp)) as integer) = 5');
FDQuery1.Open;
if not FDQuery1.IsEmpty    then
begin
form1.Caption := 'La date d expiration du programme (AdsVer) est sur le point d expirer, pour les (04) jours restants';
form1.Show;
fmain.hide;
tmr2.Enabled:=False;
Form1.tmr1.Enabled := True;
end
else
FDQuery1.Close;
FDQuery1.SQL.clear;
FDQuery1.SQL.add('Select *from diskdurtable where cast ((julianday("now") - julianday(dateexp)) as integer) = 6');
FDQuery1.Open;
if not FDQuery1.IsEmpty    then
begin
form1.Caption := 'La date d expiration du programme (AdsVer) est sur le point d expirer, pour les (03) jours restants';
form1.Show;
fmain.hide;
Tmr2.Enabled:=False;
Form1.tmr1.Enabled := True;
end
else
FDQuery1.Close;
FDQuery1.SQL.clear;
FDQuery1.SQL.add('Select *from diskdurtable where cast ((julianday("now") - julianday(dateexp)) as integer) = 7');
FDQuery1.Open;
if not FDQuery1.IsEmpty    then
begin
form1.Caption := 'La date d expiration du programme (AdsVer) est sur le point d expirer, pour les (02) jours restants';
form1.Show;
fmain.hide;
Tmr2.Enabled:=False;
Form1.tmr1.Enabled := True;
end
else
FDQuery1.Close;
FDQuery1.SQL.clear;
FDQuery1.SQL.add('Select *from diskdurtable where cast ((julianday("now") - julianday(dateexp)) as integer) = 8');
FDQuery1.Open;
if not FDQuery1.IsEmpty    then
begin
form1.Caption := 'La date d expiration du programme (AdsVer) est sur le point d expirer, pour les (01) jours restants';
form1.Show;
fmain.hide;
Tmr2.Enabled:=False;
Form1.tmr1.Enabled := True;
end
else
FDQuery1.Close;
 FDQuery1.SQL.clear;
FDQuery1.SQL.add('Select *from diskdurtable where cast ((julianday("now") - julianday(dateexp)) as integer) >= 9');
FDQuery1.Open;
if not FDQuery1.IsEmpty    then
begin
form1.Caption := 'La période d essai du programme est terminée. Merci de votre intérêt';
form1.btn2.Caption :='^^ Merci pour ton attention ^^';
form1.btn2.OnClick := form1.btn3Click ;
form1.Show;
fmain.hide;
Tmr2.Enabled:=False;

end;
tmr2.Enabled:=False;
tmr3.Enabled:=True;

end;

procedure TFmain.tmr3Timer(Sender: TObject);
var
 b: Integer;
begin

FDQuery1.SQL.Clear;
FDQuery1.SQL.add('Select *from diskdurtable  where diskkey = :d');
FDQuery1.ParamByName('d').Value  := edt7.Text;
FDQuery1.Open;
 if  FDQuery1.IsEmpty then
 begin
 tmr3.Enabled:= False;
 tmr4.Enabled:= true;
  b :=   MessageDlg('L installation du logiciel sur cet appareil a été modifiée sans licence.'+''+' Veuillez contacter le programmeur', mtWarning, [mbOK], 0) ;
 if b = mrok then
  close;

end;
tmr3.Enabled:= False;
end;

procedure TFmain.tmr4Timer(Sender: TObject);
begin
    Close;
end;

end.
