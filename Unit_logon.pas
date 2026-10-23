unit Unit_logon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Buttons, ExtCtrls;

type
  Tform_logon = class(TForm)
    ConexaoBD: TADOConnection;
    adoquery_login: TADOQuery;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edt_login: TEdit;
    edt_senha: TEdit;
    btn_entrar: TBitBtn;
    btn_sair: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    procedure btn_entrarClick(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_logon: Tform_logon;
  usuario_logado: string;

implementation

uses Unit_menu;

{$R *.dfm}

procedure Tform_logon.btn_entrarClick(Sender: TObject);
begin
  if(edt_login.Text = '') or (edt_senha.Text = '') then
  begin
    ShowMessage('Informe o Usuário e a Senha!');
    Exit;
  end;

  adoquery_login.Close;

  adoquery_login.SQL.Text := 'SELECT COD_FUNCIONARIO, NOME ' +
                             'FROM FUNCIONARIOS ' +
                             'WHERE LOGIN = ' + QuotedStr(edt_login.Text) +
                             ' AND SENHA = ' + QuotedStr(edt_senha.Text);

  adoquery_login.Open;

  if adoquery_login.IsEmpty then
  begin
    ShowMessage('Usuário ou Senha inválidos!');
    edt_senha.Clear;
    edt_senha.SetFocus;
  end
  else
  begin
    usuario_logado := adoquery_login.FieldByName('NOME').AsString;
    form_menu.Show;
    Hide;
  end;

  adoquery_login.Close;
end;

procedure Tform_logon.btn_sairClick(Sender: TObject);
begin
 Close;
end;
end.
