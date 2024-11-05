#!/usr/bin/perl
use strict;
# use warnings;

# Muestra el mensaje de ayuda
sub show_help {
    print <<"END_HELP";
Uso: perl $0 <modo> <tipo> [origen] [destino] [opciones]

Modo:
    send      - Envía un archivo
    receive   - Recibe un archivo

Tipo:
    rsync    - Transmisión usando rsync
    scp      - Transmisión usando scp
    ftp      - Transmisión usando ftp
    sftp     - Transmisión usando sftp
    wget     - Descarga usando wget
    curl     - Descarga usando curl

Opciones:
    -u <usuario>   - Usuario para autenticación (si aplica)
    -p <password>  - Contraseña para autenticación (si aplica)
    -h <host>      - Host destino (para scp, sftp, ftp)
    -d <directorio> - Directorio destino (para ftp y sftp)
    -o <archivo>   - Salida a archivo especificado

Ejemplo:
    perl $0 send rsync archivo.txt -h ejemplo.com -u usuario
    perl $0 receive scp archivo.txt -h ejemplo.com -u usuario -o salida.txt
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
    my $dest = "$host:$src";
    system("rsync -avz $src $dest");
}

# Función para recibir usando rsync
sub rsync_receive {
    my ($src) = @_;
    system("rsync -avz $host:$src .");
}

# Función para enviar usando scp
sub scp_send {
    my ($src) = @_;
    my $dest = "$user\@$host:$src";
    system("scp $src $dest");
}

# Función para recibir usando scp
sub scp_receive {
    my ($src) = @_;
    system("scp $user\@$host:$src .");
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
put $src
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
get $src
bye
END_SFTP
    open my $sftp_fh, '|-', 'sftp' or die "No se puede ejecutar sftp: $!";
    print $sftp_fh $sftp_command;
    close $sftp_fh;
}

# Función para descargar usando wget
sub wget_download {
    my ($url) = @_;
    system("wget $url");
}

# Función para descargar usando curl
sub curl_download {
    my ($url) = @_;
    system("curl -O $url");
}

# Mapeo de tipos y acciones
my %actions = (
    'rsync' => { 'send' => \&rsync_send, 'receive' => \&rsync_receive },
    'scp'   => { 'send' => \&scp_send, 'receive' => \&scp_receive },
    'ftp'   => { 'send' => \&ftp_send, 'receive' => \&ftp_receive },
    'sftp'  => { 'send' => \&sftp_send, 'receive' => \&sftp_receive },
    'wget'  => { 'send' => \&wget_download },
    'curl'  => { 'send' => \&curl_download },
);

# Verifica si el tipo y modo son válidos
exists $actions{$type} && exists $actions{$type}{$mode} or show_help();
$actions{$type}{$mode}->($ARGV[0]);

