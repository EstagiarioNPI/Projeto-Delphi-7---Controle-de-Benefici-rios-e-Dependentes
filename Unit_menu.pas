unit Unit_menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Unit_logon, Menus;

type
  Tform_menu = class(TForm)
    btn_funcionarios: TBitBtn;
    btn_beneficiarios: TBitBtn;
    btn_fechar: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    bvSeparador: TBevel;
    Label2: TLabel;
    Image1: TImage;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    btn_relatorios: TBitBtn;
    PopupMenuRelatorios: TPopupMenu;
    mi_rel_beneficiarios: TMenuItem;
    mi_rel_dependentes: TMenuItem;
    procedure btn_funcionariosClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
    procedure btn_beneficiariosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btn_relatoriosClick(Sender: TObject);
    procedure mi_rel_beneficiariosClick(Sender: TObject);
    procedure mi_rel_dependentesClick(Sender: TObject);
    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_menu: Tform_menu;

implementation

uses Unit_funcionarios, Unit_beneficiarios, Unit_rel_beneficiarios;

{$R *.dfm}

procedure Tform_menu.btn_funcionariosClick(Sender: TObject);
begin
  form_funcionarios.ShowModal;
end;

procedure Tform_menu.btn_fecharClick(Sender: TObject);
begin
  Close;
end;

procedure Tform_menu.btn_beneficiariosClick(Sender: TObject);
begin
  form_beneficiarios.ShowModal;
end;

procedure Tform_menu.FormShow(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Controle de Beneficiários e Dependentes';

  StatusBar1.Panels[1].Text := 'Usuário: ' + usuario_logado;

  StatusBar1.Panels[2].Text := FormatDateTime('dd/MM/yyyy hh:nn:ss', Now);
end;

procedure Tform_menu.Timer1Timer(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := FormatDateTime('dd/MM/yyyy hh:nn:ss', Now);
end;

procedure Tform_menu.btn_relatoriosClick(Sender: TObject);
var
   p: TPoint;
begin
  P := btn_relatorios.ClientToScreen(Point(0, btn_relatorios.Height));

  PopupMenuRelatorios.Popup(P.X, P.Y);

end;

procedure Tform_menu.mi_rel_beneficiariosClick(Sender: TObject);
begin
  form_rel_beneficiarios.adoquery_rel_beneficiarios.Close;
  form_rel_beneficiarios.adoquery_rel_beneficiarios.Open;

  form_rel_beneficiarios.RvProject1.ProjectFile :=
    ExtractFilePath(Application.ExeName) +
    'Relatorios\rel_beneficiarios.rav';

  form_rel_beneficiarios.RvProject1.Open;

  form_rel_beneficiarios.RvProject1.ExecuteReport('Report1');
end;

procedure Tform_menu.mi_rel_dependentesClick(Sender: TObject);
begin
  // Abre a consulta dos dependentes
  form_rel_beneficiarios.adoquery_rel_dependentes.Close;
  form_rel_beneficiarios.adoquery_rel_dependentes.Open;


  //parte de teste



  

  // Define o arquivo do relatório
  form_rel_beneficiarios.rel_dependentes.ProjectFile :=
    ExtractFilePath(Application.ExeName) +
    'Relatorios\Rel_Dependentes.rav';

  // Abre e executa o relatório
  form_rel_beneficiarios.rel_dependentes.Open;
  form_rel_beneficiarios.rel_dependentes.ExecuteReport('Report1');

end;

end.
end.
