#!/usr/bin/perl
use strict;
# use warnings;

# Muestra el mensaje de ayuda
sub show_help {
    print <<"END_HELP";
Uso: perl $0 <modo> <tipo> [archivo] [opciones]

Modo:
    encode - Codifica el archivo o entrada
    decode - Decodifica el archivo o entrada
    detect - Detecta el tipo de codificación

Tipo:
    base64    - Codificación/Decodificación Base64
    rot13     - Codificación ROT13
    caesar    - Cifrado César (Desplazamiento 3)
    vigenere  - Cifrado de Vigenère (Requiere clave)
    trithemius- Cifrado de Trithemius
    hex       - Codificación/Decodificación Hexadecimal
    rot47     - Codificación ROT47
    binary    - Codificación/Decodificación Binaria
    octal     - Codificación/Decodificación Octal
    url       - Codificación/Decodificación URL/URI

Opciones:
    -k <clave>   - Clave personalizada para Vigenère
    -o <archivo> - Salida a archivo especificado

Ejemplo:
    perl $0 encode base64 archivo.txt
    perl $0 decode vigenere -k clave archivo.txt
    perl $0 detect archivo.txt
END_HELP
    exit;
}

# Verifica los argumentos
@ARGV >= 2 || !-t and show_help();
my ($mode, $type) = @ARGV;

# Procesa opciones adicionales
my $key = '';
my $output_file = '';
while (@ARGV) {
    my $arg = shift @ARGV;
    if ($arg eq '-k') {
        $key = shift @ARGV;
    } elsif ($arg eq '-o') {
        $output_file = shift @ARGV;
    }
}

# Si se especifica archivo de salida
if ($output_file) {
    open my $out_fh, '>', $output_file or die "No se puede abrir $output_file: $!";
    select $out_fh;  # Cambia la salida estándar al archivo
}

# Función para codificación base64
sub base64_encode {
    my @base64chars = ('A'..'Z', 'a'..'z', '0'..'9', '+', '/');
    while (<>) {
        my $binary = unpack('B*', $_);
        $binary .= '0' x ((6 - length($binary) % 6) % 6);
        my @encoded = map { $base64chars[oct("0b$_")] } ($binary =~ /(.{6})/g);
        push @encoded, '=' x ((4 - @encoded % 4) % 4);
        print join('', @encoded), "\n";
    }
}

# Función para decodificación base64
sub base64_decode {
    my @base64chars = ('A'..'Z', 'a'..'z', '0'..'9', '+', '/');
    my %base64rev = map { $base64chars[$_] => $_ } 0..63;
    while (<>) {
        s/=+$//;
        my $binary = join '', map { sprintf("%06b", $base64rev{$_}) } split //;
        print pack('B*', $binary);
    }
}

# Función para ROT13
sub rot13 {
    while (<>) {
        tr/A-Za-z/N-ZA-Mn-za-m/;
        print;
    }
}

# Función para ROT47
sub rot47 {
    while (<>) {
        tr/!-~/P-~!-O/;
        print;
    }
}

# Función para cifrado César
sub caesar_encode {
    my $shift = 3;
    while (<>) {
        for (split //) {
            if (/[A-Za-z]/) {
                my $base = /[A-Z]/ ? 65 : 97;
                $_ = chr((ord($_) - $base + $shift) % 26 + $base);
            }
        }
        print join('', @_), "\n";
    }
}

# Función para codificación/decodificación Vigenère
sub vigenere {
    my ($mode, $key) = @_;
    my $key_index = 0;
    my $key_length = length($key);
    my $shift_func = $mode eq 'encode' ? sub { $_[0] } : sub { -$_[0] };
    while (<>) {
        for (split //) {
            if (/[A-Za-z]/) {
                my $shift = ord(substr($key, $key_index++ % $key_length, 1)) - (/[A-Z]/ ? 65 : 97);
                my $base = /[A-Z]/ ? 65 : 97;
                $_ = chr((ord($_) - $base + $shift_func->($shift)) % 26 + $base);
            }
        }
        print join('', @_), "\n";
    }
}

# Función para cifrado Trithemius
sub trithemius_encode {
    my $shift = 0;
    while (<>) {
        for (split //) {
            if (/[A-Za-z]/) {
                my $base = /[A-Z]/ ? 65 : 97;
                $_ = chr((ord($_) - $base + $shift++) % 26 + $base);
            }
        }
        print join('', @_), "\n";
    }
}

# Función para codificación binaria
sub binary_encode {
    while (<>) {
        print join(' ', map { sprintf("%08b", ord($_)) } split //), "\n";
    }
}

# Función para decodificación binaria
sub binary_decode {
    while (<>) {
        s/([01]{8})/chr(oct("0b$1"))/ge;
        print;
    }
}

# Función para codificación octal
sub octal_encode {
    while (<>) {
        print join(' ', map { sprintf("%03o", ord($_)) } split //), "\n";
    }
}

# Función para decodificación octal
sub octal_decode {
    while (<>) {
        s/([0-7]{3})/chr(oct($1))/ge;
        print;
    }
}

# Función para codificación URL
sub url_encode {
    while (<>) {
        s/([^\w])/'%'.sprintf("%02X", ord($1))/ge;
        print;
    }
}

# Función para decodificación URL
sub url_decode {
    while (<>) {
        s/%([0-9A-Fa-f]{2})/chr(hex($1))/ge;
        print;
    }
}

# Función para codificación hexadecimal
sub hex_encode {
    while (<>) {
        print join('', map { sprintf("%02x", ord($_)) } split //), "\n";
    }
}

# Función para decodificación hexadecimal
sub hex_decode {
    while (<>) {
        s/([0-9a-fA-F]{2})/chr(hex($1))/ge;
        print;
    }
}

# Función para detectar el tipo de codificación
sub detect_encoding {
    while (<>) {
        if (/^[A-Za-z0-9+\/=]{10,}$/) {
            print "Parece ser Base64\n";
        } elsif (/^[0-9a-fA-F]+$/) {
            print "Parece ser Hexadecimal\n";
        } elsif (/^[01]{8,}$/) {
            print "Parece ser Binario\n";
        } elsif (/^[0-7]{3,}$/) {
            print "Parece ser Octal\n";
        } else {
            print "No se pudo determinar el tipo de codificación\n";
        }
    }
}

# Mapeo de tipos y acciones
my %actions = (
    'base64'    => { 'encode' => \&base64_encode, 'decode' => \&base64_decode },
    'rot13'     => { 'encode' => \&rot13,         'decode' => \&rot13         },
    'caesar'    => { 'encode' => \&caesar_encode, 'decode' => \&caesar_encode },
    'vigenere'  => { 'encode' => sub { vigenere('encode', $key) }, 'decode' => sub { vigenere('decode', $key) } },
    'trithemius'=> { 'encode' => \&trithemius_encode, 'decode' => \&trithemius_encode },
    'hex'       => { 'encode' => \&hex_encode,    'decode' => \&hex_decode    },
    'rot47'     => { 'encode' => \&rot47,         'decode' => \&rot47         },
    'binary'    => { 'encode' => \&binary_encode, 'decode' => \&binary_decode },
    'octal'     => { 'encode' => \&octal_encode, 'decode' => \&octal_decode },
    'url'       => { 'encode' => \&url_encode,   'decode' => \&url_decode   },
);

# Verifica si el tipo y modo son válidos
if ($mode eq 'detect') {
    detect_encoding();
} else {
    exists $actions{$type} && exists $actions{$type}{$mode} or show_help();
    $actions{$type}{$mode}->();
}

