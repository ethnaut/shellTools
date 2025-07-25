#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Text::CSV;
use List::Util qw(shuffle);
use File::HomeDir;
use POSIX qw(strftime);

# Forzar salida UTF-8 en consola
binmode STDOUT, ':encoding(UTF-8)';

# Rutas
my $csv_file = File::HomeDir->my_home . "/bin/asociaciones_tarot.csv";
my $log_file = File::HomeDir->my_home . "/bin/tarot.log";

# Leer CSV
my @cartas;
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

open my $fh, "<:encoding(utf8)", $csv_file or die "No se pudo abrir '$csv_file': $!";
my $header = $csv->getline($fh);
$csv->column_names(@$header);

while (my $row = $csv->getline_hr($fh)) {
    push @cartas, $row;
}
close $fh;

# Menú principal
sub menu {
    print "\n--- Tarot CLI ---\n";
    print "1. Hacer tirada (con inversión)\n";
    print "2. Consultar carta por número (0–21)\n";
    print "3. Ver todas las cartas en orden\n";
    print "4. Salir\n";
    print "Selecciona opción: ";
    my $opt = <STDIN>;
    chomp $opt;
    if    ($opt eq '1') { tirada(); menu(); }
    elsif ($opt eq '2') { consulta(); menu(); }
    elsif ($opt eq '3') { mostrar_todas(); menu(); }
    elsif ($opt eq '4') { exit 0; }
    else                { print "Opción inválida.\n"; menu(); }
}

# Tirada con inversión
sub tirada {
    print "¿Cuántas cartas deseas sacar? ";
    my $n = <STDIN>;
    chomp $n;

    my @baraja = shuffle(@cartas);
    my @seleccion = @baraja[0 .. $n-1];

    my $timestamp = strftime("%Y-%m-%d %H:%M:%S", localtime);
    open my $log, ">>:encoding(utf8)", $log_file or die "No se puede escribir en el log.";

    print $log "\n[$timestamp] Tirada de $n carta(s):\n";

    for my $carta (@seleccion) {
        my $invertida = (int(rand(2)) == 1);  # 50% posibilidad de inversión
        mostrar_carta($carta, $invertida);
        log_carta($log, $carta, $invertida);
        print "-" x 40 . "\n";
    }

    close $log;
}

# Consulta por número
sub consulta {
    print "Número de la carta (0–21): ";
    my $num = <STDIN>;
    chomp $num;

    if ($num < 0 || $num > 21) {
        print "Número fuera de rango.\n";
        return;
    }

    my ($carta) = grep { $_->{"N°"} == $num } @cartas;
    mostrar_carta($carta, 0);
}

# Mostrar todas las cartas en orden
sub mostrar_todas {
    for my $num (0 .. 21) {
        my ($carta) = grep { $_->{"N°"} == $num } @cartas;
        mostrar_carta($carta, 0);
        print "-" x 40 . "\n";
    }
}

# Mostrar información
sub mostrar_carta {
    my ($carta, $invertida) = @_;
    return unless $carta;

    print "\n== $carta->{\"N°\"} - $carta->{\"Arcano Mayor\"} ";
    print $invertida ? "(Invertida)" : "(Derecha)";
    print " ==\n";
    print "Letra Hebrea     : $carta->{\"Letra Hebrea\"}\n";
    print "Árbol de la Vida : $carta->{\"Camino (Árbol Vida)\"}\n";
    print "Astrología       : $carta->{\"Astrología\"}\n";
    print "Alquimia         : $carta->{\"Alquimia\"}\n";
    print "Dioses/Mitología : $carta->{\"Dioses/Mitología\"}\n";
    print "Waite            : $carta->{\"Waite\"}\n";
    print "Eliphas Levi     : $carta->{\"Eliphas Levi\"}\n";
    print "Papus            : $carta->{\"Papus\"}\n";
    print "Crowley          : $carta->{\"Crowley\"}\n";
}

# Registrar en log
sub log_carta {
    my ($log, $carta, $invertida) = @_;
    return unless $log && $carta;

    print $log " - $carta->{\"N°\"} - $carta->{\"Arcano Mayor\"} ";
    print $log $invertida ? "(Invertida)\n" : "(Derecha)\n";
}

# Ejecutar
menu();

