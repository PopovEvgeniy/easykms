unit Easykmscode;

{
 This sofware was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses kmsactivation, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    ActivateButton: TButton;
    ShowStatusButton: TButton;
    ChangeKeyButton: TButton;
    ResetButton: TButton;
    ServerBox: TComboBox;
    ServerPanel: TLabel;
    procedure ActivateButtonClick(Sender: TObject);
    procedure ShowStatusButtonClick(Sender: TObject);
    procedure ChangeKeyButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure ServerBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure window_setup();
    procedure interface_setup();
    procedure language_setup();
    procedure load_server_list(const servers:string);
    procedure setup();
  public
    { public declarations }
  end;

var MainWindow: TMainWindow;

implementation

procedure TMainWindow.window_setup();
begin
 Application.Title:='Easy kms';
 Self.Caption:='Easy kms 2.0.8';
 Self.BorderStyle:=bsDialog;
 Self.Font.Name:=Screen.MenuFont.Name;
 Self.Font.Size:=14;
end;

procedure TMainWindow.interface_setup();
begin
 Self.ServerBox.Text:='';
 Self.ServerBox.Style:=csDropDown;
 Self.ActivateButton.Enabled:=False;
 Self.ActivateButton.ShowHint:=False;
 Self.ShowStatusButton.ShowHint:=False;
 Self.ChangeKeyButton.ShowHint:=False;
 Self.ResetButton.ShowHint:=False;
end;

procedure TMainWindow.language_setup();
begin
 Self.ServerPanel.Caption:='Server';
 Self.ActivateButton.Caption:='Activate';
 Self.ShowStatusButton.Caption:='Show the activation status';
 Self.ChangeKeyButton.Caption:='Change the product key';
 Self.ResetButton.Caption:='Reset the activation';
end;

procedure TMainWindow.load_server_list(const servers:string);
begin
 if FileExists(servers)=True then
 begin
  Self.ServerBox.Items.Clear();
  Self.ServerBox.Items.LoadFromFile(servers);
  Self.ServerBox.ItemIndex:=0;
  Self.ActivateButton.Enabled:=True;
 end

end;

procedure TMainWindow.setup();
begin
 Self.window_setup();
 Self.interface_setup();
 Self.language_setup();
 Self.load_server_list('servers.txt');
end;

{$R *.lfm}

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 Self.setup();
end;

procedure TMainWindow.ActivateButtonClick(Sender: TObject);
begin
 do_activation(Self.ServerBox.Text);
end;

procedure TMainWindow.ShowStatusButtonClick(Sender: TObject);
begin
 show_activation_status();
end;

procedure TMainWindow.ChangeKeyButtonClick(Sender: TObject);
begin
 change_product_key(InputBox(Application.Title,'Enter a new product key',''));
end;

procedure TMainWindow.ResetButtonClick(Sender: TObject);
begin
 reset_activation();
end;

procedure TMainWindow.ServerBoxChange(Sender: TObject);
begin
 Self.ActivateButton.Enabled:=Self.ServerBox.Text<>'';
end;

end.
