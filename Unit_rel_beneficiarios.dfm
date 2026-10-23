object form_rel_beneficiarios: Tform_rel_beneficiarios
  Left = 192
  Top = 97
  Width = 1044
  Height = 540
  Caption = 'S'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 392
    Top = 104
    Width = 125
    Height = 13
    Caption = 'Relat'#243'rio dos Benefici'#225'rios'
  end
  object btn_visualizar: TBitBtn
    Left = 232
    Top = 176
    Width = 601
    Height = 121
    Caption = 'Visualizar relat'#243'rio'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btn_visualizarClick
  end
  object adoquery_rel_beneficiarios: TADOQuery
    Connection = form_logon.ConexaoBD
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT COD_BENEFICIARIO, NOME AS NOME_BENEFICIARIO '#10
      'FROM BENEFICIARIOS '#10
      'ORDER BY COD_BENEFICIARIO'#10)
    Left = 392
    Top = 128
  end
  object RvProject1: TRvProject
    ProjectFile = 
      'C:\Users\PC\Desktop\Benefici'#225'rios e Dependentes\Relatorios\rel_b' +
      'eneficiarios.rav'
    Left = 440
    Top = 128
  end
  object RvDataSetConnection1: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = adoquery_rel_beneficiarios
    Left = 480
    Top = 128
  end
  object adoquery_rel_dependentes: TADOQuery
    Connection = form_logon.ConexaoBD
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT '#10
      '  B.COD_BENEFICIARIO,'#10
      '  B.NOME AS NOME_BENEFICIARIO,'#10
      '  D.COD_DEPENDENTE,'#10
      '  D.NOME AS NOME_DEPENDENTE,'#10
      '  D.GRAU_PARENTESCO'#10
      'FROM BENEFICIARIOS B'#10
      'INNER JOIN DEPENDENTES D '#10
      '  ON D.COD_BENEFICIARIO = B.COD_BENEFICIARIO'#10
      'ORDER BY '#10
      '  B.COD_BENEFICIARIO,'#10
      '  D.COD_DEPENDENTE'#10)
    Left = 392
    Top = 312
  end
  object rel_dependentes: TRvProject
    ProjectFile = 
      'C:\Users\PC\Desktop\Beneficiarios e Dependentes\Relatorios\rel_d' +
      'ependentes2.rav'
    Left = 440
    Top = 312
  end
  object ds_rel_dependentes: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = adoquery_rel_dependentes
    Left = 480
    Top = 312
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 624
    Top = 72
  end
end
