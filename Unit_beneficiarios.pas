unit Unit_beneficiarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Grids, DBGrids, DB, ADODB;

type
  Tform_beneficiarios = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;

    gb_lista_beneficiario: TGroupBox;

    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;

    edt_data_nascimento_beneficiario: TDateTimePicker;
    edt_nome_beneficiario: TEdit;
    edt_cod_beneficiario: TEdit;
    edt_valor_plano: TEdit;

    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;

    edt_data_nascimento_dependente: TDateTimePicker;
    edt_nome_dependente: TEdit;
    edt_cod_beneficiario_dep: TEdit;
    cmb_parentesco: TComboBox;

    btn_salvar_dependente: TBitBtn;
    btn_alterar_dependente: TBitBtn;
    btn_excluir_dependente: TBitBtn;

    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    gb_lista_dependentes: TGroupBox;

    grid_beneficiarios: TDBGrid;
    grid_dependentes: TDBGrid;

    btn_novo_beneficiario: TBitBtn;
    btn_alterar_beneficiario: TBitBtn;
    btn_salvar_beneficiario: TBitBtn;
    btn_excluir_beneficiario: TBitBtn;
    btn_fechar: TBitBtn;

    adoquery_beneficiarios: TADOQuery;
    ds_beneficiarios: TDataSource;

    Label11: TLabel;
    edt_cod_dependente: TEdit;
    btn_novo_dependente: TBitBtn;

    adoquery_dependentes: TADOQuery;
    ds_dependentes: TDataSource;

    procedure FormShow(Sender: TObject);

    procedure btn_novo_beneficiarioClick(Sender: TObject);
    procedure edt_valor_planoExit(Sender: TObject);
    procedure btn_salvar_beneficiarioClick(Sender: TObject);
    procedure btn_alterar_beneficiarioClick(Sender: TObject);
    procedure grid_beneficiariosCellClick(Column: TColumn);
    procedure btn_excluir_beneficiarioClick(Sender: TObject);

    procedure btn_novo_dependenteClick(Sender: TObject);
    procedure btn_salvar_dependenteClick(Sender: TObject);
    procedure grid_dependentesCellClick(Column: TColumn);
    procedure btn_alterar_dependenteClick(Sender: TObject);
    procedure btn_excluir_dependenteClick(Sender: TObject);

    procedure btn_fecharClick(Sender: TObject);

    procedure edt_data_nascimento_beneficiarioKeyDown(
      Sender: TObject;
      var Key: Word;
      Shift: TShiftState);

    procedure edt_data_nascimento_dependenteKeyDown(
      Sender: TObject;
      var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }

    operacao_beneficiario: string;
    operacao_dependente: string;

    pk_beneficiario: string;
    pk_dependente: string;

    procedure bloqueia_campos_beneficiario;
    procedure libera_campos_beneficiario;
    procedure limpa_campos_beneficiario;

    procedure bloqueia_campos_dependente;
    procedure libera_campos_dependente;
    procedure limpa_campos_dependente;

    procedure carrega_beneficiarios;
    procedure carrega_dependentes;

    function textoMoedaParaFloat(Texto: string): Double;

  public
    { Public declarations }
  end;

var
  form_beneficiarios: Tform_beneficiarios;

implementation

uses
  Unit_logon;

{$R *.dfm}

{ ========================================================= }
{ CONTROLE DOS CAMPOS DO BENEFICIARIO                      }
{ ========================================================= }

procedure Tform_beneficiarios.bloqueia_campos_beneficiario;
begin
  edt_cod_beneficiario.Enabled := False;
  edt_nome_beneficiario.Enabled := False;
  edt_data_nascimento_beneficiario.Enabled := False;
  edt_valor_plano.Enabled := False;
end;


procedure Tform_beneficiarios.libera_campos_beneficiario;
begin
  { O código continua bloqueado porque é automático }
  edt_cod_beneficiario.Enabled := False;

  edt_nome_beneficiario.Enabled := True;
  edt_data_nascimento_beneficiario.Enabled := True;
  edt_valor_plano.Enabled := True;
end;


procedure Tform_beneficiarios.limpa_campos_beneficiario;
begin
  edt_cod_beneficiario.Clear;
  edt_nome_beneficiario.Clear;

  edt_data_nascimento_beneficiario.Date := Date;

  edt_valor_plano.Clear;
end;


{ ========================================================= }
{ CONTROLE DOS CAMPOS DO DEPENDENTE                        }
{ ========================================================= }

procedure Tform_beneficiarios.bloqueia_campos_dependente;
begin
  { Código do beneficiário é automático }
  edt_cod_beneficiario_dep.Enabled := False;

  { Código do dependente é automático }
  edt_cod_dependente.Enabled := False;

  edt_nome_dependente.Enabled := False;

  edt_data_nascimento_dependente.Enabled := False;

  cmb_parentesco.Enabled := False;
end;


procedure Tform_beneficiarios.libera_campos_dependente;
begin
  { Ambos os códigos são automáticos }
  edt_cod_beneficiario_dep.Enabled := False;
  edt_cod_dependente.Enabled := False;

  edt_nome_dependente.Enabled := True;

  edt_data_nascimento_dependente.Enabled := True;

  cmb_parentesco.Enabled := True;
end;


procedure Tform_beneficiarios.limpa_campos_dependente;
begin
  edt_cod_beneficiario_dep.Clear;

  edt_cod_dependente.Clear;

  edt_nome_dependente.Clear;

  edt_data_nascimento_dependente.Date := Date;

  cmb_parentesco.ItemIndex := -1;
end;


{ ========================================================= }
{ CARREGA BENEFICIARIOS                                    }
{ ========================================================= }

procedure Tform_beneficiarios.carrega_beneficiarios;
begin
  adoquery_beneficiarios.Close;

  adoquery_beneficiarios.SQL.Text :=
    'SELECT COD_BENEFICIARIO, ' +
    'NOME, ' +
    'DATA_NASCIMENTO, ' +
    'VALOR_PLANO ' +
    'FROM BENEFICIARIOS ' +
    'ORDER BY NOME';

  adoquery_beneficiarios.Open;
end;


{ ========================================================= }
{ CARREGA DEPENDENTES DO BENEFICIARIO SELECIONADO          }
{ ========================================================= }

procedure Tform_beneficiarios.carrega_dependentes;
begin
  adoquery_dependentes.Close;

  { Nenhum beneficiário selecionado }
  if pk_beneficiario = '' then
  begin
    adoquery_dependentes.SQL.Text :=
      'SELECT COD_DEPENDENTE, ' +
      'COD_BENEFICIARIO, ' +
      'NOME, ' +
      'DATA_NASCIMENTO, ' +
      'GRAU_PARENTESCO ' +
      'FROM DEPENDENTES ' +
      'WHERE 1 = 0';

    adoquery_dependentes.Open;

    Exit;
  end;

  { Mostra somente os dependentes do beneficiário selecionado }
  adoquery_dependentes.SQL.Text :=
    'SELECT COD_DEPENDENTE, ' +
    'COD_BENEFICIARIO, ' +
    'NOME, ' +
    'DATA_NASCIMENTO, ' +
    'GRAU_PARENTESCO ' +
    'FROM DEPENDENTES ' +
    'WHERE COD_BENEFICIARIO = :COD_BENEFICIARIO ' +
    'ORDER BY NOME';

  adoquery_dependentes.Parameters.ParamByName(
    'COD_BENEFICIARIO').Value :=
    StrToInt(pk_beneficiario);

  adoquery_dependentes.Open;
end;


{ ========================================================= }
{ FORM SHOW                                                }
{ ========================================================= }

procedure Tform_beneficiarios.FormShow(Sender: TObject);
begin
  pk_beneficiario := '';
  pk_dependente := '';

  operacao_beneficiario := '';
  operacao_dependente := '';

  limpa_campos_beneficiario;
  limpa_campos_dependente;

  bloqueia_campos_beneficiario;
  bloqueia_campos_dependente;

  carrega_beneficiarios;
  carrega_dependentes;
end;


{ ========================================================= }
{ NOVO BENEFICIARIO                                        }
{ ========================================================= }

procedure TForm_beneficiarios.btn_novo_beneficiarioClick(
  Sender: TObject);
begin
  operacao_beneficiario := 'novo';

  limpa_campos_beneficiario;

  { Gera automaticamente o próximo código }
  adoquery_beneficiarios.Close;

  adoquery_beneficiarios.SQL.Text :=
    'SELECT ISNULL(MAX(COD_BENEFICIARIO),0) + 1 AS NOVO_CODIGO ' +
    'FROM BENEFICIARIOS';

  adoquery_beneficiarios.Open;

  edt_cod_beneficiario.Text :=
    adoquery_beneficiarios.FieldByName(
      'NOVO_CODIGO').AsString;

  libera_campos_beneficiario;

  edt_nome_beneficiario.SetFocus;
end;


{ ========================================================= }
{ CONVERSAO DO VALOR DO PLANO                              }
{ ========================================================= }

function TForm_beneficiarios.textoMoedaParaFloat(
  Texto: string): Double;
var
  PosVirgula: Integer;
  PosPonto: Integer;
begin
  Texto := Trim(Texto);

  Texto := StringReplace(
    Texto,
    'R$',
    '',
    [rfReplaceAll]
  );

  Texto := Trim(Texto);

  if Texto = '' then
  begin
    Result := 0;
    Exit;
  end;

  PosVirgula := LastDelimiter(',', Texto);
  PosPonto := LastDelimiter('.', Texto);

  { Caso brasileiro:
    7.000,00
    250,50
    1.250,75
  }
  if PosVirgula > 0 then
  begin
    Texto := StringReplace(
      Texto,
      '.',
      '',
      [rfReplaceAll]
    );

    Texto := StringReplace(
      Texto,
      ',',
      DecimalSeparator,
      [rfReplaceAll]
    );
  end

  { Caso venha no formato 7000.00 }
  else if PosPonto > 0 then
  begin
    { Se houver somente um ponto e duas casas depois,
      consideramos como separador decimal }
    if Length(Texto) - PosPonto <= 2 then
    begin
      Texto := StringReplace(
        Texto,
        '.',
        DecimalSeparator,
        [rfReplaceAll]
      );
    end
    else
    begin
      { Caso seja separador de milhar }
      Texto := StringReplace(
        Texto,
        '.',
        '',
        [rfReplaceAll]
      );
    end;
  end;

  Result := StrToFloat(Texto);
end;


{ ========================================================= }
{ FORMATACAO DO VALOR DO PLANO                             }
{ ========================================================= }

procedure TForm_beneficiarios.edt_valor_planoExit(
  Sender: TObject);
var
  valor: Double;
begin
  if Trim(edt_valor_plano.Text) = '' then
    Exit;

  try
    valor := textoMoedaParaFloat(
      edt_valor_plano.Text);

    edt_valor_plano.Text :=
      FormatFloat(
        'R$ #,##0.00',
        valor
      );
  except
    on E: Exception do
    begin
      ShowMessage(
        'Informe um valor válido para o plano.'
      );

      edt_valor_plano.SetFocus;
    end;
  end;
end;


{ ========================================================= }
{ SALVAR BENEFICIARIO                                      }
{ ========================================================= }

procedure TForm_beneficiarios.btn_salvar_beneficiarioClick(
  Sender: TObject);
var
  valor_plano: Double;
begin
  if Trim(edt_nome_beneficiario.Text) = '' then
  begin
    ShowMessage(
      'Informe o nome do beneficiário.');

    edt_nome_beneficiario.SetFocus;

    Exit;
  end;

  if Trim(edt_valor_plano.Text) = '' then
  begin
    ShowMessage(
      'Informe o valor do plano.');

    edt_valor_plano.SetFocus;

    Exit;
  end;

  try
    valor_plano :=
      textoMoedaParaFloat(
        edt_valor_plano.Text);

    { ===================================================== }
    { NOVO                                                  }
    { ===================================================== }

    if operacao_beneficiario = 'novo' then
    begin
      adoquery_beneficiarios.Close;

      adoquery_beneficiarios.SQL.Text :=
        'INSERT INTO BENEFICIARIOS ' +
        '(COD_BENEFICIARIO, NOME, DATA_NASCIMENTO, VALOR_PLANO) ' +
        'VALUES ' +
        '(:COD, :NOME, :DATA_NASCIMENTO, :VALOR_PLANO)';

      adoquery_beneficiarios.Parameters.ParamByName(
        'COD').Value :=
        StrToInt(edt_cod_beneficiario.Text);

      adoquery_beneficiarios.Parameters.ParamByName(
        'NOME').Value :=
        edt_nome_beneficiario.Text;

      adoquery_beneficiarios.Parameters.ParamByName(
        'DATA_NASCIMENTO').Value :=
        edt_data_nascimento_beneficiario.Date;

      adoquery_beneficiarios.Parameters.ParamByName(
        'VALOR_PLANO').Value :=
        valor_plano;

      adoquery_beneficiarios.ExecSQL;

      ShowMessage(
        'Beneficiário cadastrado com sucesso!');
    end

    { ===================================================== }
    { ALTERAR                                               }
    { ===================================================== }

    else if operacao_beneficiario = 'alterar' then
    begin
      adoquery_beneficiarios.Close;

      adoquery_beneficiarios.SQL.Text :=
        'UPDATE BENEFICIARIOS SET ' +
        'NOME = :NOME, ' +
        'DATA_NASCIMENTO = :DATA_NASCIMENTO, ' +
        'VALOR_PLANO = :VALOR_PLANO ' +
        'WHERE COD_BENEFICIARIO = :COD';

      adoquery_beneficiarios.Parameters.ParamByName(
        'NOME').Value :=
        edt_nome_beneficiario.Text;

      adoquery_beneficiarios.Parameters.ParamByName(
        'DATA_NASCIMENTO').Value :=
        edt_data_nascimento_beneficiario.Date;

      adoquery_beneficiarios.Parameters.ParamByName(
        'VALOR_PLANO').Value :=
        valor_plano;

      adoquery_beneficiarios.Parameters.ParamByName(
        'COD').Value :=
        StrToInt(edt_cod_beneficiario.Text);

      adoquery_beneficiarios.ExecSQL;

      ShowMessage(
        'Beneficiário alterado com sucesso!');
    end;

    pk_beneficiario :=
      edt_cod_beneficiario.Text;

    operacao_beneficiario := '';

    bloqueia_campos_beneficiario;

    carrega_beneficiarios;

    carrega_dependentes;

  except
    on E: Exception do
      ShowMessage(
        'Ocorreu um erro: ' + E.Message);
  end;
end;


{ ========================================================= }
{ ALTERAR BENEFICIARIO                                     }
{ ========================================================= }

procedure TForm_beneficiarios.btn_alterar_beneficiarioClick(
  Sender: TObject);
begin
  if pk_beneficiario = '' then
  begin
    ShowMessage(
      'Selecione um beneficiário.');

    Exit;
  end;

  operacao_beneficiario := 'alterar';

  libera_campos_beneficiario;

  edt_nome_beneficiario.SetFocus;
end;


{ ========================================================= }
{ SELECIONAR BENEFICIARIO NO GRID                          }
{ ========================================================= }

procedure TForm_beneficiarios.grid_beneficiariosCellClick(
  Column: TColumn);
begin
  if adoquery_beneficiarios.IsEmpty then
    Exit;

  pk_beneficiario :=
    adoquery_beneficiarios.FieldByName(
      'COD_BENEFICIARIO').AsString;

  edt_cod_beneficiario.Text :=
    pk_beneficiario;

  edt_nome_beneficiario.Text :=
    adoquery_beneficiarios.FieldByName(
      'NOME').AsString;

  edt_data_nascimento_beneficiario.Date :=
    adoquery_beneficiarios.FieldByName(
      'DATA_NASCIMENTO').AsDateTime;

  edt_valor_plano.Text :=
    FormatFloat(
      'R$ #,##0.00',
      adoquery_beneficiarios.FieldByName(
        'VALOR_PLANO').AsFloat
    );

  { Preenche automaticamente o código do beneficiário
    na área de dependentes }
  edt_cod_beneficiario_dep.Text :=
    pk_beneficiario;

  pk_dependente := '';

  edt_cod_dependente.Clear;
  edt_nome_dependente.Clear;
  edt_data_nascimento_dependente.Date := Date;
  cmb_parentesco.ItemIndex := -1;

  bloqueia_campos_beneficiario;
  bloqueia_campos_dependente;

  carrega_dependentes;
end;


{ ========================================================= }
{ NOVO DEPENDENTE                                          }
{ ========================================================= }

procedure TForm_beneficiarios.btn_novo_dependenteClick(
  Sender: TObject);
begin
  if pk_beneficiario = '' then
  begin
    ShowMessage(
      'Selecione primeiro um beneficiário.');

    Exit;
  end;

  operacao_dependente := 'novo';

  pk_dependente := '';

  limpa_campos_dependente;

  { O código do beneficiário vem do beneficiário selecionado }
  edt_cod_beneficiario_dep.Text :=
    pk_beneficiario;

  { Data inicial }
  edt_data_nascimento_dependente.Date := Date;

  { Gera automaticamente o próximo código do dependente }
  adoquery_dependentes.Close;

  adoquery_dependentes.SQL.Text :=
    'SELECT ISNULL(MAX(COD_DEPENDENTE),0) + 1 AS NOVO_CODIGO ' +
    'FROM DEPENDENTES';

  adoquery_dependentes.Open;

  edt_cod_dependente.Text :=
    adoquery_dependentes.FieldByName(
      'NOVO_CODIGO').AsString;

  libera_campos_dependente;

  edt_nome_dependente.SetFocus;
end;


{ ========================================================= }
{ SALVAR DEPENDENTE                                        }
{ ========================================================= }

procedure TForm_beneficiarios.btn_salvar_dependenteClick(
  Sender: TObject);
begin
  if pk_beneficiario = '' then
  begin
    ShowMessage(
      'Selecione primeiro um beneficiário.');

    Exit;
  end;

  if Trim(edt_nome_dependente.Text) = '' then
  begin
    ShowMessage(
      'Informe o nome do dependente.');

    edt_nome_dependente.SetFocus;

    Exit;
  end;

  if cmb_parentesco.ItemIndex = -1 then
  begin
    ShowMessage(
      'Selecione o grau de parentesco.');

    cmb_parentesco.SetFocus;

    Exit;
  end;

  try

    { ===================================================== }
    { NOVO DEPENDENTE                                       }
    { ===================================================== }

    if operacao_dependente = 'novo' then
    begin
      adoquery_dependentes.Close;

      adoquery_dependentes.SQL.Text :=
        'INSERT INTO DEPENDENTES ' +
        '(COD_DEPENDENTE, COD_BENEFICIARIO, NOME, ' +
        'DATA_NASCIMENTO, GRAU_PARENTESCO) ' +
        'VALUES ' +
        '(:COD, :COD_BENEFICIARIO, :NOME, ' +
        ':DATA_NASCIMENTO, :PARENTESCO)';

      adoquery_dependentes.Parameters.ParamByName(
        'COD').Value :=
        StrToInt(edt_cod_dependente.Text);

      adoquery_dependentes.Parameters.ParamByName(
        'COD_BENEFICIARIO').Value :=
        StrToInt(edt_cod_beneficiario_dep.Text);

      adoquery_dependentes.Parameters.ParamByName(
        'NOME').Value :=
        edt_nome_dependente.Text;

      adoquery_dependentes.Parameters.ParamByName(
        'DATA_NASCIMENTO').Value :=
        edt_data_nascimento_dependente.Date;

      adoquery_dependentes.Parameters.ParamByName(
        'PARENTESCO').Value :=
        cmb_parentesco.Text;

      adoquery_dependentes.ExecSQL;

      ShowMessage(
        'Dependente cadastrado com sucesso!');
    end

    { ===================================================== }
    { ALTERAR DEPENDENTE                                    }
    { ===================================================== }

    else if operacao_dependente = 'alterar' then
    begin
      adoquery_dependentes.Close;

      adoquery_dependentes.SQL.Text :=
        'UPDATE DEPENDENTES SET ' +
        'NOME = :NOME, ' +
        'DATA_NASCIMENTO = :DATA_NASCIMENTO, ' +
        'GRAU_PARENTESCO = :PARENTESCO ' +
        'WHERE COD_DEPENDENTE = :COD ' +
        'AND COD_BENEFICIARIO = :COD_BENEFICIARIO';

      adoquery_dependentes.Parameters.ParamByName(
        'NOME').Value :=
        edt_nome_dependente.Text;

      adoquery_dependentes.Parameters.ParamByName(
        'DATA_NASCIMENTO').Value :=
        edt_data_nascimento_dependente.Date;

      adoquery_dependentes.Parameters.ParamByName(
        'PARENTESCO').Value :=
        cmb_parentesco.Text;

      adoquery_dependentes.Parameters.ParamByName(
        'COD').Value :=
        StrToInt(edt_cod_dependente.Text);

      adoquery_dependentes.Parameters.ParamByName(
        'COD_BENEFICIARIO').Value :=
        StrToInt(edt_cod_beneficiario_dep.Text);

      adoquery_dependentes.ExecSQL;

      ShowMessage(
        'Dependente alterado com sucesso!');
    end;

    pk_dependente :=
      edt_cod_dependente.Text;

    operacao_dependente := '';

    bloqueia_campos_dependente;

    carrega_dependentes;

  except
    on E: Exception do
      ShowMessage(
        'Ocorreu um erro: ' + E.Message);
  end;
end;


{ ========================================================= }
{ SELECIONAR DEPENDENTE NO GRID                            }
{ ========================================================= }

procedure TForm_beneficiarios.grid_dependentesCellClick(
  Column: TColumn);
begin
  if adoquery_dependentes.IsEmpty then
    Exit;

  pk_dependente :=
    adoquery_dependentes.FieldByName(
      'COD_DEPENDENTE').AsString;

  edt_cod_dependente.Text :=
    pk_dependente;

  edt_cod_beneficiario_dep.Text :=
    adoquery_dependentes.FieldByName(
      'COD_BENEFICIARIO').AsString;

  edt_nome_dependente.Text :=
    adoquery_dependentes.FieldByName(
      'NOME').AsString;

  { CARREGA A DATA DE NASCIMENTO DO DEPENDENTE }
  edt_data_nascimento_dependente.Date :=
    adoquery_dependentes.FieldByName(
      'DATA_NASCIMENTO').AsDateTime;

  { Carrega o grau de parentesco no ComboBox }
  cmb_parentesco.ItemIndex :=
    cmb_parentesco.Items.IndexOf(
      adoquery_dependentes.FieldByName(
        'GRAU_PARENTESCO').AsString
    );

  bloqueia_campos_dependente;
end;


{ ========================================================= }
{ ALTERAR DEPENDENTE                                       }
{ ========================================================= }

procedure TForm_beneficiarios.btn_alterar_dependenteClick(
  Sender: TObject);
begin
  if pk_dependente = '' then
  begin
    ShowMessage(
      'Selecione um dependente.');

    Exit;
  end;

  operacao_dependente := 'alterar';

  libera_campos_dependente;

  edt_nome_dependente.SetFocus;
end;


{ ========================================================= }
{ EXCLUIR DEPENDENTE                                       }
{ ========================================================= }

procedure TForm_beneficiarios.btn_excluir_dependenteClick(
  Sender: TObject);
begin
  if pk_dependente = '' then
  begin
    ShowMessage(
      'Selecione um dependente.');

    Exit;
  end;

  if MessageDlg(
    'Deseja realmente excluir este dependente?',
    mtConfirmation,
    [mbYes, mbNo],
    0) <> mrYes then
    Exit;

  try

    adoquery_dependentes.Close;

    adoquery_dependentes.SQL.Text :=
      'DELETE FROM DEPENDENTES ' +
      'WHERE COD_DEPENDENTE = :COD ' +
      'AND COD_BENEFICIARIO = :COD_BENEFICIARIO';

    adoquery_dependentes.Parameters.ParamByName(
      'COD').Value :=
      StrToInt(pk_dependente);

    adoquery_dependentes.Parameters.ParamByName(
      'COD_BENEFICIARIO').Value :=
      StrToInt(edt_cod_beneficiario_dep.Text);

    adoquery_dependentes.ExecSQL;

    ShowMessage(
      'Dependente excluído com sucesso!');

    pk_dependente := '';

    limpa_campos_dependente;

    { Mantém o beneficiário selecionado }
    edt_cod_beneficiario_dep.Text :=
      pk_beneficiario;

    bloqueia_campos_dependente;

    carrega_dependentes;

  except
    on E: Exception do
      ShowMessage(
        'Ocorreu um erro: ' + E.Message);
  end;
end;


{ ========================================================= }
{ EXCLUIR BENEFICIARIO                                     }
{ ========================================================= }

procedure TForm_beneficiarios.btn_excluir_beneficiarioClick(
  Sender: TObject);
begin
  if pk_beneficiario = '' then
  begin
    ShowMessage(
      'Selecione um beneficiário.');

    Exit;
  end;

  { Primeiro verifica se existem dependentes }
  adoquery_dependentes.Close;

  adoquery_dependentes.SQL.Text :=
    'SELECT COD_DEPENDENTE ' +
    'FROM DEPENDENTES ' +
    'WHERE COD_BENEFICIARIO = :COD';

  adoquery_dependentes.Parameters.ParamByName(
    'COD').Value :=
    StrToInt(pk_beneficiario);

  adoquery_dependentes.Open;

  if not adoquery_dependentes.IsEmpty then
  begin
    ShowMessage(
      'Não é possível excluir este beneficiário, ' +
      'pois existem dependentes cadastrados para ele.');

    Exit;
  end;

  if MessageDlg(
    'Deseja realmente excluir este beneficiário?',
    mtConfirmation,
    [mbYes, mbNo],
    0) <> mrYes then
    Exit;

  try

    adoquery_beneficiarios.Close;

    adoquery_beneficiarios.SQL.Text :=
      'DELETE FROM BENEFICIARIOS ' +
      'WHERE COD_BENEFICIARIO = :COD';

    adoquery_beneficiarios.Parameters.ParamByName(
      'COD').Value :=
      StrToInt(pk_beneficiario);

    adoquery_beneficiarios.ExecSQL;

    ShowMessage(
      'Beneficiário excluído com sucesso!');

    pk_beneficiario := '';
    pk_dependente := '';

    operacao_beneficiario := '';
    operacao_dependente := '';

    limpa_campos_beneficiario;
    limpa_campos_dependente;

    bloqueia_campos_beneficiario;
    bloqueia_campos_dependente;

    carrega_beneficiarios;
    carrega_dependentes;

  except
    on E: Exception do
      ShowMessage(
        'Ocorreu um erro: ' + E.Message);
  end;
end;


{ ========================================================= }
{ FECHAR FORMULARIO                                        }
{ ========================================================= }

procedure Tform_beneficiarios.btn_fecharClick(
  Sender: TObject);
begin
  Close;
end;


{ ========================================================= }
{ DATA DE NASCIMENTO DO BENEFICIARIO                      }
{ ENTER = PROXIMO SEGMENTO                                }
{ ========================================================= }

procedure TForm_beneficiarios.edt_data_nascimento_beneficiarioKeyDown(
  Sender: TObject;
  var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;

    keybd_event(
      VK_RIGHT,
      0,
      0,
      0);

    keybd_event(
      VK_RIGHT,
      0,
      KEYEVENTF_KEYUP,
      0);
  end;
end;


{ ========================================================= }
{ DATA DE NASCIMENTO DO DEPENDENTE                         }
{ ENTER = PROXIMO SEGMENTO                                }
{ ========================================================= }

procedure TForm_beneficiarios.edt_data_nascimento_dependenteKeyDown(
  Sender: TObject;
  var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;

    keybd_event(
      VK_RIGHT,
      0,
      0,
      0);

    keybd_event(
      VK_RIGHT,
      0,
      KEYEVENTF_KEYUP,
      0);
  end;
end;

end.
