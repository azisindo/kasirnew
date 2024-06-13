program OneFormsDtl;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent, rxnew, unit_one_forms_dtl, class_dbconnection, mydac10,
  model_one_forms_dtl, class_init_db, unit_libstring, class_unit_usaha,
unit_list_of_values, model_list_of_values, unit_list_of_values_new ;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tform_one_form_dtl, form_one_form_dtl);
  Application.CreateForm(Tform_list_of_values, form_list_of_values);
  Application.CreateForm(Tform_lov_new, form_lov_new);
  Application.Run;
end.

