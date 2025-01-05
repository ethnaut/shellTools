#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

# Mostrar ayuda si no hay parámetros
if (@ARGV != 2) {
    print <<'HELP';
mmv.pl - Renombrado masivo de archivos al estilo del comando mmv.

Uso:
  mmv.pl '<patrón_origen>' '<patrón_destino>'

Ejemplos:
  Renombrar file{a..z}.txt a data{a..z}.txt:
    ./mmv.pl 'file*.txt' 'data#1.txt'

Ejemplos adicionales:

1. Mover una selección de archivos a otro directorio:
   Mueve todos los archivos .txt al subdirectorio 'backup':
   ./mmv.pl '*.txt' 'backup/#1.txt'

2. Cambiar el formato de fechas en los nombres de archivo:
   Transforma archivos con fechas en formato mmddaaaa a aaaammdd.
   Ejemplo: file_12042023.log -> file_20231204.log
   ./mmv.pl '*_([0-9]{2})([0-9]{2})([0-9]{4}).log' '#1_#3#1#2.log'

3. Añadir un prefijo a varios archivos:
   Agrega el prefijo 'archived_' a todos los archivos .csv:
   ./mmv.pl '*.csv' 'archived_#1.csv'

4. Cambiar extensiones de archivo:
   Convierte todos los archivos .jpeg a .jpg:
   ./mmv.pl '*.jpeg' '#1.jpg'

5. Reemplazar un segmento en los nombres de archivo:
   Cambia 'January' por 'Jan' en los archivos como report_January.docx:
   ./mmv.pl '*_January.docx' '#1_Jan.docx'

6. Enumerar archivos:
   Agrega un número consecutivo al final de los nombres de archivos .png:
   Ejemplo: image.png -> image_1.png, image_2.png, etc.
   ./mmv.pl '*.png' '#1_#2.png'

Notas:
- Recuerda crear los directorios de destino, como 'backup', antes de mover archivos.
- Usa comillas simples para proteger los patrones de la shell.
- Los patrones utilizan expresiones regulares de Perl.

HELP
    exit;
}

my ($src_pattern, $dst_pattern) = @ARGV;

# Convertir el patrón origen en una expresión regular
if ($src_pattern !~ /\*/) {
    die "El patrón de origen debe contener al menos un asterisco (*).\n";
}
my $regex_pattern = $src_pattern;
$regex_pattern =~ s/\*/(.*)/g;    # Reemplazar * por captura

# Buscar archivos que coincidan con el patrón origen
my @files = glob($src_pattern);
if (!@files) {
    die "No se encontraron archivos que coincidan con el patrón: $src_pattern\n";
}

# Renombrar archivos
foreach my $file (@files) {
    my $basename = basename($file);
    if ($basename =~ /^$regex_pattern$/) {
        # Capturar las variables
        my @captures = ($1, $2, $3, $4, $5, $6, $7, $8, $9); # Hasta 9 capturas
        my $new_name = $dst_pattern;

        # Reemplazar #1, #2, etc., con las capturas correspondientes
        $new_name =~ s/#(\d+)/defined $captures[$1 - 1] ? $captures[$1 - 1] : ''/eg;

        print "Renombrando: $file -> $new_name\n";
        rename($file, $new_name) or warn "Error renombrando $file a $new_name: $!\n";
    }
}
