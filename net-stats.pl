#!/usr/bin/perl
use strict;
use warnings;

# Verificamos si se ha pasado un parámetro
if (@ARGV == 0) {
    print "Uso: $0 <interfaz>\n";
    print "Ejemplo: $0 eth0\n";
    exit 1;
}

# Obtenemos la interfaz de red desde el argumento
my $interface = $ARGV[0];

# Ruta a los archivos de estadísticas
my $stats_path = "/sys/class/net/$interface/statistics";

# Verificamos si la ruta existe
unless (-d $stats_path) {
    die "La interfaz $interface no existe o no tiene estadísticas disponibles.\n";
}

# Abrimos el directorio y leemos los archivos de estadísticas
opendir(my $dh, $stats_path) or die "No se puede abrir el directorio $stats_path: $!\n";
while (my $file = readdir($dh)) {
    next if $file =~ /^\.\.?$/;  # Saltar . y ..
    my $filepath = "$stats_path/$file";
    
    if (open(my $fh, '<', $filepath)) {
        chomp(my $value = <$fh>);
        print "$file: $value\n";
        close($fh);
    } else {
        warn "No se pudo leer el archivo $filepath: $!\n";
    }
}
closedir($dh);

