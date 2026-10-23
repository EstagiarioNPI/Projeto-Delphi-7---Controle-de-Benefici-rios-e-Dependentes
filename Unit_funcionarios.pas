unit Unit_funcionarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Buttons, Grids, DBGrids, ComCtrls, ExtCtrls;

type
  Tform_funcionarios = class(TForm)
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label9: TLabel;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    Label1: TLabel;
    edt_nome: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edt_salario: TEdit;
    Label4: TLabel;
    edt_login: TEdit;
    Label5: TLabel;
    edt_senha: TEdit;
    edt_cod: TEdit;
    edt_data_nascimento: TDateTimePicker;
    GroupBox3: TGroupBox;
    grid_funcionarios: TDBGrid;
    GroupBox4: TGroupBox;
    btn_novo: TBitBtn;
    btn_alterar: TBitBtn;
    btn_salvar: TBitBtn;
    btn_excluir: TBitBtn;
    btn_fechar: TBitBtn;
    ds_funcionarios: TDataSource;
    adoquery_funcionarios: TADOQuery;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure btn_alterarClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure edt_data_nascimentoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edt_salarioExit(Sender: TObject);
  private
    { Private declarations }
    operacao: string;
    pk: string;

    procedure bloqueia_campos;
    procedure desabilita_salvar;
    procedure habilita_salvar;
    procedure libera_campos;
    procedure limpa_campos;
  public
    { Public declarations }
  end;

var
  form_funcionarios: Tform_funcionarios;

implementation

uses Unit_logon;

{$R *.dfm}

procedure Tform_funcionarios.bloqueia_campos;
begin
  edt_cod.Enabled := False;
  edt_nome.Enabled := False;
  edt_data_nascimento.Enabled := False;
  edt_salario.Enabled := False;
  edt_login.Enabled := False;
  edt_senha.Enabled := False;
end;

procedure Tform_funcionarios.desabilita_salvar;
begin
  btn_salvar.Enabled := False;
  btn_novo.Enabled := True;
  btn_alterar.Enabled := True;
  btn_excluir.Enabled := True;
end;

procedure Tform_funcionarios.habilita_salvar;
begin
  btn_salvar.Enabled := True;
  btn_novo.Enabled := False;
  btn_alterar.Enabled := False;
  btn_excluir.Enabled := False;
end;

procedure Tform_funcionarios.libera_campos;
begin
  edt_cod.Enabled := false;
  edt_nome.Enabled := True;
  edt_data_nascimento.Enabled := True;
  edt_salario.Enabled := True;
  edt_login.Enabled := True;
  edt_senha.Enabled := True;
end;

procedure Tform_funcionarios.limpa_campos;
begin
  edt_cod.Clear;
  edt_nome.Clear;

  { O TDateTimePicker não utiliza Clear }
  edt_data_nascimento.Date := Date;

  edt_salario.Clear;
  edt_login.Clear;
  edt_senha.Clear;
end;

procedure Tform_funcionarios.FormShow(Sender: TObject);
begin
  adoquery_funcionarios.Close;

  adoquery_funcionarios.SQL.Text :=
    'SELECT COD_FUNCIONARIO, NOME, DATA_NASCIMENTO, ' +
    'SALARIO, LOGIN, SENHA ' +
    'FROM FUNCIONARIOS ' +
    'ORDER BY COD_FUNCIONARIO';

  adoquery_funcionarios.Open;

  limpa_campos;
  bloqueia_campos;
  desabilita_salvar;

  pk := '';
  operacao := '';
end;

procedure Tform_funcionarios.btn_novoClick(Sender: TObject);
begin
  operacao := 'novo';

  limpa_campos;

  //gera o código automaticamente
  adoquery_funcionarios.Close;
  adoquery_funcionarios.SQL.Text := 'SELECT ISNULL(MAX(COD_FUNCIONARIO),0) + 1 AS NOVO_CODIGO ' +
                                    'FROM FUNCIONARIOS';
  adoquery_funcionarios.Open;

  edt_cod.Text :=
    adoquery_funcionarios.FieldByName('NOVO_CODIGO').AsString;
    
  libera_campos;
  habilita_salvar;

  edt_nome.SetFocus;
end;

procedure Tform_funcionarios.btn_salvarClick(Sender: TObject);
var
  deuerro: Boolean;
  valor_salario: Double;
begin

  if (edt_cod.Text = '') or
     (edt_nome.Text = '') or
     (edt_salario.Text = '') or
     (edt_login.Text = '') or
     (edt_senha.Text = '') then
  begin
    ShowMessage('Preencha todos os campos!');
    Exit;
  end;

  { Converte o salário que está no formato R$ 2.345,00
    para um valor numérico }
  try
    valor_salario :=
  StrToFloat(
    StringReplace(
      StringReplace(
        edt_salario.Text,
        'R$', '',
        [rfReplaceAll]
      ),
      '.', '',
      [rfReplaceAll]
    )
  );
  except
    ShowMessage('Informe um salário válido!');
    edt_salario.SetFocus;
    Exit;
  end;

  { NOVO FUNCIONARIO }
  if operacao = 'novo' then
  begin

    adoquery_funcionarios.SQL.Text :=
      'INSERT INTO FUNCIONARIOS ' +
      '(COD_FUNCIONARIO, NOME, DATA_NASCIMENTO, SALARIO, LOGIN, SENHA) ' +
      'VALUES (:COD, :NOME, :DATA_NASCIMENTO, :SALARIO, :LOGIN, :SENHA)';

    adoquery_funcionarios.Parameters.ParamByName('COD').Value :=
      StrToInt(edt_cod.Text);

    adoquery_funcionarios.Parameters.ParamByName('NOME').Value :=
      edt_nome.Text;

    adoquery_funcionarios.Parameters.ParamByName('DATA_NASCIMENTO').Value :=
      edt_data_nascimento.Date;

    adoquery_funcionarios.Parameters.ParamByName('SALARIO').Value :=
      valor_salario;

    adoquery_funcionarios.Parameters.ParamByName('LOGIN').Value :=
      edt_login.Text;

    adoquery_funcionarios.Parameters.ParamByName('SENHA').Value :=
      edt_senha.Text;

  end

  { ALTERAR FUNCIONARIO }
  else
  if operacao = 'alterar' then
  begin

    adoquery_funcionarios.SQL.Text :=
      'UPDATE FUNCIONARIOS SET ' +
      'NOME = :NOME, ' +
      'DATA_NASCIMENTO = :DATA_NASCIMENTO, ' +
      'SALARIO = :SALARIO, ' +
      'LOGIN = :LOGIN, ' +
      'SENHA = :SENHA ' +
      'WHERE COD_FUNCIONARIO = :COD';

    adoquery_funcionarios.Parameters.ParamByName('NOME').Value :=
      edt_nome.Text;

    adoquery_funcionarios.Parameters.ParamByName('DATA_NASCIMENTO').Value :=
      edt_data_nascimento.Date;

    adoquery_funcionarios.Parameters.ParamByName('SALARIO').Value :=
      valor_salario;

    adoquery_funcionarios.Parameters.ParamByName('LOGIN').Value :=
      edt_login.Text;

    adoquery_funcionarios.Parameters.ParamByName('SENHA').Value :=
      edt_senha.Text;

    adoquery_funcionarios.Parameters.ParamByName('COD').Value :=
      StrToInt(pk);

  end;

  Form_logon.ConexaoBD.BeginTrans;

  try

    adoquery_funcionarios.ExecSQL;
    deuerro := False;

  except

    on E: Exception do
    begin
      deuerro := True;

      ShowMessage(
        'Ocorreu o seguinte erro: ' +
        E.Message
      );
    end;

  end;

  if deuerro then
  begin

    Form_logon.ConexaoBD.RollbackTrans;

  end
  else
  begin

    Form_logon.ConexaoBD.CommitTrans;

    pk := edt_cod.Text;

    desabilita_salvar;
    bloqueia_campos;

    adoquery_funcionarios.Close;

    adoquery_funcionarios.SQL.Text :=
      'SELECT COD_FUNCIONARIO, NOME, DATA_NASCIMENTO, ' +
      'SALARIO, LOGIN, SENHA ' +
      'FROM FUNCIONARIOS ' +
      'ORDER BY COD_FUNCIONARIO';

    adoquery_funcionarios.Open;

    ShowMessage('Registro salvo com sucesso!');

  end;

end;

procedure Tform_funcionarios.btn_alterarClick(Sender: TObject);
begin

  if adoquery_funcionarios.IsEmpty then
  begin
    ShowMessage('Selecione um funcionário!');
    Exit;
  end;

  pk :=
    adoquery_funcionarios.FieldByName(
    'COD_FUNCIONARIO').AsString;

  edt_cod.Text := pk;

  edt_nome.Text :=
    adoquery_funcionarios.FieldByName(
    'NOME').AsString;

  edt_data_nascimento.Date :=
    adoquery_funcionarios.FieldByName(
    'DATA_NASCIMENTO').AsDateTime;

  edt_salario.Text :=
    adoquery_funcionarios.FieldByName(
    'SALARIO').AsString;

  edt_login.Text :=
    adoquery_funcionarios.FieldByName(
    'LOGIN').AsString;

  edt_senha.Text :=
    adoquery_funcionarios.FieldByName(
    'SENHA').AsString;

  operacao := 'alterar';

  libera_campos;
  habilita_salvar;

  edt_nome.SetFocus;

end;

procedure Tform_funcionarios.btn_fecharClick(Sender: TObject);
begin
  Close;
end;

procedure Tform_funcionarios.btn_excluirClick(Sender: TObject);
var
  deuerro: Boolean;
begin

  if pk = '' then
  begin

    if not adoquery_funcionarios.IsEmpty then
      pk :=
        adoquery_funcionarios.FieldByName(
        'COD_FUNCIONARIO').AsString;

  end;

  if pk = '' then
  begin
    ShowMessage('Selecione um funcionário!');
    Exit;
  end;

  if MessageDlg(
       'Deseja realmente excluir este funcionário?',
       mtConfirmation,
       [mbYes, mbNo],
       0
     ) <> mrYes then
    Exit;

  adoquery_funcionarios.SQL.Text :=
    'DELETE FROM FUNCIONARIOS ' +
    'WHERE COD_FUNCIONARIO = ' + pk;

  Form_logon.ConexaoBD.BeginTrans;

  try

    adoquery_funcionarios.ExecSQL;
    deuerro := False;

  except

    on E: Exception do
    begin
      deuerro := True;

      ShowMessage(
        'Não foi possível excluir o funcionário!' +
        #13#10 +
        E.Message
      );
    end;

  end;

  if deuerro then
  begin

    Form_logon.ConexaoBD.RollbackTrans;

  end
  else
  begin

    Form_logon.ConexaoBD.CommitTrans;

    pk := '';

    limpa_campos;
    bloqueia_campos;
    desabilita_salvar;

    adoquery_funcionarios.Close;

    adoquery_funcionarios.SQL.Text :=
      'SELECT COD_FUNCIONARIO, NOME, DATA_NASCIMENTO, ' +
      'SALARIO, LOGIN, SENHA ' +
      'FROM FUNCIONARIOS ' +
      'ORDER BY COD_FUNCIONARIO';

    adoquery_funcionarios.Open;

    ShowMessage('Funcionário excluído com sucesso!');

  end;

end;

procedure Tform_funcionarios.edt_data_nascimentoKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  { ENTER -> passa para o próximo segmento }
  if Key = VK_RETURN then
  begin
    Key := 0;

    keybd_event(VK_RIGHT, 0, 0, 0);
    keybd_event(VK_RIGHT, 0, KEYEVENTF_KEYUP, 0);
  end;

end;

procedure Tform_funcionarios.edt_salarioExit(Sender: TObject);
var
  texto: string;
  valor: Double;
begin
  texto := Trim(edt_salario.Text);

  if texto = '' then
    Exit;

  { Remove R$ }
  texto := StringReplace(texto, 'R$', '', [rfReplaceAll]);
  texto := Trim(texto);

  { Se tiver virgula, significa que esta no formato brasileiro:
    7.000,00 }
  if Pos(',', texto) > 0 then
  begin
    texto := StringReplace(texto, '.', '', [rfReplaceAll]);
  end
  else
  begin
    { Se tiver somente ponto, veio do banco:
      7000.00 }
    texto := StringReplace(texto, '.', ',', [rfReplaceAll]);
  end;

  valor := StrToFloat(texto);

  edt_salario.Text :=
    FormatFloat('R$ #,##0.00', valor);
end;

end.
