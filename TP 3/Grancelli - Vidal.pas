Program billetera_electronica(output,input);
{Grancelli Eliseo(46935), Vidal Lucas}
Uses Crt;
Type
  usuario = Record
    dni: String [8] ;
    contrasena: Integer;
    ape_nom: String [30];
    mail: String [40];
  End;
  datos_ctas = Record
    cod_ban: Integer;
    tipo_tar: Char {(D: Débito / C:Crédito)};
    saldo_x_tarjeta: Real;
  End;
  cuentasrvirtuales = Record
    dni: String [8] ;
    cuenta_virtual: Array [1..5] Of datos_ctas;
    saldo_billetera: Real ;
  End;
  movimiento = Record
    Dni: String [8];
    cod_ban: Integer;
    tipo_tar: Char {(D: Débito / C:Crédito)};
    Importe: Real;
    tipo_movi: Char;
    dia, mes, ano: Word;
    cod_com: Integer {(código de comercio)};
    dni_otro_usuario: String[8];
  End;
  comercio = Record
    cod_com: Integer {(secuencial consecutivo desde el ultimo ingresado)};
    nombre: String [30];
    cuit: String [12];
    estado: Boolean;
  End;
  banco = Record
    cod_ban: Integer;
    nombre: String [30];
  End;
  bancos = File Of banco;
  comercios = file Of comercio;
  cuentasavirtuales = file Of cuentasrvirtuales;
  usuarios = file Of usuario;
  movimientos = File Of movimiento;
  datos = File Of datos_ctas;
Var
  ba: bancos;
  b, bu: banco;
  op, codigg, i, contrasenia, contrasenna: Integer;
  dnni: String[8];
  com: comercios;
  co: comercio;
  cta: cuentasrvirtuales;
  ctas: cuentasavirtuales;
  us: usuario;
  uss: usuarios;
  mvtos: movimientos;
  mal: Boolean;
  datoss: datos;
  dats: datos_ctas;




{****** Funcion para buscar codigo de banco *******}
Function buscacod (codigg:Integer): Boolean;
Begin
  Assign (ba, 'c:/archivosUTN/banco.dat');
  buscacod := False;
  Reset (ba);
  While Not Eof(ba) And (b.cod_ban<>codigg) Do
    Begin
      read (ba, b);
      If b.cod_ban=codigg Then
        buscacod := True
      Else
        buscacod := False;
    End;
End;
{****** Funcion para buscar codigo de comercio *******}

Function buscacodc (codigg:Integer): Boolean;
Begin
  Reset (com);
  While Not Eof(com) And (co.cod_com<>codigg) Do
    Begin
      read (com, co);
      If co.cod_com=codigg Then
        buscacodc := True
      Else
        buscacodc := False;
    End;
End;
{***** Funcion validar contrasena *****}

Function validacontra (contrasenna:Integer): Boolean;
Begin
  Assign (uss, 'c:/archivosUTN/usuarios.dat');
{Seek (uss, filepos(uss));}
  If (us.contrasena=contrasenna) Then
    validacontra := True
  Else
    validacontra := False;
End;
{****** Funcion para buscar dni ******}

Function buscadni (Var dnni:String): Boolean;
Begin
  Assign (uss, 'c:/archivosUTN/usuarios.dat');
  Reset (uss);
  While Not Eof(uss) And (us.dni<>dnni) Do
    read (uss, us);
  If us.dni=dnni Then
    buscadni := True
  Else
    buscadni := False;
End;
{***** Procedimiento de asignacion y apertura de archivos *****}

Procedure asignabre;
Begin
  Assign (ba, 'c:/archivosUTN/Banco.dat');
  Assign (com, 'c:/archivosUTN/comercios.dat');
  Assign (ctas, 'c:/archivosUTN/cuentasvirtuales.dat');
  Assign (uss, 'c:/archivosUTN/usuarios.dat');
  Assign (mvtos, 'c:/archivosUTN/movimiento.dat');
{$I-}
  Reset (ba);
  If Ioresult = 2 Then
    Rewrite (ba)
  Else Seek (ba, Filesize(ba));
{$I+};
{$I-}
  Reset (com);
  If Ioresult = 2 Then
    Rewrite (com)
  Else Seek (com, Filesize(com));
{$I+};
{$I-}
  Reset (ctas);
  If Ioresult = 2 Then
    Rewrite (ctas)
  Else Seek (ctas, Filesize(ctas));
{$I+};
{$I-}
  Reset (uss);
  If Ioresult = 2 Then
    Rewrite (uss)
  Else Seek (uss, Filesize(uss));
{$I+};
{$I-}
  Reset (mvtos);
  If Ioresult = 2 Then
    Rewrite (mvtos)
  Else Seek (mvtos, Filesize(mvtos));
{$I+};
End;
{****** MODIFICACION DE REGISTROS ******}

Procedure modifica;
Begin
  Assign (com,'c:/archivosUTN/comercios.dat');
  Clrscr;
  Writeln ('modificar datos a registro de comercio');
  Writeln('');
  Write('ingrese codigo del comercio que quiere modificar o "0" para salir:  ');
  Readln (codigg);
  While (codigg<>0) Do
    Begin
      Reset (com);
      While Not (Eof(com)) And (codigg<>co.cod_com) Do
        read (com,co) ;
      If (codigg=co.cod_com) Then
        Begin
				if co.estado=true Then Begin
				seek (com, filepos(com)-1);
          co.cod_com := codigg;
          Write ('codigo del comercio: ', co.cod_com);
          Writeln ('');
          Writeln ('CUIT actual: ', co.cuit);
          Write ('ingrese nuevo CUIT: ');
          Readln(co.cuit);
          Writeln ('');
          Writeln ('Nombre actual: ', co.nombre);
          Write ('ingrese nuevo nombre: ');
          Readln(co.nombre);
          Seek(com,Filepos(com));
          Write(com,co);
          Writeln ('Operacion realizada correctamente');
					Writeln ('');
					Write ('Ingrese el codigo del proximo comercio a modificar o ingrese "0" para salir: ');
					Readln (codigg);
					End
					Else Begin
					Writeln ('No se puede realizar la operacion porque en comercio ingresado esta dado de baja'); Writeln ('Presione cualquier tecla para salir');
					readkey;
          End;
    End;
End;
if (codigg=0) Then Writeln('Operacion cancelada');
end;
{****** ALTA DE REG *******}

Procedure altas;
Begin
  Assign (com,'c:/archivosUTN/comercios.dat');
{$I-}
  Reset(com);
  If Ioresult=2 Then Rewrite(com)
  Else Seek (com, Filesize(com));
{$I+}
  Clrscr;

  Seek (com, Filesize(com));
  Writeln ('Altas de nuevo comercio');
	Repeat
	Writeln ('');
  Writeln('Ingrese nombre de comercio o "*" para cancelar: ');
  Readln (co.nombre);
	if (co.nombre<>'*') then Begin
  Write ('Ingrese el cuit: ');
  Readln (co.cuit);
  (co.cod_com) := (Filesize(com)+1);
  co.estado := True;
  Write (com,co);
	end;
	Until (co.nombre = '*');
  Close (com);
End;
{****** BAJA LOGICA *******}

Procedure BajaL;
Begin
  Assign (com, 'c:/archivosUTN/comercios.dat');
  Reset (com);
  Write ('Ingrese el codigo de comercio a dar de baja: ');
  Readln (codigg);
  While Not Eof(com) And (co.cod_com<>codigg) Do
    read (com, co);
  If co.cod_com=codigg Then
    Begin
      Seek (com, Filepos(com)-1);
      (co.estado) := (False);
      Write (com,co);
    End
  Else
    Begin
      Writeln ('El comercio no existe');
      Writeln ('Presione una tecla para volever al menu');
			readkey;
    End;
End;
{****** ABM *******}

Procedure abm;
Begin
  Assign (com, 'c:/archivosUTN/comercios.dat');
  Writeln ('* LISTADO DE COMERCIOS ADHERIDOS *');
  Writeln ('Codigo - Nombre - CUIT - Estado');
  Writeln ('');
  Reset (com);
  While Not (Eof(com)) Do
    Begin
      read (com, co);
      Writeln (co.cod_com, ' - ', co.nombre, ' - ', co.cuit, ' - ', co.estado);
      Writeln('');
    End;
		Repeat 
  Writeln ('Ingrese la opcion que desee');
  Write ('1- Altas. 2- Bajas. 3- Modificaciones. 4- Salir -- ');
  Repeat
    Readln (op);
  Until (op<=4) And (op>=1);
  Case op Of
    1: Altas;
    2: BajaL;
    3: modifica;
		4: ;
  End;
	Until (op=4);
	close (com);
  End;


Procedure inicio1;
Begin
  Assign (uss, 'c:/archivosUTN/usuarios.dat');
  Writeln ('Ingrese su contrasena');
  Readln (contrasenna);
  validacontra(contrasenna);
  If validacontra(contrasenna)=True Then
    mal := False
  Else
    Begin
      Repeat
        i := i+1;
        Writeln ('Contrasena incorrecta, vuelva a ingresarla');
        Readln (contrasenna);
        validacontra(contrasenna);
      Until (i=2) Or (validacontra(contrasenna)=True);
    End;
  If (i=2) Then
    Begin
      Writeln ('Ha alcanzado el numero maximo de intentos, comuniquese telefonicamente');
      mal := True;
    End
  Else
    mal := False;
End;
Procedure inicio2;
Begin
  us.dni := dnni;
  Writeln ('No existe un usuario registrado con ese numero de DNI');
  Writeln ('Siga los pasos de a continuacion para crear una cuenta');
  Write ('Ingrese su apellido y nombre completo: ');
{Seek (uss, filesize(uss));}
  Readln (us.ape_nom);
  Write ('Mail: ');
  Readln (us.mail);
  Write ('Cree una contrasenia: ');
  Readln (us.contrasena);
  Seek (uss, Filesize(uss));
  Write (uss, us);
End;
{***** Inicio de usuarios *****}

Procedure inicio;
Begin
  Assign (uss, 'c:/archivosUTN/usuarios.dat');
  mal := False;
  Writeln ('BIENVENIDO');
  Writeln ('Inicio de sesion');
  i := 0;
  Write ('Ingrese su DNI: ');
  Readln (dnni);
  Buscadni (dnni);
  If buscadni(dnni)=True Then
    inicio1
  Else
    inicio2;
  If (mal=False) Then
    Writeln ('Bienvenido')
  Else
    Begin
      Writeln ('No se ha podido completar la operacion');
      Readkey;
    End;
End;
{****** Procedimiento listado de bancos *****}

Procedure lista;
Begin
  Assign (ba, 'c:/archivosUTN/Banco.dat');
  Clrscr;
  Writeln ('* LISTADO DE BANCOS ADHERIDOS *');
  Writeln ('Nombre - Codigo');
  Writeln ('');
  Reset (ba);
  While Not (Eof(ba)) Do
    Begin
      read (ba,b);
      Writeln (b.nombre, ' - ', b.cod_ban);
      Writeln('');
    End;
End;
{****** Menu de bancos ******}

Procedure ban;
Begin
  lista;
  Write ('Ingrese una opcion para continuar. 1-Ingresar nuevo banco. 2-Menu: ');
  Writeln ('');
  Reset (ba);
  Seek (ba, Filesize(ba));
  Repeat
    Readln (op);
  Until (op=1) Or (op=2);
  If (op=1) Then
    Begin
      Write ('Nombre del nuevo banco: ');
      Readln (b.nombre);
      While b.nombre<>'*' Do
        Begin
          Write ('Ingrese el codigo: ');
          Readln (b.cod_ban);
          If (buscacod(b.cod_ban)=True) Then
            Begin
              Repeat
                Writeln (

             'El codigo de banco ingresado ya existe, compruebe que este bien y vuelva a ingresarlo'
                );
                Readln (b.cod_ban);
                buscacod(b.cod_ban);
              Until (buscacod(b.cod_ban)=False);
            End;
          Seek (ba, Filesize(ba));
          Write (ba, b);
          Writeln ('');
          Write ('Ingrese el nombre del proximo banco que quiera registrar o " * " si no hay otro');
          Readln (b.nombre);
        End
    End
  Else
    Clrscr;
  Close(ba);
End;
{*** Cuentas_virtuales ***}

Procedure cuen;
var cant: integer;
Begin
Assign (uss, 'c:/archivosUTN/usuarios.dat');
Assign (ctas, 'c:/archivosUTN/cuentasvirtuales.dat');
assign (ba, 'c:/archivosUTN/banco.dat');
read (uss,us);
read (ctas,cta);
reset (ctas);
While not eof(ctas) and (us.dni<>cta.dni) do
read (ctas,cta);
if (us.dni=cta.dni) Then Begin
for i:=1 to 5 Do
Read (ctas,cta);
{writeln (cta.cuenta_virtual[i]);
Writeln (cta.cuenta_virtual[i]);}
End
Else Begin
Writeln ('El usuario ', us.ape_nom, ' no posee cuenta. ¿Desea crear una ahora?');
Write ('Ingrese 1 en caso afirmativo o 0 de lo contrario: ');
Repeat
Readln (op);
until (op=1) or (op=0);
if (op=1) Then Begin
Writeln ('Crear cuenta');
Write ('Presione "1" para agregar una tarjeta o "0" en caso contrario: ');
Repeat
readln (op);
until (op=1) or (op=0);
While (op=1) and (cant<5) do Begin
Write ('Ingrese el codigo de banco: ');
Readln (dats.cod_ban);
While not eof (ba) and (dats.cod_ban<>b.cod_ban) Do begin
read (ba,b);
if (dats.cod_ban=b.cod_ban) Then Begin
Write ('Ingrese el tipo de tarjeta a respaldar. C (credito), D (debito): ');
Repeat
Readln (dats.tipo_tar);
until (dats.tipo_tar='c') or (dats.tipo_tar='C') or (dats.tipo_tar='d') or (dats.tipo_tar='D');
Write ('Ingrese el saldo que posee en dicha tarjeta: ');
Repeat
Readln (dats.saldo_x_tarjeta);
Until (dats.saldo_x_tarjeta>=0);
Write ('Ingrese el saldo que posee en la billetera: ');
Repeat
Readln (cta.saldo_billetera);
until (cta.saldo_billetera>=0);
Seek (ctas, filesize(ctas));
Write (ctas,cta);
end
Else
Begin
Write ('No se encontro el codigo de banco ingresado, intente nuevamente: ');
Readln (dats.cod_ban);
end;
end;
end;
End
Else
Writeln ('Gracias por ingresar');
end;
end;
{****** Usuarios ******}

Procedure usss;
Begin
  Assign (uss, 'c:/archivosUTN/Usuarios.dat');
  Reset (uss);
  Writeln ('INICIO');
  inicio;
  If mal=False Then
    Begin
      Repeat
        Clrscr;
        Writeln ('BIENVENIDO ', us.ape_nom);
        Writeln ('¿Que desea hacer?');
        Writeln ('1- Cuentas / 2- Envios / 3- Compras / 4- Movimientos / 5- Cerrar sesion');
        Write ('Ingrese una opcion: ');
        Repeat
          Readln (op);
        Until (op>=1) And (op<=5);
        Case op Of
          1: {Writeln} cuen;
          2: Write (' envios');
          3: Write('compras');
          4: Write ('movimientos');
        End;
      Until (op=5);
    End;
End;
{********** Menu **********}

Procedure menu;
Begin
  asignabre;
  Repeat
    Clrscr;
    Writeln ('Ingresa una opcion para continuar: 1- Bancos, 2- ABM, 3- Usuarios, 4- Salir');
    Repeat
      Readln (op);
    Until (op>=1) And (op<=4);
    Case op Of
      1: ban;
      2: abm;
      3: usss;
      4 : Write ('Gracias por ingresar');
    End;
  Until (op=4);
End;
Begin
  menu;
End.