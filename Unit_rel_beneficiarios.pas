unit Unit_rel_beneficiarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RpCon, RpConDS, RpDefine, RpRave, DB, ADODB, StdCtrls, Buttons;

type
  Tform_rel_beneficiarios = class(TForm)
    adoquery_rel_beneficiarios: TADOQuery;
    RvProject1: TRvProject;
    RvDataSetConnection1: TRvDataSetConnection;
    btn_visualizar: TBitBtn;
    Label1: TLabel;
    adoquery_rel_dependentes: TADOQuery;
    rel_dependentes: TRvProject;
    ds_rel_dependentes: TRvDataSetConnection;
    ADOQuery1: TADOQuery;
    procedure btn_visualizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_rel_beneficiarios: Tform_rel_beneficiarios;

implementation

uses Unit_logon;

{$R *.dfm}

procedure Tform_rel_beneficiarios.btn_visualizarClick(Sender: TObject);
begin
  adoquery_rel_beneficiarios.Close;
  adoquery_rel_beneficiarios.Open;

  RvProject1.ProjectFile :=
    ExtractFilePath(Application.ExeName) + 'Relatorios\Rel_Beneficiarios.rav';

  RvProject1.Open;
  RvProject1.ExecuteReport('Report1');
end;

end.
