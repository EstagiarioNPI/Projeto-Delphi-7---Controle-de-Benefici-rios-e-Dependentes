program Controle_de_beneficiarios_e_dependentes;

uses
  Forms,
  Unit_logon in 'Unit_logon.pas' {form_logon},
  Unit_menu in 'Unit_menu.pas' {form_menu},
  Unit_funcionarios in 'Unit_funcionarios.pas' {form_funcionarios},
  Unit_beneficiarios in 'Unit_beneficiarios.pas' {form_beneficiarios},
  Unit_rel_beneficiarios in 'Unit_rel_beneficiarios.pas' {form_rel_beneficiarios};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tform_logon, form_logon);
  Application.CreateForm(Tform_menu, form_menu);
  Application.CreateForm(Tform_funcionarios, form_funcionarios);
  Application.CreateForm(Tform_beneficiarios, form_beneficiarios);
  Application.CreateForm(Tform_rel_beneficiarios, form_rel_beneficiarios);
  Application.Run;
end.
