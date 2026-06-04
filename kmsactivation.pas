unit kmsactivation;

{
 This Windows activation unit was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses SysUtils;

procedure change_product_key(const key:string);
procedure do_activation(const server:string);
procedure reset_activation();
procedure show_activation_status();

implementation

procedure execute_command(const command:string);
var arguments:string;
begin
 arguments:='/c '+command;
 try
  ExecuteProcess(GetEnvironmentVariable('COMSPEC'),arguments,[]);
 except
  ;
 end;

end;

procedure change_product_key(const key:string);
begin
 if key<>'' then execute_command('slmgr /ipk '+key);
end;

procedure do_activation(const server:string);
begin
 execute_command('slmgr /skms '+server);
 execute_command('slmgr /ato');
 execute_command('slmgr /xpr');
end;

procedure reset_activation();
begin
 execute_command('slmgr /upk');
 execute_command('slmgr /ckms');
 execute_command('slmgr /rearm');
end;

procedure show_activation_status();
begin
 execute_command('slmgr /dli');
end;

end.
