#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

# Mostrar ayuda
sub mostrar_ayuda {
    my $script_name= basename ($0);
    print <<"HELP";
Uso: $script_name <cadena> [fichero] [separador]
awk field analizer analiza un fichero o entrada estándar y busca por una cadena dada, mostrando todos los campos de las líneas que hacen match.

Argumentos:
  <cadena>     La cadena a buscar en el texto.
  [fichero]    (opcional) El fichero a analizar. Si no se proporciona, se espera entrada estándar (tubería).
  [separador]  (opcional) El separador a usar. Por defecto es tabulador.

Opciones:
  Puede recibir datos a través de una tubería, por ejemplo:
    cat datos.txt | $0 'cadena1' '-' '[\\^~|]'

Ejemplos:
  $0 'cadena1' datos.txt                  # Busca 'cadena1' usando el separador por defecto.
  $0 'cadena2' datos.txt '|'               # Busca 'cadena2' usando '|' como separador.
  $0 'cadena1|cadena2' datos.txt           # Busca 'cadena1' o 'cadena2'.
  $0 'cadena3' '-' '[\\^~|]'               # Usa tubería y busca 'cadena3' con múltiples separadores.

HELP
    exit;
}

# Verificar si el script ha sido invocado sin argumentos o con "-h" para mostrar la ayuda
if (@ARGV < 1) {
    mostrar_ayuda();
}

# Extraer los argumentos
my $cadena = $ARGV[0];
my $fichero;
my $separador;

# Si el segundo argumento no está presente, asumimos entrada por tubería y separador por defecto
if (@ARGV == 1) {
    $fichero = '-';  # Leer desde STDIN (tubería)
    $separador = "\t";  # Tabulador por defecto
} elsif (@ARGV == 2) {
    # Si solo se pasan dos argumentos, el segundo es el fichero o '-'
    $fichero = $ARGV[1];
    $separador = "\t";  # Separador por defecto
} else {
    # Si se pasan tres argumentos, el segundo es el fichero y el tercero es el separador
    $fichero = $ARGV[1];
    $separador = $ARGV[2];
}

# Abrir el archivo o leer desde la entrada estándar
my $fh;
if ($fichero eq '-') {
    # Leer desde entrada estándar (pipe)
    open($fh, '<&STDIN') or die "No se pudo leer desde STDIN: $!";
} else {
    # Leer desde un fichero
    open($fh, '<', $fichero) or die "No se pudo abrir el fichero '$fichero': $!";
}

# Procesar cada línea del archivo o de la entrada estándar
while (my $linea = <$fh>) {
    chomp($linea);
    # Si la línea contiene la cadena buscada
    if ($linea =~ /$cadena/) {
        # Dividir la línea en campos usando el separador proporcionado
        my @campos = split(/$separador/, $linea);
        
        # Imprimir cada campo con su número
        for my $i (0..$#campos) {
            print "Campo: \$", ($i + 1), "\tValor: $campos[$i]\n";
        }
        print "\n";  # Línea en blanco entre registros
    }
}

close($fh);

