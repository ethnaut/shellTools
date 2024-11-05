#!/usr/bin/perl
use strict;
use warnings;

# Mostrar mensaje de ayuda si no se pasa ningún argumento ni hay entrada estándar
if (!@ARGV && -t STDIN) {
    print "Uso: $0 [archivo] o mediante una tubería\n";
    print "Ejemplo 1: cat ips.txt | $0\n";
    print "Ejemplo 2: $0 ips.txt\n";
    exit 1;
}

# Función para procesar líneas y extraer IPs
sub extract_ips {
    my $line = shift;
    if ($line =~ /(\d+\.\d+\.\d+\.\d+)/) {
        print "$1\n";
    }
}

# Leer de archivo pasado como argumento o de entrada estándar (tubería)
if (@ARGV) {
    # Procesar archivos pasados como argumento
    foreach my $file (@ARGV) {
        open my $fh, '<', $file or die "No se puede abrir el archivo '$file': $!";
        while (my $line = <$fh>) {
            extract_ips($line);
        }
        close $fh;
    }
} else {
    # Procesar la entrada estándar
    while (my $line = <STDIN>) {
        extract_ips($line);
    }
}

# perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'
