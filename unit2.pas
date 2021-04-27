unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, ExtDlgs, ComCtrls, Math, windows, sqldb, mysql57conn, sqlite3conn,
  DB;

type

  { Tadmin }

  Tadmin = class(TForm)
    btnLoad: TButton;
    btnExtract: TButton;
    btnRecover: TButton;
    btnBack: TButton;
    btnSave: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListView1: TListView;
    MySQL57Connection1: TMySQL57Connection;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    procedure btnLoadClick(Sender: TObject);
    procedure btnExtractClick(Sender: TObject);
    procedure btnRecoverClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  admin: Tadmin;
  x,y,c1,c2: Integer;
  cr1,cr2,cr3,cr4,cr5,cr6,cr7,cr8: integer;
  cg1,cg2,cg3,cg4,cg5,cg6,cg7,cg8: integer;
  cb1,cb2,cb3,cb4,cb5,cb6,cb7,cb8: integer;
  bitmapR,bitmapG,bitmapB: array [0..1000,0..1000] of Integer;
  bitmapRpcs,bitmapGpcs,bitmapBpcs: array [0..1000,0..1000] of Integer;
  bitmapGray, bitmapBin, bitmapobj: array [0..1000,0..1000] of Integer;
  histr,histg,histb: array [0..1000] of Integer;
  manhattan : array [0..1000] of double;
  posxstart, posystart, posxend, posyend: Integer;
  ATransaction : TSQLTransaction;
  Query : TSQLQuery;

implementation

{$R *.lfm}

{ Tadmin }

function configDBMySQL(): String;
begin
     admin.MySQL57Connection1.HostName:='localhost';
     admin.MySQL57Connection1.UserName:='root';
     admin.MySQL57Connection1.DatabaseName:='dbgemstone';
     ATransaction := TSQLTransaction.Create(admin.MySQL57Connection1);
     admin.MySQL57Connection1.Transaction:=ATransaction;
end;

procedure showlistfeature(lv:TListView);
var
  no: Integer;
begin
     configDBMySQL();
     Query:= TSQLQuery.Create(nil);
     Query.DataBase:=admin.MySQL57Connection1;
     Query.SQL.Text:='SELECT d.gem_name,d.gem_class,r.r1,r.r2,r.r3,r.r4,r.r5,r.r6,r.r7,r.r8,g.g1,g.g2,g.g3,g.g4,g.g5,g.g6,g.g7,g.g8,b.b1,b.b2,b.b3,b.b4,b.b5,b.b6,b.b7,b.b8 FROM gemstone_data d INNER JOIN gemstone_r r ON d.id = r.gem_id INNER JOIN gemstone_g g ON d.id = g.gem_id INNER JOIN gemstone_b b ON d.id = b.gem_id ORDER BY d.gem_name';
     Query.Open;
     lv.Items.Clear;
     no:=0;
     while not Query.EOF do begin
       no:=no+1;
       with lv.Items.Add do begin
         Caption:=IntToStr(no);
         SubItems.Add(Query.FieldByName('gem_name').AsString);
         SubItems.Add(Query.FieldByName('gem_class').AsString);
         SubItems.Add(Query.FieldByName('r1').AsString);
         SubItems.Add(Query.FieldByName('r2').AsString);
         SubItems.Add(Query.FieldByName('r3').AsString);
         SubItems.Add(Query.FieldByName('r4').AsString);
         SubItems.Add(Query.FieldByName('r5').AsString);
         SubItems.Add(Query.FieldByName('r6').AsString);
         SubItems.Add(Query.FieldByName('r7').AsString);
         SubItems.Add(Query.FieldByName('r8').AsString);
         SubItems.Add(Query.FieldByName('g1').AsString);
         SubItems.Add(Query.FieldByName('g2').AsString);
         SubItems.Add(Query.FieldByName('g3').AsString);
         SubItems.Add(Query.FieldByName('g4').AsString);
         SubItems.Add(Query.FieldByName('g5').AsString);
         SubItems.Add(Query.FieldByName('g6').AsString);
         SubItems.Add(Query.FieldByName('g7').AsString);
         SubItems.Add(Query.FieldByName('g8').AsString);
         SubItems.Add(Query.FieldByName('b1').AsString);
         SubItems.Add(Query.FieldByName('b2').AsString);
         SubItems.Add(Query.FieldByName('b3').AsString);
         SubItems.Add(Query.FieldByName('b4').AsString);
         SubItems.Add(Query.FieldByName('b5').AsString);
         SubItems.Add(Query.FieldByName('b6').AsString);
         SubItems.Add(Query.FieldByName('b7').AsString);
         SubItems.Add(Query.FieldByName('b8').AsString);
       end;
       Query.Next;
     end;
     Query.Close;
     Query.Free;
     ATransaction.Free;
     admin.MySQL57Connection1.Close;
end;

procedure tampillist();
var
  no,j: Integer;
  status: String;
  jarak : double;
  dbr1,dbr2,dbr3,dbr4,dbr5,dbr6,dbr7,dbr8,dbg1,dbg2,dbg3,dbg4,dbg5,dbg6,dbg7,dbg8,dbb1,dbb2,dbb3,dbb4,dbb5,dbb6,dbb7,dbb8: Float;
  xr1,xr2,xr3,xr4,xr5,xr6,xr7,xr8,xg1,xg2,xg3,xg4,xg5,xg6,xg7,xg8,xb1,xb2,xb3,xb4,xb5,xb6,xb7,xb8: Float;
  kr1,kr2,kr3,kr4,kr5,kr6,kr7,kr8,kg1,kg2,kg3,kg4,kg5,kg6,kg7,kg8,kb1,kb2,kb3,kb4,kb5,kb6,kb7,kb8 : double;
  arrStatus : array[0..1000] of String;
begin
     configDBMySQL();
     Query:=TSQLQuery.Create(nil);
     Query.DataBase:=admin.MySQL57Connection1;
     Query.SQL.Text:='SELECT d.gem_name,d.gem_class,r.r1,r.r2,r.r3,r.r4,r.r5,r.r6,r.r7,r.r8,g.g1,g.g2,g.g3,g.g4,g.g5,g.g6,g.g7,g.g8,b.b1,b.b2,b.b3,b.b4,b.b5,b.b6,b.b7,b.b8 FROM gemstone_data d INNER JOIN gemstone_r r ON d.id = r.gem_id INNER JOIN gemstone_g g ON d.id = g.gem_id INNER JOIN gemstone_b b ON d.id = b.gem_id ORDER BY d.gem_name';
     Query.Open;
     no:=0;
     while not Query.EOF do begin
     status:=Query.FieldByName('gem_name').AsString;
     dbr1:=Query.FieldByName('r1').AsFloat;
     dbr2:=Query.FieldByName('r2').AsFloat;
     dbr3:=Query.FieldByName('r3').AsFloat;
     dbr4:=Query.FieldByName('r4').AsFloat;
     dbr5:=Query.FieldByName('r5').AsFloat;
     dbr6:=Query.FieldByName('r6').AsFloat;
     dbr7:=Query.FieldByName('r7').AsFloat;
     dbr8:=Query.FieldByName('r8').AsFloat;
     dbg1:=Query.FieldByName('g1').AsFloat;
     dbg2:=Query.FieldByName('g2').AsFloat;
     dbg3:=Query.FieldByName('g3').AsFloat;
     dbg4:=Query.FieldByName('g4').AsFloat;
     dbg5:=Query.FieldByName('g5').AsFloat;
     dbg6:=Query.FieldByName('g6').AsFloat;
     dbg7:=Query.FieldByName('g7').AsFloat;
     dbg8:=Query.FieldByName('g8').AsFloat;
     dbb1:=Query.FieldByName('b1').AsFloat;
     dbb2:=Query.FieldByName('b2').AsFloat;
     dbb3:=Query.FieldByName('b3').AsFloat;
     dbb4:=Query.FieldByName('b4').AsFloat;
     dbb5:=Query.FieldByName('b5').AsFloat;
     dbb6:=Query.FieldByName('b6').AsFloat;
     dbb7:=Query.FieldByName('b7').AsFloat;
     dbb8:=Query.FieldByName('b8').AsFloat;

     xr1:=cr1;
     xr2:=cr2;
     xr3:=cr3;
     xr4:=cr4;
     xr5:=cr5;
     xr6:=cr6;
     xr7:=cr7;
     xr8:=cr8;
     xg1:=cg1;
     xg2:=cg2;
     xg3:=cg3;
     xg4:=cg4;
     xg5:=cg5;
     xg6:=cg6;
     xg7:=cg7;
     xg8:=cg8;
     xb1:=cb1;
     xb2:=cb2;
     xb3:=cb3;
     xb4:=cb4;
     xb5:=cb5;
     xb6:=cb6;
     xb7:=cb7;
     xb8:=cb8;
     //knn
     kr1:=RoundTo(Abs(xr1-dbr1),-5);
     kr2:=RoundTo(Abs(xr2-dbr2),-5);
     kr3:=RoundTo(Abs(xr3-dbr3),-5);
     kr4:=RoundTo(Abs(xr4-dbr4),-5);
     kr5:=RoundTo(Abs(xr5-dbr5),-5);
     kr6:=RoundTo(Abs(xr6-dbr6),-5);
     kr7:=RoundTo(Abs(xr7-dbr7),-5);
     kr8:=RoundTo(Abs(xr8-dbr8),-5);
     kg1:=RoundTo(Abs(xg1-dbg1),-5);
     kg2:=RoundTo(Abs(xg2-dbg2),-5);
     kg3:=RoundTo(Abs(xg3-dbg3),-5);
     kg4:=RoundTo(Abs(xg4-dbg4),-5);
     kg5:=RoundTo(Abs(xg5-dbg5),-5);
     kg6:=RoundTo(Abs(xg6-dbg6),-5);
     kg7:=RoundTo(Abs(xg7-dbg7),-5);
     kg8:=RoundTo(Abs(xg8-dbg8),-5);
     kb1:=RoundTo(Abs(xb1-dbb1),-5);
     kb2:=RoundTo(Abs(xb2-dbb2),-5);
     kb3:=RoundTo(Abs(xb3-dbb3),-5);
     kb4:=RoundTo(Abs(xb4-dbb4),-5);
     kb5:=RoundTo(Abs(xb5-dbb5),-5);
     kb6:=RoundTo(Abs(xb6-dbb6),-5);
     kb7:=RoundTo(Abs(xb7-dbb7),-5);
     kb8:=RoundTo(Abs(xb8-dbb8),-5);

     manhattan[no]:= kr1+kr2+kr3+kr4+kr5+kr6+kr7+kr8+kg1+kg2+kg3+kg4+kg5+kg6+kg7+kg8+kb1+kb2+kb3+kb4+kb5+kb6+kb7+kb8;
     arrStatus[no]:=status;
     Query.Next;
     end;
     jarak:=300;
     for j:=1 to no do begin
       if manhattan[j]<jarak then begin
         jarak:=manhattan[j];
         admin.Label3.Caption:=arrStatus[j];
       end;
     end;
     Query.Close;
     Query.Free;
     ATransaction.Free;
     admin.MySQL57Connection1.Close;
end;

function insertNameFeature(name: String; kelas: String): integer;
var
  id : Integer;
begin
     configDBMySQL();
     admin.MySQL57Connection1.Open;
     ATransaction.StartTransaction;
     admin.MySQL57Connection1.ExecuteDirect('INSERT INTO gemstone_data (gem_name, gem_class) VALUES ('+name+','+kelas+')');
     id:= admin.MySQL57Connection1.GetInsertID;
     insertNameFeature:= id;
     ATransaction.Commit;
     ATransaction.Free;
     admin.MySQL57Connection1.Close;

end;

function insertFeatureR(id: Integer; r1,r2,r3,r4,r5,r6,r7,r8: double): integer;
var
  idFeature : Integer;
begin
     configDBMySQL();
     admin.MySQL57Connection1.Open;
     ATransaction.StartTransaction;
     admin.MySQL57Connection1.ExecuteDirect('INSERT INTO gemstone_r (gem_id, r1, r2, r3, r4, r5, r6, r7, r8) VALUES('+IntToStr(id)+','+FloatToStr(r1)+','+FloatToStr(r2)+','+FloatToStr(r3)+','+FloatToStr(r4)+','+FloatToStr(r5)+','+FloatToStr(r6)+','+FloatToStr(r7)+','+FloatToStr(r8)+')');
     idFeature:=admin.MySQL57Connection1.GetInsertID;
     insertFeatureR:=idFeature;
     ATransaction.Commit;
     ATransaction.Free;
     admin.MySQL57Connection1.Close;

end;

function insertfeatureG(id: Integer; g1,g2,g3,g4,g5,g6,g7,g8: double): integer;
var
  idFeature: Integer;
begin
     configDBMySQL();
     admin.MySQL57Connection1.Open;
     ATransaction.StartTransaction;
     admin.MySQL57Connection1.ExecuteDirect('INSERT INTO gemstone_g (gem_id, g1, g2, g3, g4, g5, g6, g7, g8) VALUES('+IntToStr(id)+','+FloatToStr(g1)+','+FloatToStr(g2)+','+FloatToStr(g3)+','+FloatToStr(g4)+','+FloatToStr(g5)+','+FloatToStr(g6)+','+FloatToStr(g7)+','+FloatToStr(g8)+')');
     idFeature:=admin.MySQL57Connection1.GetInsertID;
     insertfeatureG:=idFeature;
     ATransaction.Commit;
     ATransaction.Free;
     admin.MySQL57Connection1.Close;
end;

function insertfeatureB(id: Integer; b1,b2,b3,b4,b5,b6,b7,b8: double): integer;
var
  idFeature: Integer;
begin
     configDBMySQL();
     admin.MySQL57Connection1.Open;
     ATransaction.StartTransaction;
     admin.MySQL57Connection1.ExecuteDirect('INSERT INTO gemstone_b (gem_id, b1, b2, b3, b4, b5, b6, b7, b8) VALUES('+IntToStr(id)+','+FloatToStr(b1)+','+FloatToStr(b2)+','+FloatToStr(b3)+','+FloatToStr(b4)+','+FloatToStr(b5)+','+FloatToStr(b6)+','+FloatToStr(b7)+','+FloatToStr(b8)+')');
     idFeature:=admin.MySQL57Connection1.GetInsertID;
     insertfeatureB:=idFeature;
     ATransaction.Commit;
     ATransaction.Free;
     admin.MySQL57Connection1.Close;
end;

procedure Tadmin.btnLoadClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    for y:=0 to Image1.Height-1 do begin
        for x:=0 to Image1.Width-1 do begin
            bitmapR[x,y]:=GetRValue(Image1.Canvas.Pixels[x,y]);
            bitmapG[x,y]:=GetGValue(Image1.Canvas.Pixels[x,y]);
            bitmapB[x,y]:=GetBValue(Image1.Canvas.Pixels[x,y]);
        end;
    end;
  end;
end;

procedure Tadmin.btnExtractClick(Sender: TObject);
begin
  for y:=1 to Image1.Height-1 do begin
         for x:=1 to image1.Width-1 do begin
             bitmapRpcs[x,y] := GetRValue(image1.Canvas.Pixels[x,y]);
             bitmapGpcs[x,y] := GetGValue(image1.Canvas.Pixels[x,y]);
             bitmapBpcs[x,y] := GetBValue(image1.Canvas.Pixels[x,y]);
             bitmapGray[x,y]:=(bitmapRpcs[x,y]+bitmapGpcs[x,y]+bitmapBpcs[x,y]) div 3;
             if bitmapGray[x,y]> 127 then begin
                    bitmapBin[x,y]:=255;
             end else begin
                    bitmapBin[x,y]:=0;
             end;
             bitmapobj[x,y]:=bitmapBin[x,y];
         end;
     end;
     //
     posXstart:=-1;
     posYstart:=-1;
     posXend:=-1;
     posYend:=-1;
     for y:=1 to Image1.Height-1 do begin
       for x:=1 to Image1.Width-1 do begin
         if bitmapBin[x,y]=0 then begin
            if posYstart<0 then begin
                 posYstart:=y;
            end;
         end;
       end;
     end;
     for y:=Image1.Height-1 downto 1 do begin
       for x:=Image1.Width-1 downto 1 do begin
         if bitmapBin[x,y]=0 then begin
            if posYend<0 then begin
                 posYend:=y;
            end;
         end;
       end;
     end;
     for x:=1 to Image1.Width-1 do begin
         for y:=1 to Image1.Height-1 do begin
           if bitmapBin[x,y]=0 then begin
              if posXstart<0 then begin
                 posXstart:=x;
              end;
           end;
         end;
     end;
     for x:=Image1.Width-1 downto 1 do begin
         for y:=Image1.Height-1 downto 1 do begin
           if bitmapBin[x,y]=0 then begin
              if posXend<0 then begin
                 posXend:=x;
              end;
           end;
         end;
     end;
     //
     for y:=posystart to posyend do begin
       for x:=posxstart to posyend do begin
         Image2.Canvas.Pixels[x,y]:=RGB(bitmapR[x,y], bitmapG[x,y], bitmapB[x,y]);
       end;
     end;
     //
     cr1:=0;
     cr2:=0;
     cr3:=0;
     cr4:=0;
     cr5:=0;
     cr6:=0;
     cr7:=0;
     cr8:=0;
     cg1:=0;
     cg2:=0;
     cg3:=0;
     cg4:=0;
     cg5:=0;
     cg6:=0;
     cg7:=0;
     cg8:=0;
     cb1:=0;
     cb2:=0;
     cb3:=0;
     cb4:=0;
     cb5:=0;
     cb6:=0;
     cb7:=0;
     cb8:=0;
     //
     for y:=posystart to posyend do begin
       for x:=posxstart to posyend do begin
         //r channel
         if (bitmapR[x,y]>=0) and (bitmapR[x,y]<=31) then begin
            cr1:=cr1+1;
         end else if (bitmapR[x,y]>=32) and (bitmapR[x,y]<=63) then begin
           cr2:=cr2+1;
         end else if (bitmapR[x,y]>=64) and (bitmapR[x,y]<=95) then begin
           cr3:=cr3+1;
         end else if (bitmapR[x,y]>=96) and (bitmapR[x,y]<=127) then begin
           cr4:=cr4+1;
         end else if (bitmapR[x,y]>=128) and (bitmapR[x,y]<=159) then begin
           cr5:=cr5+1;
         end else if (bitmapR[x,y]>=160) and (bitmapR[x,y]<=191) then begin
           cr6:=cr6+1;
         end else if (bitmapR[x,y]>=192) and (bitmapR[x,y]<=223) then begin
           cr7:=cr7+1;
         end else if (bitmapR[x,y]>=224) and (bitmapR[x,y]<=255) then begin
           cr8:=cr8+1;
         end;
         //g channel
         if (bitmapG[x,y]>=0) and (bitmapG[x,y]<=31) then begin
            cg1:=cg1+1;
         end else if (bitmapG[x,y]>=32) and (bitmapG[x,y]<=63) then begin
           cg2:=cg2+1;
         end else if (bitmapG[x,y]>=64) and (bitmapG[x,y]<=95) then begin
           cg3:=cg3+1;
         end else if (bitmapG[x,y]>=96) and (bitmapG[x,y]<=127) then begin
           cg4:=cg4+1;
         end else if (bitmapG[x,y]>=128) and (bitmapG[x,y]<=159) then begin
           cg5:=cg5+1;
         end else if (bitmapG[x,y]>=160) and (bitmapG[x,y]<=191) then begin
           cg6:=cg6+1;
         end else if (bitmapG[x,y]>=192) and (bitmapG[x,y]<=223) then begin
           cg7:=cg7+1;
         end else if (bitmapG[x,y]>=224) and (bitmapG[x,y]<=255) then begin
           cg8:=cg8+1;
         end;
         //b channel
         if (bitmapB[x,y]>=0) and (bitmapB[x,y]<=31) then begin
            cb1:=cb1+1;
         end else if (bitmapB[x,y]>=32) and (bitmapB[x,y]<=63) then begin
           cb2:=cb2+1;
         end else if (bitmapB[x,y]>=64) and (bitmapB[x,y]<=95) then begin
           cb3:=cb3+1;
         end else if (bitmapB[x,y]>=96) and (bitmapB[x,y]<=127) then begin
           cb4:=cb4+1;
         end else if (bitmapB[x,y]>=128) and (bitmapB[x,y]<=159) then begin
           cb5:=cb5+1;
         end else if (bitmapB[x,y]>=160) and (bitmapB[x,y]<=191) then begin
           cb6:=cb6+1;
         end else if (bitmapB[x,y]>=192) and (bitmapB[x,y]<=223) then begin
           cb7:=cb7+1;
         end else if (bitmapB[x,y]>=224) and (bitmapB[x,y]<=255) then begin
           cb8:=cb8+1;
         end;
       end;
     end;
end;

procedure Tadmin.btnRecoverClick(Sender: TObject);
begin
  for y:=0 to image1.Height-1 do begin
      for x:=0 to Image1.Width-1 do begin
          Image1.Canvas.Pixels[x,y]:= RGB(bitmapR[x,y],bitmapG[x,y],bitmapB[x,y]);
      end;
  end;
end;

procedure Tadmin.btnBackClick(Sender: TObject);
begin
  close;
end;

procedure Tadmin.btnSaveClick(Sender: TObject);
var
  idfeatureR,idfeatureG,idfeatureB:Integer;
  idname,idkelas: String;
begin
     idname:='0';
     idfeatureR:=0;
     idfeatureG:=0;
     idfeatureB:=0;
     idname:=IntToStr(insertNameFeature(Edit1.Text,ComboBox1.Text));
     idfeatureR:=insertFeatureR(StrToInt(idname),cr1,cr2,cr3,cr4,cr5,cr6,cr7,cr8);
     idfeatureG:=insertfeatureG(StrToInt(idname),cg1,cg2,cg3,cg4,cg5,cg6,cg7,cg8);
     idfeatureB:=insertfeatureB(StrToInt(idname),cb1,cb2,cb3,cb4,cb5,cb6,cb7,cb8);
     showlistfeature(admin.ListView1);
     ShowMessage('Data sukses ditambahkan');
end;

procedure Tadmin.ComboBox1Change(Sender: TObject);
begin

end;

procedure Tadmin.FormCreate(Sender: TObject);
var
  col: TListColumn;
begin
  //combobox
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('Mulia');
  ComboBox1.Items.Add('Semi-Mulia');

  //listview
  col:=ListView1.Columns.Add;
  col.Caption:='No';
  col.Alignment:=taLeftJustify;
  col.Width:=30;

  Col := ListView1.Columns.Add;
  Col.Caption := 'Nama';
  Col.Alignment := taLeftJustify;
  Col.Width := 50;

  Col := ListView1.Columns.Add;
  Col.Caption := 'r1';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'r2';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'r3';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'r4';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'r5';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'r6';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'r7';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'r8';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'g1';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'g2';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'g3';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'g4';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'g5';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'g6';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'g7';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'g8';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'b1';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'b2';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'b3';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'b4';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'b5';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'b6';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'b7';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  Col := ListView1.Columns.Add;
  Col.Caption := 'b8';
  Col.Alignment := taLeftJustify;
  Col.Width := 75;

  showlistfeature(admin.ListView1);
end;

end.

