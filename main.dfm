object Fmain: TFmain
  Left = 0
  Top = 0
  ClientHeight = 451
  ClientWidth = 761
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    761
    451)
  TextHeight = 15
  object sw: TToggleSwitch
    Left = 191
    Top = -8
    Width = 170
    Height = 61
    Anchors = [akTop]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    StateCaptions.CaptionOn = 'ativate licence'
    StateCaptions.CaptionOff = 'discativate licence'
    TabOrder = 0
  end
  object edt8: TEdit
    Left = 144
    Top = 52
    Width = 305
    Height = 27
    Alignment = taCenter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 1
    OnChange = edt8Change
  end
  object btn6: TButton
    Left = 200
    Top = 85
    Width = 193
    Height = 44
    Caption = 'rest Licence trail '
    TabOrder = 2
    OnClick = btn6Click
  end
  object edt7: TEdit
    Left = 144
    Top = 152
    Width = 305
    Height = 23
    Alignment = taCenter
    ReadOnly = True
    TabOrder = 3
  end
  object FireTaskList: TFDConnection
    Params.Strings = (
      'Database=tasks.s3db'
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = FireTaskListAfterConnect
    BeforeConnect = FireTaskListBeforeConnect
    Left = 544
    Top = 164
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 540
    Top = 225
  end
  object tmr4: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = tmr4Timer
    Left = 204
    Top = 391
  end
  object tmr3: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = tmr3Timer
    Left = 204
    Top = 335
  end
  object FDQuery1: TFDQuery
    Connection = FireTaskList
    SQL.Strings = (
      'Select *from diskdurtable ')
    Left = 548
    Top = 296
  end
  object tmr2: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmr2Timer
    Left = 200
    Top = 266
  end
end
