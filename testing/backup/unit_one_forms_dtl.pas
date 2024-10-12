unit unit_one_forms_dtl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, RxDBGrid,
  rxtooledit, MyAccess, unitRMKDBEdit, UnitRMKEdit, unitRMKDBDateEdit,
  unitRMKPanelStandard, unitRMKPanelWarna, class_dbconnection, class_init_db,
  unit_libstring, model_one_forms_dtl, class_unit_usaha, LCLType, EditBtn,
  DBCtrls, DBExtCtrls, StrUtils,unit_list_of_values;

type

  { Tform_one_form_dtl }

  Tform_one_form_dtl = class(TForm)
    ConnMyDb: TMyConnection;
    dbe_ofNama: TRMKDBEdit;
    dbe_of_tgl_form: TRMKDBDateEdit;
    dbe_of_uu: TRMKDBEdit;
    Ds_Form_Head: TMyDataSource;
    ds_one_forms_det: TMyDataSource;
    edt_of_no: TRMKEdit;
    ed_edit_name: TRMKEdit;
    lbl_kode_cabang: TLabel;
    lbl_nama_form: TLabel;
    lbl_no_form: TLabel;
    lbl_of_tgl_form: TLabel;
    pnlLOV: TRMKPanelStandard;
    pnlLOV1: TRMKPanelStandard;
    pnlLOV2: TRMKPanelStandard;
    pnl_bawah: TRMKPanelStandard;
    Qry_one_forms: TMyQuery;
    Qry_one_formsof_ins_date: TDateField;
    Qry_one_formsof_ins_user: TStringField;
    Qry_one_formsof_kode: TLongintField;
    Qry_one_formsof_nama: TStringField;
    Qry_one_formsof_pk: TLongintField;
    Qry_one_formsof_tgl_form: TDateField;
    Qry_one_formsof_uu_code: TStringField;
    qry_one_form_dtl: TMyQuery;
    qry_one_form_dtlofd_ins_date: TDateField;
    qry_one_form_dtlofd_ins_user: TStringField;
    qry_one_form_dtlofd_jumlah: TLongintField;
    qry_one_form_dtlofd_ket_forms: TStringField;
    qry_one_form_dtlofd_of_pk: TLongintField;
    qry_one_form_dtlofd_pk: TLongintField;
    rdbg_one_forms_det: TRxDBGrid;
    pnl_Lov: TRMKPanelWarna;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure dbe_of_uuExit(Sender: TObject);
    procedure edt_of_noExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure KeyDownAll(Sender: TObject; var Key: Word; Shift:TShiftState);
    procedure FormShow(Sender: TObject);
    procedure pnlLOV1Click(Sender: TObject);
    procedure pnl_LovClick(Sender: TObject);
    procedure Qry_one_formsNewRecord(DataSet: TDataSet);
    procedure qry_one_form_dtlNewRecord(DataSet: TDataSet);
  private
    FDBConnection: TDBConnection;
    //FDBInit:TInitDB;
    FModelOneFormsDtl:TModelOneFormsDtl;
    FunitUsaha:TUnitUsaha;

  public

  end;

var
  form_one_form_dtl: Tform_one_form_dtl;

implementation

{$R *.lfm}
{ Tform_one_form_dtl }

procedure Tform_one_form_dtl.FormShow(Sender: TObject);
begin
  dbe_of_tgl_form.Date := Now;

  FDBConnection:=TDBConnection.Create;
  if not FDBConnection.connect then
  begin
    ShowMessage(FDBConnection.logger);
    Abort;
  end;

  //form model dtl.
  FModelOneFormsDtl:=TModelOneFormsDtl.Create(FDBConnection);
  FModelOneFormsDtl.InisialisasiUser('1234','2000');
  FModelOneFormsDtl.baru(Qry_one_forms,qry_one_form_dtl);

  //inisilisasi master Store
  FUnitUsaha:=TUnitUsaha.create(FDBConnection);
end;

procedure Tform_one_form_dtl.pnlLOV1Click(Sender: TObject);
begin
    FModelOneFormsDtl.save(Qry_one_forms,qry_one_form_dtl);
end;

procedure Tform_one_form_dtl.pnl_LovClick(Sender: TObject);
var
  lov: Tform_list_of_values;
  simpanpos:TPoint;
  LValues: TStringList;
begin
    lov:=Tform_list_of_values.Create(nil);
    simpanpos:=pnlLOV.ClientToScreen(Point(0, 0));

    lov.Caption :='LOV Master Unit Usaha';
    lov.SqlLov  :='SELECT of_kode, of_nama FROM laz.one_forms;';
    lov.SetJudulLov:='Master Forms ;Nama Forms;150;L;Desc;300;L';
    lov.Left    := simpanpos.X;
    lov.Top     := simpanpos.Y ;//+ ed_store_idPos.height;

    try
      if lov.ShowModal= mrOK then
      begin
        LValues:=lov.LovSelectedValues;
        if LValues.Count > 0 then
        begin
          edt_of_no.Text:=LValues[0];
        end;
      end;
    finally
      lov.DbDisconect;
      lov.Free;
    end;
end;

procedure Tform_one_form_dtl.Qry_one_formsNewRecord(DataSet: TDataSet);
begin
  FModelOneFormsDtl.NewRecordHdr(DataSet);
end;

procedure Tform_one_form_dtl.qry_one_form_dtlNewRecord(DataSet: TDataSet);
begin
  FModelOneFormsDtl.NewRecordDtl(DataSet);
end;


procedure Tform_one_form_dtl.Button1Click(Sender: TObject);
begin
  FModelOneFormsDtl.save(Qry_one_forms,qry_one_form_dtl);
end;

procedure Tform_one_form_dtl.Button2Click(Sender: TObject);
begin
  FModelOneFormsDtl.testcallmodel;
end;

procedure Tform_one_form_dtl.dbe_of_uuExit(Sender: TObject);
var
  StoreQuery: TMyQuery;
begin
  StoreQuery :=FunitUsaha.ValidasiStoreCode('MT_KODE',dbe_of_uu.Text);

  if Assigned(StoreQuery) and (not StoreQuery.IsEmpty) then
  begin
    ed_edit_name.Text:=StoreQuery.FieldByName('MT_NAMA').AsString;
    // Lanjutkan dengan penggunaan dataset di sini jika perlu
  end
  else
  begin
    dbe_of_uu.SetFocus;
    ShowMessage('Tidak berhasil atau tidak ada data.');
  end;
  StoreQuery.Free; // Pastikan untuk membebaskan dataset setelah selesai menggunakannya
  //qry_one_form_dtl.Edit;
end;

procedure Tform_one_form_dtl.edt_of_noExit(Sender: TObject);
begin


  if  edt_of_no.Text <>'' then
  begin
    //pindah ke model
    FModelOneFormsDtl.EdNoExit(Qry_one_forms,qry_one_form_dtl);
  end;


end;

procedure Tform_one_form_dtl.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FreeAndNil(FDBConnection);
  FreeAndNil(FunitUsaha);
end;

procedure Tform_one_form_dtl.KeyDownAll(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  lov: Tform_list_of_values;
  simpanpos:TPoint;
  LValues: TStringList;

begin
  case Key Of
      VK_RETURN:
      begin
        if (Sender=rdbg_one_forms_det) then
            ShowMessage('dbg')
        else
          //SelectNext(ActiveControl,True,True);
          //ShowMessage('masuk sini');
          SelectNext(ActiveControl,True,True);
      end;

      VK_F2:
      begin
        if (sender=edt_of_no) then
        begin
          lov:=Tform_list_of_values.Create(nil);
          simpanpos:=edt_of_no.ClientToScreen(Point(0, 0));

          lov.Caption :='LOV Master Unit Usaha';
          lov.SqlLov  :='SELECT of_kode, of_nama FROM laz.one_forms;';
          lov.SetJudulLov:='Master Forms ;Nama Forms;150;L;Desc;300;L';
          lov.Left    := simpanpos.X;
          lov.Top     := simpanpos.Y ;//+ ed_store_idPos.height;
          try

            if lov.ShowModal= mrOK then
            begin
              LValues:=lov.LovSelectedValues;
              if LValues.Count > 0 then
              begin
                edt_of_no.Text:=LValues[0];
              end;
              key := 0;
            end;
             //debuging jika esc
            //if lov.ModalResult = mrCancel then
            //  begin
            //    key:=0;
            //    ShowMessage('Form ditutup dengan Esc.');
            //  end;
          finally
            lov.DbDisconect;
            lov.Free;
          end;
        end;
      end;

      VK_F3: ShowMessage('F3');
      VK_F9:
      begin
        FModelOneFormsDtl.save(Qry_one_forms,qry_one_form_dtl);
        ShowMessage('Data Berhasil di Simpan....');
      end;
  end;
end;
end.

