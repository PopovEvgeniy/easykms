unit Easykmscode;

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var Form1: TForm1;

implementation

procedure window_setup();
begin
 Application.Title:='Easy kms';
 Form1.Caption:='Easy kms 1.9.9';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure interface_setup();
begin
 Form1.ComboBox1.Text:='';
 Form1.ComboBox1.Style:=csDropDownList;
 Form1.CheckBox1.Checked:=False;
 Form1.CheckBox1.Enabled:=True;
 Form1.Button1.ShowHint:=False;
 Form1.Button2.ShowHint:=Form1.Button1.ShowHint;
 Form1.Button3.ShowHint:=Form1.Button1.ShowHint;
 Form1.Button4.ShowHint:=Form1.Button1.ShowHint;
end;

procedure language_setup();
begin
 Form1.Label1.Caption:='Server';
 Form1.Button1.Caption:='Activate';
 Form1.Button2.Caption:='Show the activation status';
 Form1.Button3.Caption:='Change the product key';
 Form1.Button4.Caption:='Reset the activation';
 Form1.CheckBox1.Caption:='Allow use of a user-defined KMS server';
end;

procedure load_server_list(const servers:string);
begin
 if FileExists(servers)=True then
 begin
  Form1.ComboBox1.Items.Clear();
  Form1.ComboBox1.Items.LoadFromFile(servers);
  Form1.ComboBox1.ItemIndex:=0;
 end
 else
 begin
  Form1.ComboBox1.Style:=csDropDown;
  Form1.CheckBox1.Checked:=True;
  Form1.CheckBox1.Enabled:=False;
  Form1.Button1.Enabled:=False;
 end;

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

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 do_activation(Form1.ComboBox1.Text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 show_activation_status();
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 change_product_key(Application.Title);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 reset_activation();
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
 Form1.ComboBox1.Style:=csDropDownList;
 if Form1.CheckBox1.Checked=True then Form1.ComboBox1.Style:=csDropDown;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
 Form1.Button1.Enabled:=Form1.ComboBox1.Text<>'';
end;

end.
