unit Easykmscode;

{$mode objfpc}
{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LazUTF8;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var Form1: TForm1;

implementation

procedure window_setup();
begin
 Application.Title:='Easy kms';
 Form1.Caption:='Easy kms 1.3';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure interface_setup();
begin
Form1.ComboBox1.Text:='';
Form1.ComboBox1.ReadOnly:=False;
Form1.Button1.ShowHint:=True;
Form1.Button2.ShowHint:=True;
Form1.Button3.ShowHint:=True;
Form1.Button4.ShowHint:=True;
Form1.Button5.ShowHint:=True;
end;

procedure language_setup();
begin
Form1.Label1.Caption:='Server';
Form1.Button1.Caption:='Activate';
Form1.Button2.Caption:='Show activation status';
Form1.Button3.Caption:='Reset activation';
Form1.Button4.Caption:='Change product key';
Form1.Button5.Caption:='Reset server setting';
Form1.Button1.Hint:='Activate you copy of Microsoft Windows via selected server';
Form1.Button2.Hint:='Show current activation status';
Form1.Button3.Hint:='Reset current activation';
Form1.Button4.Hint:='Change current product key';
Form1.Button5.Hint:='Restore default server setting';
end;

procedure load_server_list(servers:string);
begin
Form1.ComboBox1.Items.Clear();
Form1.ComboBox1.Items.LoadFromFile(servers);
Form1.ComboBox1.ItemIndex:=0;
end;

procedure setup();
begin
window_setup();
interface_setup();
language_setup();
load_server_list('servers.txt');
end;

function execute_program(executable:string;argument:string):Integer;
var code:Integer;
begin
try
code:=ExecuteProcess(UTF8ToWinCP(executable),UTF8ToWinCP(argument),[]);
except
On EOSError do code:=-1;
end;
execute_program:=code;
end;

procedure execute_command(command:string);
var shell,arguments:string;
begin
shell:=GetEnvironmentVariable('COMSPEC');
arguments:='/c '+command;
execute_program(shell,arguments);
end;

procedure do_activation(server:string);
begin
execute_command('slmgr /skms '+server);
execute_command('slmgr /ato');
end;

procedure change_product_key();
var key:string;
begin
key:=InputBox(Application.Title,'Enter new product key','');
if key<>'' then execute_command('slmgr /ipk '+key);
end;

procedure do_other_action(action:Byte);
var command:array[0..2] of string=('slmgr /dli','slmgr /rearm','slmgr /ckms');
begin
if action<3 then execute_command(command[action]);
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
setup();
end;

procedure TForm1.FormShow(Sender: TObject);
begin
Form1.Button1.Enabled:=Form1.ComboBox1.Text<>'';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
do_activation(Form1.ComboBox1.Text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
do_other_action(0);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
do_other_action(1);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
change_product_key();
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
do_other_action(2);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
Form1.Button1.Enabled:=Form1.ComboBox1.Text<>'';
end;

end.
