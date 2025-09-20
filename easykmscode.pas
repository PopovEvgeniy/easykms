unit Easykmscode;

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

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

  public

  end;

var MainWindow: TMainWindow;

implementation

procedure window_setup();
begin
 Application.Title:='Easy kms';
 MainWindow.Caption:='Easy kms 2.0.3';
 MainWindow.BorderStyle:=bsDialog;
 MainWindow.Font.Name:=Screen.MenuFont.Name;
 MainWindow.Font.Size:=14;
end;

procedure interface_setup();
begin
 MainWindow.ServerBox.Text:='';
 MainWindow.ServerBox.Style:=csDropDown;
 MainWindow.ActivateButton.Enabled:=False;
 MainWindow.ActivateButton.ShowHint:=False;
 MainWindow.ShowStatusButton.ShowHint:=MainWindow.ActivateButton.ShowHint;
 MainWindow.ChangeKeyButton.ShowHint:=MainWindow.ActivateButton.ShowHint;
 MainWindow.ResetButton.ShowHint:=MainWindow.ActivateButton.ShowHint;
end;

procedure language_setup();
begin
 MainWindow.ServerPanel.Caption:='Server';
 MainWindow.ActivateButton.Caption:='Activate';
 MainWindow.ShowStatusButton.Caption:='Show the activation status';
 MainWindow.ChangeKeyButton.Caption:='Change the product key';
 MainWindow.ResetButton.Caption:='Reset the activation';
end;

procedure load_server_list(const servers:string);
begin
 if FileExists(servers)=True then
 begin
  MainWindow.ServerBox.Items.Clear();
  MainWindow.ServerBox.Items.LoadFromFile(servers);
  MainWindow.ServerBox.ItemIndex:=0;
 end

end;

procedure setup();
begin
 window_setup();
 interface_setup();
 language_setup();
 load_server_list('servers.txt');
end;

procedure execute_command(const command:string);
var shell,arguments:string;
begin
 shell:=GetEnvironmentVariable('COMSPEC');
 arguments:='/c '+command;
 if shell<>'' then ExecuteProcess(shell,arguments,[]);
end;

procedure do_activation(const server:string);
begin
 execute_command('slmgr /skms '+server);
 execute_command('slmgr /ato');
end;

procedure reset_activation();
begin
 execute_command('slmgr /upk');
 execute_command('slmgr /ckms');
 execute_command('slmgr /rearm');
end;

procedure change_product_key(const title:string);
var key:string;
begin
 key:=InputBox(title,'Enter a new product key','');
 if key<>'' then execute_command('slmgr /ipk '+key);
end;

procedure show_activation_status();
begin
 execute_command('slmgr /dli');
end;

{$R *.lfm}

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TMainWindow.ActivateButtonClick(Sender: TObject);
begin
 do_activation(MainWindow.ServerBox.Text);
end;

procedure TMainWindow.ShowStatusButtonClick(Sender: TObject);
begin
 show_activation_status();
end;

procedure TMainWindow.ChangeKeyButtonClick(Sender: TObject);
begin
 change_product_key(Application.Title);
end;

procedure TMainWindow.ResetButtonClick(Sender: TObject);
begin
 reset_activation();
end;

procedure TMainWindow.ServerBoxChange(Sender: TObject);
begin
 MainWindow.ActivateButton.Enabled:=MainWindow.ServerBox.Text<>'';
end;

end.
