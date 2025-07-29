#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use List::Util qw(shuffle);
binmode STDOUT, ':utf8';

my @runas = (
  { rune => "ᚠ", nombre => "Fehu",     desc => "Riqueza, prosperidad", invertido => "Pérdida, codicia" },
  { rune => "ᚢ", nombre => "Uruz",     desc => "Fuerza, salud", invertido => "Debilidad, caos" },
  { rune => "ᚦ", nombre => "Thurisaz", desc => "Defensa, impulso", invertido => "Descontrol, traición" },
  { rune => "ᚨ", nombre => "Ansuz",    desc => "Comunicación, sabiduría", invertido => "Malentendido, manipulación" },
  { rune => "ᚱ", nombre => "Raidho",   desc => "Viaje, cambio", invertido => "Estancamiento, obstáculos" },
  { rune => "ᚲ", nombre => "Kenaz",    desc => "Luz, creatividad", invertido => "Oscuridad, pérdida" },
  { rune => "ᚷ", nombre => "Gebo",     desc => "Regalo, intercambio", invertido => undef },
  { rune => "ᚹ", nombre => "Wunjo",    desc => "Alegría, armonía", invertido => "Tristeza, ruptura" },
  { rune => "ᚺ", nombre => "Hagalaz",  desc => "Transformación repentina", invertido => undef },
  { rune => "ᚾ", nombre => "Nauthiz",  desc => "Necesidad, prueba", invertido => "Liberación, alivio" },
  { rune => "ᛁ", nombre => "Isa",      desc => "Estancamiento, calma", invertido => undef },
  { rune => "ᛃ", nombre => "Jera",     desc => "Cosecha, ciclo", invertido => undef },
  { rune => "ᛇ", nombre => "Eiwaz",    desc => "Cambio, conexión", invertido => undef },
  { rune => "ᛈ", nombre => "Perthro",  desc => "Destino, misterio", invertido => "Pérdida, azar negativo" },
  { rune => "ᛉ", nombre => "Algiz",    desc => "Protección, guía", invertido => "Vulnerabilidad" },
  { rune => "ᛋ", nombre => "Sowilo",   desc => "Éxito, energía", invertido => undef },
  { rune => "ᛏ", nombre => "Tiwaz",    desc => "Justicia, honor", invertido => "Fracaso, injusticia" },
  { rune => "ᛒ", nombre => "Berkano",  desc => "Nacimiento, crecimiento", invertido => "Estancamiento, infertilidad" },
  { rune => "ᛖ", nombre => "Ehwaz",    desc => "Movimiento, confianza", invertido => "Desconfianza, bloqueo" },
  { rune => "ᛗ", nombre => "Mannaz",   desc => "Humanidad, cooperación", invertido => "Aislamiento, ego" },
  { rune => "ᛚ", nombre => "Laguz",    desc => "Intuición, fluidez", invertido => "Confusión, miedo" },
  { rune => "ᛜ", nombre => "Ingwaz",   desc => "Potencial, paz interior", invertido => undef },
  { rune => "ᛞ", nombre => "Dagaz",    desc => "Despertar, renovación", invertido => undef },
  { rune => "ᛟ", nombre => "Othala",   desc => "Herencia, raíz", invertido => "Conflicto familiar, pérdida" },
  { rune => "᛫", nombre => "Odín",     desc => "Destino oculto, lo desconocido", invertido => undef },
);

sub tirar_runas {
  my ($cantidad) = @_;
  my @tirada = shuffle @runas;
  @tirada = @tirada[0..$cantidad-1];
  my @resultado;

  for my $r (@tirada) {
    my $invertida = (defined $r->{invertido} && $r->{invertido} ne '') ? int(rand(2)) : 0;
    my $significado = $invertida ? $r->{invertido} : $r->{desc};
    push @resultado, {
      nombre => $r->{nombre},
      rune => $r->{rune} || '᛫',
      invertida => $invertida,
      significado => $significado
    };
  }
  return @resultado;
}

sub mostrar_tirada {
  my ($titulo, @tirada) = @_;
  print "\n\e[1;35m=== $titulo ===\e[0m\n";
  my @posiciones = (
    "Primera", "Segunda", "Tercera", "Cuarta", "Quinta",
    "Sexta", "Séptima", "Octava", "Novena", "Décima", "Undécima", "Duodécima"
  );
  
  for my $i (0..$#tirada) {
    my $r = $tirada[$i];
    my $inv = $r->{invertida} ? " \e[31m(invertida)\e[0m" : "";
    print "\n[\e[33m$posiciones[$i]\e[0m] \e[1;32m$r->{nombre}\e[0m$inv\n";
    print "  Runa:        \e[34m$r->{rune}\e[0m\n";
    print "  Significado: $r->{significado}\n";
  }
  
  if (@tirada == 3 || @tirada == 5) {
    interpretar_tirada(@tirada);
  }
}

sub interpretar_tirada {
  my (@tirada) = @_;
  
  print "\n\e[1;36m🔮 Interpretación de la tirada:\e[0m\n";
  print "\e[1;34m" . ("=" x 50) . "\e[0m\n";

  if (@tirada == 3) {
    print "\n\e[1;33mEsta lectura de tres runas representa un viaje temporal:\e[0m\n\n";
    print "\e[1m1. PASADO (\e[34m$tirada[0]{rune}\e[0m - \e[32m$tirada[0]{nombre}\e[0m):\e[0m\n";
    print "   $tirada[0]{significado}\n\n";
    print "\e[1m2. PRESENTE (\e[34m$tirada[1]{rune}\e[0m - \e[32m$tirada[1]{nombre}\e[0m):\e[0m\n";
    print "   $tirada[1]{significado}\n\n";
    print "\e[1m3. FUTURO (\e[34m$tirada[2]{rune}\e[0m - \e[32m$tirada[2]{nombre}\e[0m):\e[0m\n";
    print "   $tirada[2]{significado}\n\n";
    print "\e[3mConsejo: Observa cómo el pasado influye en tu presente\n";
    print "y cómo tus acciones actuales moldearán el futuro.\e[0m\n";
  } 
  elsif (@tirada == 5) {
    print "\n\e[1;33mLa Cruz Rúnica muestra las fuerzas que actúan en tu vida:\e[0m\n\n";
    print "\e[1mCENTRO - Tu situación actual (\e[34m$tirada[0]{rune}\e[0m - \e[32m$tirada[0]{nombre}\e[0m):\e[0m\n";
    print "   $tirada[0]{significado}\n\n";
    print "\e[1mNORTE - Lo que te guía (\e[34m$tirada[1]{rune}\e[0m - \e[32m$tirada[1]{nombre}\e[0m):\e[0m\n";
    print "   $tirada[1]{significado}\n\n";
    print "\e[1mSUR - Tus fundamentos (\e[34m$tirada[2]{rune}\e[0m - \e[32m$tirada[2]{nombre}\e[0m):\e[0m\n";
    print "   $tirada[2]{significado}\n\n";
    print "\e[1mESTE - Lo que está surgiendo (\e[34m$tirada[3]{rune}\e[0m - \e[32m$tirada[3]{nombre}\e[0m):\e[0m\n";
    print "   $tirada[3]{significado}\n\n";
    print "\e[1mOESTE - Lo que está terminando (\e[34m$tirada[4]{rune}\e[0m - \e[32m$tirada[4]{nombre}\e[0m):\e[0m\n";
    print "   $tirada[4]{significado}\n\n";
    print "\e[3mReflexión: Considera cómo estos elementos interactúan\n";
    print "entre sí en tu camino actual.\e[0m\n";
  }
  
  print "\e[1;34m" . ("=" x 50) . "\e[0m\n";
}

sub mostrar_todas_las_runas {
  print "\n\e[1;35m=== TODAS LAS RUNAS ===\e[0m\n";
  for my $r (@runas) {
    print "\n\e[1;32m$r->{nombre}\e[0m\n";
    print "  Runa: \e[34m$r->{rune}\e[0m\n";
    print "  Significado: $r->{desc}\n";
    print "  Invertida: $r->{invertido}\n" if defined $r->{invertido};
    print "\nPresiona Enter para continuar...";
    <STDIN>;
  }
}

sub menu {
  while (1) {
    print "\n\e[1;35m===== MENÚ RÚNICO =====\e[0m\n";
    print "\e[33m1.\e[0m Mostrar todas las runas\n";
    print "\e[33m2.\e[0m Tirada de una runa\n";
    print "\e[33m3.\e[0m Tirada de tres runas (Pasado, Presente, Futuro)\n";
    print "\e[33m4.\e[0m Tirada de cinco runas (Cruz Rúnica)\n";
    print "\e[33m5.\e[0m Tirada de nueve runas (Rueda del Destino)\n";
    print "\e[33m6.\e[0m Tirada de siete runas (Yggdrasil)\n";
    print "\e[33m7.\e[0m Tirada de doce runas (Calendario Rúnico)\n";
    print "\e[31m0.\e[0m Salir\n";
    print "\n\e[1mElige una opción: \e[0m";
    chomp(my $opt = <STDIN>);

    if ($opt eq '1') {
      mostrar_todas_las_runas();
    } elsif ($opt eq '2') {
      my @t = tirar_runas(1);
      mostrar_tirada("Tirada de una runa", @t);
    } elsif ($opt eq '3') {
      my @t = tirar_runas(3);
      mostrar_tirada("Tirada de tres runas (Pasado, Presente, Futuro)", @t);
    } elsif ($opt eq '4') {
      my @t = tirar_runas(5);
      mostrar_tirada("Tirada de cinco runas (Cruz Rúnica)", @t);
    } elsif ($opt eq '5') {
      my @t = tirar_runas(9);
      mostrar_tirada("Tirada de nueve runas (Rueda del Destino)", @t);
    } elsif ($opt eq '6') {
      my @t = tirar_runas(7);
      mostrar_tirada("Tirada de siete runas (Yggdrasil)", @t);
    } elsif ($opt eq '7') {
      my @t = tirar_runas(12);
      mostrar_tirada("Tirada de doce runas (Calendario Rúnico)", @t);
    } elsif ($opt eq '0') {
      print "\n\e[1;35mQue las runas guíen tu camino. Hasta pronto!\e[0m\n";
      last;
    } else {
      print "\n\e[31mOpción inválida. Por favor elige un número del menú.\e[0m\n";
    }
    
    print "\n\e[3mPresiona Enter para continuar...\e[0m";
    <STDIN>;
  }
}

print "\n\e[1;35mBienvenido al Oráculo Rúnico Vikingo\e[0m\n";
print "\e[3mQue los dioses nórdicos guíen tu consulta...\e[0m\n";
menu();
