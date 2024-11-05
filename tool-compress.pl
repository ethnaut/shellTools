#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long qw(GetOptions);

# Muestra el mensaje de ayuda
sub show_help {
    print <<"END_HELP";
Uso: perl $0 <modo> <tipo> [archivo] [opciones]

Modo:
    compress - Comprime el archivo o entrada
    decompress - Descomprime el archivo o entrada

Tipo:
    rle    - Run-Length Encoding (RLE)
    simple  - Compresión Simple (secuencias de caracteres repetidos)
    custom  - Compresión personalizada simple (cualquier técnica definida)
    tar     - Comprime/descomprime usando tar
    gzip    - Comprime/descomprime usando gzip
    zip     - Comprime/descomprime usando zip

Opciones:
    -o <archivo> - Salida a archivo especificado
    -k <clave>   - Clave para cifrado/descifrado (si aplica)

Ejemplo:
    perl $0 compress rle archivo.txt
    perl $0 decompress gzip archivo.gz -o salida.txt
END_HELP
    exit;
}

# Verifica los argumentos
@ARGV >= 2 || !-t and show_help();
my ($mode, $type) = @ARGV;

# Procesa opciones adicionales
my $output_file = '';
GetOptions('o=s' => \$output_file);

# Si se especifica archivo de salida
if ($output_file) {
    open my $out_fh, '>', $output_file or die "No se puede abrir $output_file: $!";
    select $out_fh;  # Cambia la salida estándar al archivo
}

# Funciones para compresión y descompresión usando herramientas externas

# Función para compresión usando tar
sub tar_compress {
    my $file = shift;
    system("tar -cvf $file.tar $file");
}

# Función para descompresión usando tar
sub tar_decompress {
    my $file = shift;
    system("tar -xvf $file");
}

# Función para compresión usando gzip
sub gzip_compress {
    my $file = shift;
    system("gzip $file");
}

# Función para descompresión usando gzip
sub gzip_decompress {
    my $file = shift;
    system("gunzip $file");
}

# Función para compresión usando zip
sub zip_compress {
    my $file = shift;
    system("zip $file.zip $file");
}

# Función para descompresión usando zip
sub zip_decompress {
    my $file = shift;
    system("unzip $file");
}

# Función para compresión RLE
sub rle_compress {
    while (<>) {
        my $prev = '';
        my $count = 0;
        for (split //) {
            if ($_ eq $prev) {
                $count++;
            } else {
                print "$count$prev" if $count > 0;
                $prev = $_;
                $count = 1;
            }
        }
        print "$count$prev\n";
    }
}

# Función para descompresión RLE
sub rle_decompress {
    while (<>) {
        s/(\d+)(.)/$2 x $1/ge;
        print;
    }
}

# Función para compresión simple
sub simple_compress {
    while (<>) {
        s/(.)\1+/$1 . (length($&) - 1)/ge;
        print;
    }
}

# Función para descompresión simple
sub simple_decompress {
    while (<>) {
        s/(\S)\d+/$1 x ($2 + 1)/ge;
        print;
    }
}

# Función para compresión personalizada simple
sub custom_compress {
    while (<>) {
        # Ejemplo simple de compresión personalizada (reemplazo de espacios consecutivos)
        s/ {2,}/ /g;
        print;
    }
}

# Función para descompresión personalizada simple
sub custom_decompress {
    while (<>) {
        # Ejemplo simple de descompresión personalizada
        s/ {1,}/ /g;
        print;
    }
}

# Mapeo de tipos y acciones
my %actions = (
    'rle'    => { 'compress' => \&rle_compress, 'decompress' => \&rle_decompress },
    'simple' => { 'compress' => \&simple_compress, 'decompress' => \&simple_decompress },
    'custom' => { 'compress' => \&custom_compress, 'decompress' => \&custom_decompress },
    'tar'    => { 'compress' => \&tar_compress, 'decompress' => \&tar_decompress },
    'gzip'   => { 'compress' => \&gzip_compress, 'decompress' => \&gzip_decompress },
    'zip'    => { 'compress' => \&zip_compress, 'decompress' => \&zip_decompress },
);

# Verifica si el tipo y modo son válidos
if ($type =~ /^(tar|gzip|zip)$/) {
    if ($mode eq 'compress') {
        $actions{$type}{$mode}->($ARGV[0]);
    } elsif ($mode eq 'decompress') {
        $actions{$type}{$mode}->($ARGV[0]);
    } else {
        show_help();
    }
} else {
    exists $actions{$type} && exists $actions{$type}{$mode} or show_help();
    $actions{$type}{$mode}->();
}

