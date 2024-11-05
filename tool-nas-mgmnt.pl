#!/usr/bin/perl
use strict;
use warnings;

# Muestra el mensaje de ayuda
sub show_help {
    print <<"END_HELP";
Uso: perl $0 <modo> <tipo> [origen] [destino] [opciones]

Modo:
    send      - Envía un archivo al NAS
    receive   - Recibe un archivo del NAS
    list      - Lista archivos en el NAS
    mkdir     - Crea un directorio en el NAS
    rm        - Elimina un archivo en el NAS

Tipo:
    rsync    - Transmisión usando rsync
    scp      - Transmisión usando scp
    ftp      - Transmisión usando ftp
    sftp     - Transmisión usando sftp

Opciones:
    -u <usuario>   - Usuario para autenticación (si aplica)
    -p <password>  - Contraseña para autenticación (si aplica)
    -h <host>      - Host del NAS (para scp, sftp, ftp)
    -d <directorio> - Directorio destino (para ftp y sftp)
    -o <archivo>   - Salida a archivo especificado

Ejemplo:
    perl $0 send rsync archivo.txt -h nas.example.com -u usuario
    perl $0 receive scp archivo.txt -h nas.example.com -u usuario -o salida.txt
    perl $0 list ftp -h ftp.nas.example.com -u usuario -d /directorio
    perl $0 mkdir sftp -h sftp.nas.example.com -u usuario -d /nuevo_directorio
    perl $0 rm scp archivo.txt -h nas.example.com -u usuario
END_HELP
    exit;
}

# Verifica los argumentos
@ARGV >= 2 || !-t and show_help();
my ($mode, $type) = @ARGV;

# Procesa opciones adicionales
my ($host, $user, $password, $directory, $output_file);
while (@ARGV) {
    my $arg = shift @ARGV;
    if ($arg eq '-h') { $host = shift @ARGV; }
    elsif ($arg eq '-u') { $user = shift @ARGV; }
    elsif ($arg eq '-p') { $password = shift @ARGV; }
    elsif ($arg eq '-d') { $directory = shift @ARGV; }
    elsif ($arg eq '-o') { $output_file = shift @ARGV; }
}

# Si se especifica archivo de salida
if ($output_file) {
    open my $out_fh, '>', $output_file or die "No se puede abrir $output_file: $!";
    select $out_fh;  # Cambia la salida estándar al archivo
}

# Función para enviar usando rsync
sub rsync_send {
    my ($src) = @_;
    my $dest = "$host:$directory/$src";
    system("rsync -avz $src $dest");
}

# Función para recibir usando rsync
sub rsync_receive {
    my ($src) = @_;
    my $dest = "$directory/$src";
    system("rsync -avz $host:$src $dest");
}

# Función para enviar usando scp
sub scp_send {
    my ($src) = @_;
    my $dest = "$user\@$host:$directory/$src";
    system("scp $src $dest");
}

# Función para recibir usando scp
sub scp_receive {
    my ($src) = @_;
    my $dest = "$directory/$src";
    system("scp $user\@$host:$src $dest");
}

# Función para enviar usando ftp
sub ftp_send {
    my ($src) = @_;
    my $ftp_command = <<"END_FTP";
open $host
user $user $password
binary
cd $directory
put $src
bye
END_FTP
    open my $ftp_fh, '|-', 'ftp' or die "No se puede ejecutar ftp: $!";
    print $ftp_fh $ftp_command;
    close $ftp_fh;
}

# Función para recibir usando ftp
sub ftp_receive {
    my ($src) = @_;
    my $ftp_command = <<"END_FTP";
open $host
user $user $password
binary
cd $directory
get $src
bye
END_FTP
    open my $ftp_fh, '|-', 'ftp' or die "No se puede ejecutar ftp: $!";
    print $ftp_fh $ftp_command;
    close $ftp_fh;
}

# Función para enviar usando sftp
sub sftp_send {
    my ($src) = @_;
    my $sftp_command = <<"END_SFTP";
open $user\@$host
put $src $directory/
bye
END_SFTP
    open my $sftp_fh, '|-', 'sftp' or die "No se puede ejecutar sftp: $!";
    print $sftp_fh $sftp_command;
    close $sftp_fh;
}

# Función para recibir usando sftp
sub sftp_receive {
    my ($src) = @_;
    my $sftp_command = <<"END_SFTP";
open $user\@$host
get $src $directory/
bye
END_SFTP
    open my $sftp_fh, '|-', 'sftp' or die "No se puede ejecutar sftp: $!";
    print $sftp_fh $sftp_command;
    close $sftp_fh;
}

# Función para listar archivos usando ftp
sub ftp_list {
    my $ftp_command = <<"END_FTP";
open $host
user $user $password
binary
cd $directory
ls
bye
END_FTP
    open my $ftp_fh, '|-', 'ftp' or die "No se puede ejecutar ftp: $!";
    print $ftp_fh $ftp_command;
    close $ftp_fh;
}

# Función para listar archivos usando sftp
sub sftp_list {
    my $sftp_command = <<"END_SFTP";
open $user\@$host
ls $directory
bye
END_SFTP
    open my $sftp_fh, '|-', 'sftp' or die "No se puede ejecutar sftp: $!";
    print $sftp_fh $sftp_command;
    close $sftp_fh;
}

# Función para crear un directorio usando ftp
sub ftp_mkdir {
    my $ftp_command = <<"END_FTP";
open $host
user $user $password
binary
cd $directory
mkdir $ARGV[0]
bye
END_FTP
    open my $ftp_fh, '|-', 'ftp' or die "No se puede ejecutar ftp: $!";
    print $ftp_fh $ftp_command;
    close $ftp_fh;
}

# Función para crear un directorio usando sftp
sub sftp_mkdir {
    my $sftp_command = <<"END_SFTP";
open $user\@$host
mkdir $directory/$ARGV[0]
bye
END_SFTP
    open my $sftp_fh, '|-', 'sftp' or die "No se puede ejecutar sftp: $!";
    print $sftp_fh $sftp_command;
    close $sftp_fh;
}

# Función para eliminar un archivo usando ftp
sub ftp_rm {
    my $ftp_command = <<"END_FTP";
open $host
user $user $password
binary
cd $directory
delete $ARGV[0]
bye
END_FTP
    open my $ftp_fh, '|-', 'ftp' or die "No se puede ejecutar ftp: $!";
    print $ftp_fh $ftp_command;
    close $ftp_fh;
}

# Función para eliminar un archivo usando sftp
sub sftp_rm {
    my $sftp_command = <<"END_SFTP";
open $user\@$host
rm $directory/$ARGV[0]
bye
END_SFTP
    open my $sftp_fh, '|-', 'sftp' or die "No se puede ejecutar sftp: $!";
    print $sftp_fh $sftp_command;
    close $sftp_fh;
}

# Mapeo de tipos y acciones
my %actions = (
    'rsync' => { 'send' => \&rsync_send, 'receive' => \&rsync_receive },
    'scp'   => { 'send' => \&scp_send, 'receive' => \&scp_receive },
    'ftp'   => { 'send' => \&ftp_send, 'receive' => \&ftp_receive, 'list' => \&ftp_list, 'mkdir' => \&ftp_mkdir, 'rm' => \&ftp_rm },
    'sftp'  => { 'send' => \&sftp_send, 'receive' => \&sftp_receive, 'list' => \&sftp_list, 'mkdir' => \&sftp_mkdir, 'rm' => \&sftp_rm },
);

# Verifica si el tipo y modo son válidos
exists $actions{$type} && exists $actions{$type}{$mode} or show_help();
$actions{$type}{$mode}->($ARGV[0]);

