unit unit_list_of_values_new;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids,unit_libstring,class_dbconnection,
  class_init_db,model_list_of_values,LCLType;

type

  { Tform_lov_new }

  Tform_lov_new = class(TForm)
    dbg_lov: TDBGrid;
    procedure dbg_lovColExit(Sender: TObject);
    procedure dbg_lovExit(Sender: TObject);
    procedure dbg_lovKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure dbg_lovKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FSQLQuery: String;
    FDBConnection: TDBConnection;
    FModelListOfValues:TModelListOfValues;
    Fambil:string;
    FJudulLov: String;

  public
    property SqlLov:string read  FSQLQuery write FSQLQuery;
    property SetJudulLov:string  read  FJudulLov write FJudulLov;

  end;

var
  form_lov_new: Tform_lov_new;

implementation

{$R *.lfm}

{ Tform_lov_new }

procedure Tform_lov_new.FormShow(Sender: TObject);
begin
  FDBConnection:=TDBConnection.Create;
  if not FDBConnection.connect then
  begin
    ShowMessage(FDBConnection.logger);
    Abort;
  end;
  FModelListOfValues:=TModelListOfValues.Create(FDBConnection);
  dbg_lov.DataSource:= FModelListOfValues.RunQuery(FSQLQuery);
end;

procedure Tform_lov_new.dbg_lovKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key=  VK_RETURN then
    begin
      Fambil :='T';
      if dbg_lov.DataSource.DataSet.RecordCount> 0 then
      //begin
      //  if Assigned(FOnSelectValues) then
      //  begin
      //    ShowMessage('masuk ke pilihan ');
      //    VSelectedValues := FOnSelectValues(); // Memanggil function OnSelectValues untuk mendapatkan TStringList
      //  end;
      //  close;
      //end;
    end;
end;

procedure Tform_lov_new.dbg_lovKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     ShowMessage('key up');
end;

procedure Tform_lov_new.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
   ShowMessage('ada');
   close;
end;

procedure Tform_lov_new.dbg_lovExit(Sender: TObject);
begin
  close;
end;

procedure Tform_lov_new.dbg_lovColExit(Sender: TObject);
begin
   ShowMessage('on col exit');
end;

end.

