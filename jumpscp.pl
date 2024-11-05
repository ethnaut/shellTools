#!/usr/bin/perl

use strict;
use warnings;

# Lista de servidores de salto (puedes ajustar esto según tus necesidades)
my @jump_servers = (
    'jump1.example.com',
    'jump2.example.com',
    'jump3.example.com',
    'jump4.example.com',
    'jump5.example.com',
);

# Mostrar instrucciones de uso si el script se ejecuta sin parámetros
if (@ARGV < 6) {
    print_usage();
    exit;
}

# Leer parámetros de línea de comandos
my ($proxy_user, $target_user, $target_host, $jump_server_index, $remote_file_path, $local_file_path) = @ARGV;

# Verificar que todos los parámetros estén presentes y válidos
unless ($proxy_user && $target_user && $target_host && defined $jump_server_index && $remote_file_path && $local_file_path) {
    print "Error: Faltan parámetros. Debes proporcionar el usuario proxy, el usuario del objetivo, el host objetivo, el índice del servidor de salto, la ruta del archivo remoto y la ruta local.\n";
    print_usage();
    exit 1;
}

# Verificar que el índice del servidor de salto esté en el rango permitido
if ($jump_server_index < 1 || $jump_server_index > @jump_servers) {
    die "Error: Índice del servidor de salto inválido. Debe estar entre 1 y " . scalar(@jump_servers) . ".\n";
}

# Seleccionar el servidor de salto basado en el índice
my $proxy_host = $jump_servers[$jump_server_index - 1];

# Comando para copiar el archivo desde el servidor objetivo a través del proxy
my $scp_command = "scp -o ProxyCommand='ssh -W %h:%p $proxy_user\@$proxy_host' $target_user\@$target_host:$remote_file_path $local_file_path";

# Función para imprimir instrucciones de uso
sub print_usage {
    print <<"USAGE";
Uso: $0 <proxy_user> <target_user> <target_host> <jump_server_index> <remote_file_path> <local_file_path>

Descripción:
Este script copia un archivo desde un servidor objetivo a tu máquina local a través de un servidor de salto seleccionado de una lista.

Parámetros:
  <proxy_user>      Usuario para el servidor de salto.
  <target_user>     Usuario para el servidor objetivo.
  <target_host>     Dirección del servidor objetivo.
  <jump_server_index>  Índice del servidor de salto en la lista (1 a 5).
  <remote_file_path>  Ruta del archivo en el servidor objetivo que deseas copiar.
  <local_file_path>   Ruta local donde deseas guardar el archivo.

Lista de servidores de salto disponibles:
USAGE

    for my $i (0 .. $#jump_servers) {
        print "  ", $i + 1, ": $jump_servers[$i]\n";
    }

    print <<'USAGE';

Ejemplo:
  $0 usuario_proxy usuario_objetivo servidor_objetivo.com 1 /ruta/remota/al/archivo /ruta/local/donde/guardar

USAGE
}

# Ejecutar el comando para copiar el archivo
print "Copiando $remote_file_path desde $target_host a $local_file_path a través de $proxy_host...\n";
my $exit_code = system($scp_command);

if ($exit_code == 0) {
    print "Archivo copiado exitosamente.\n";
} else {
    die "Error al copiar el archivo. Código de salida: $exit_code\n";
}

