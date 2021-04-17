unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, ComCtrls, TAGraph, Math, windows, sqldb, sqlite3conn, DB, Unit2;

type

  { Tmain }

  Tmain = class(TForm)
    btnLoad: TButton;
    btnBiner: TButton;
    btnRecover: TButton;
    btnColor: TButton;
    btnAdmin: TButton;
    withbg: TCheckBox;
    Image2: TImage;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    procedure btnAdminClick(Sender: TObject);
    procedure btnBinerClick(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnRecoverClick(Sender: TObject);
  private

  public

  end;

var
  main: Tmain;
  x,y,c1,c2: Integer;
  cr1,cr2,cr3,cr4,cr5,cr6,cr7,cr8: integer;
  cg1,cg2,cg3,cg4,cg5,cg6,cg7,cg8: integer;
  cb1,cb2,cb3,cb4,cb5,cb6,cb7,cb8: integer;
  bitmapR,bitmapG,bitmapB: array [0..1000,0..1000] of Integer;
  bitmapRpcs,bitmapGpcs,bitmapBpcs: array [0..1000,0..1000] of Integer;
  bitmapGray, bitmapBin, bitmapobj: array [0..1000,0..1000] of Integer;
  histr,histg,histb: array [0..1000] of Integer;
  posxstart, posystart, posxend, posyend: Integer;
implementation

{$R *.lfm}

{ Tmain }

procedure Tmain.btnLoadClick(Sender: TObject);
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
  c1:=Image1.Width * Image1.Height;

end;


procedure Tmain.btnRecoverClick(Sender: TObject);
begin
  for y:=0 to image1.Height-1 do begin
      for x:=0 to Image1.Width-1 do begin
          Image1.Canvas.Pixels[x,y]:= RGB(bitmapR[x,y],bitmapG[x,y],bitmapB[x,y]);
      end;
  end;
end;

procedure Tmain.btnBinerClick(Sender: TObject);
begin
     for y:=0 to Image1.Height-1 do begin
         for x:=0 to image1.Width-1 do begin
             bitmapRpcs[x,y] := GetRValue(image1.Canvas.Pixels[x,y]);
             bitmapGpcs[x,y] := GetGValue(image1.Canvas.Pixels[x,y]);
             bitmapBpcs[x,y] := GetBValue(image1.Canvas.Pixels[x,y]);
             bitmapGray[x,y]:=(bitmapRpcs[x,y]+bitmapGpcs[x,y]+bitmapBpcs[x,y]) div 3;
             if bitmapGray[x,y]> 127 then begin
                if withbg.Checked then begin
                    bitmapBin[x,y]:=0;
                end else begin
                    bitmapBin[x,y]:=255;
                end;
             end else begin
                if withbg.Checked then begin
                    bitmapBin[x,y]:=255;
                end else begin
                    bitmapBin[x,y]:=0;
                end;
             end;
             Image1.Canvas.Pixels[x,y]:= RGB(bitmapBin[x,y],bitmapBin[x,y],bitmapBin[x,y]);
             bitmapobj[x,y]:=bitmapBin[x,y];
         end;
     end;
end;

procedure Tmain.btnAdminClick(Sender: TObject);
begin
  admin.ShowModal;
end;

procedure Tmain.btnColorClick(Sender: TObject);
begin
     for y:=1 to Image1.Height-1 do begin
         for x:=1 to image1.Width-1 do begin
             bitmapRpcs[x,y] := GetRValue(image1.Canvas.Pixels[x,y]);
             bitmapGpcs[x,y] := GetGValue(image1.Canvas.Pixels[x,y]);
             bitmapBpcs[x,y] := GetBValue(image1.Canvas.Pixels[x,y]);
             bitmapGray[x,y]:=(bitmapRpcs[x,y]+bitmapGpcs[x,y]+bitmapBpcs[x,y]) div 3;
             if bitmapGray[x,y]> 127 then begin
                if withbg.Checked then begin
                    bitmapBin[x,y]:=0;
                end else begin
                    bitmapBin[x,y]:=255;
                end;
             end else begin
                if withbg.Checked then begin
                    bitmapBin[x,y]:=255;
                end else begin
                    bitmapBin[x,y]:=0;
                end;
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

end.

