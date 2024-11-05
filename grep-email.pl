#!/usr/bin/perl
use strict;
use warnings;

# Mostrar mensaje de ayuda si no se pasa ningún argumento ni hay entrada estándar
if (!@ARGV && -t STDIN) {
    print <<'HELP';
Uso: grep-email.pl [archivo | -] o mediante una tubería

Este script extrae direcciones de correo electrónico de un archivo o de la entrada estándar.

Opciones:
  - Si se proporciona un archivo como argumento, el script extraerá direcciones de correo electrónico de ese archivo.
  - Si se usa '-' como argumento, el script leerá de la entrada estándar (stdin). Esto es útil para pegar contenido directamente en la terminal.
  - Si no se proporcionan argumentos y no hay entrada estándar, se mostrará este mensaje de ayuda.

Ejemplos:
  1. Usar con entrada estándar (ej. pegar contenido en la terminal):
     echo 'test@example.com' | perl grep-email.pl -
  2. Usar con un archivo:
     perl grep-email.pl archivo.txt

HELP
    exit 1;
}

# Función para procesar líneas y extraer direcciones de correo electrónico
sub extract_emails {
    my $line = shift;
    while ($line =~ /([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/g) {
        print "$1\n";
    }
}

# Leer de archivo pasado como argumento o de entrada estándar (tubería)
if (@ARGV && $ARGV[0] eq '-') {
    # Procesar la entrada estándar cuando se usa `-` como argumento
    while (my $line = <STDIN>) {
        extract_emails($line);
    }
} elsif (@ARGV) {
    # Procesar archivos pasados como argumento
    foreach my $file (@ARGV) {
        open my $fh, '<', $file or die "No se puede abrir el archivo '$file': $!";
        while (my $line = <$fh>) {
            extract_emails($line);
        }
        close $fh;
    }
} else {
    # Procesar la entrada estándar si no hay argumentos
    while (my $line = <STDIN>) {
        extract_emails($line);
    }
}

