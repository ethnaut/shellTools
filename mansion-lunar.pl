#!/usr/bin/perl
use strict;
use warnings;
use utf8;
binmode STDOUT, ":encoding(UTF-8)";
use POSIX qw(floor);

# Tabla simplificada de las 28 mansiones lunares del Picatrix
my @mansiones = (
  { num=>1, nombre=>"Al Sharatain",  sig=>"Fuerza, protección y combate.", magia=>"Protección en batalla y fortaleza física.", talisman=>"Amuletos con símbolos de fuerza y resistencia.", espiritu=>"Ruh al Sharatain" },
  { num=>2, nombre=>"Al Butain",     sig=>"Curación, paciencia y recuperación.", magia=>"Sanación y fortaleza en enfermedades.", talisman=>"Piedras verdes, símbolos de salud.", espiritu=>"Ruh al Butain" },
  { num=>3, nombre=>"Al Thurayya",    sig=>"Belleza y fama.", magia=>"Atracción, arte y creatividad.", talisman=>"Símbolos de estrella y luz.", espiritu=>"Ruh al Thurayya" },
  { num=>4, nombre=>"Al Dhanab",     sig=>"Confianza y liderazgo.", magia=>"Poder para influir y dominar.", talisman=>"Insignias y símbolos reales.", espiritu=>"Ruh al Dhanab" },
  { num=>5, nombre=>"Al Fargh al Thani", sig=>"Disciplina y orden.", magia=>"Organización y éxito en tareas.", talisman=>"Símbolos geométricos.", espiritu=>"Ruh al Fargh al Thani" },
  { num=>6, nombre=>"Al Nakah",      sig=>"Sabiduría y justicia.", magia=>"Claridad mental y equilibrio.", talisman=>"Balanzas y símbolos de justicia.", espiritu=>"Ruh al Nakah" },
  { num=>7, nombre=>"Al Khafzah",    sig=>"Valor y protección contra enemigos.", magia=>"Defensa mágica y coraje.", talisman=>"Escudos y armas simbólicas.", espiritu=>"Ruh al Khafzah" },
  { num=>8, nombre=>"Al Risha",      sig=>"Movimiento y cambio.", magia=>"Facilitar viajes y decisiones.", talisman=>"Símbolos de viento y agua.", espiritu=>"Ruh al Risha" },
  { num=>9, nombre=>"Al Simak",      sig=>"Abundancia y riqueza.", magia=>"Atraer prosperidad y suerte.", talisman=>"Monedas y símbolos de fortuna.", espiritu=>"Ruh al Simak" },
  { num=>10,nombre=>"Al Azim",       sig=>"Claridad y visión.", magia=>"Mejora de la percepción y memoria.", talisman=>"Ojos y cristales.", espiritu=>"Ruh al Azim" },
  { num=>11,nombre=>"Al Banat",      sig=>"Pureza y protección espiritual.", magia=>"Limpieza energética y bendiciones.", talisman=>"Cristales blancos y amuletos.", espiritu=>"Ruh al Banat" },
  { num=>12,nombre=>"Al Jabhah",     sig=>"Paciencia y perseverancia.", magia=>"Resistencia y determinación.", talisman=>"Símbolos de montaña y tierra.", espiritu=>"Ruh al Jabhah" },
  { num=>13,nombre=>"Al Hibb al Thani", sig=>"Alegría y amistad.", magia=>"Fomentar relaciones armoniosas.", talisman=>"Flores y símbolos de unión.", espiritu=>"Ruh al Hibb al Thani" },
  { num=>14,nombre=>"Al Zalzalah",   sig=>"Fuerza y energía dinámica.", magia=>"Potenciación de la energía física.", talisman=>"Rayos y símbolos de poder.", espiritu=>"Ruh al Zalzalah" },
  { num=>15,nombre=>"Al Awwa",       sig=>"Protección contra el mal.", magia=>"Defensa mágica y purificación.", talisman=>"Amuletos protectores.", espiritu=>"Ruh al Awwa" },
  { num=>16,nombre=>"Al Hujjaj",     sig=>"Viajes y protección en caminos.", magia=>"Seguridad en desplazamientos.", talisman=>"Llaves y símbolos de viaje.", espiritu=>"Ruh al Hujjaj" },
  { num=>17,nombre=>"Al Mizan",      sig=>"Justicia y equilibrio.", magia=>"Armonía y resolución de conflictos.", talisman=>"Balanzas y símbolos de equidad.", espiritu=>"Ruh al Mizan" },
  { num=>18,nombre=>"Al Aqrab",      sig=>"Transformación y poder oculto.", magia=>"Poderes psíquicos y magia oculta.", talisman=>"Escorpiones y símbolos místicos.", espiritu=>"Ruh al Aqrab" },
  { num=>19,nombre=>"Al Tarfah",     sig=>"Protección y resistencia.", magia=>"Fortaleza ante adversidades.", talisman=>"Escudos y símbolos de resistencia.", espiritu=>"Ruh al Tarfah" },
  { num=>20,nombre=>"Al Jabhah al Thani", sig=>"Concentración y estudio.", magia=>"Aumento de concentración mental.", talisman=>"Libros y símbolos intelectuales.", espiritu=>"Ruh al Jabhah al Thani" },
  { num=>21,nombre=>"Al Shara",      sig=>"Éxito y victoria.", magia=>"Potenciación del éxito personal.", talisman=>"Trofeos y símbolos de triunfo.", espiritu=>"Ruh al Shara" },
  { num=>22,nombre=>"Al Dhira",      sig=>"Iluminación y guía espiritual.", magia=>"Clarividencia y sabiduría.", talisman=>"Luz y símbolos sagrados.", espiritu=>"Ruh al Dhira" },
  { num=>23,nombre=>"Al Na'ir",      sig=>"Comunicación y expresión.", magia=>"Facilitar el habla y persuasión.", talisman=>"Plumas y símbolos de comunicación.", espiritu=>"Ruh al Na'ir" },
  { num=>24,nombre=>"Al Tayyarah",   sig=>"Velocidad y agilidad.", magia=>"Rapidez en acciones y decisiones.", talisman=>"Aves y símbolos de velocidad.", espiritu=>"Ruh al Tayyarah" },
  { num=>25,nombre=>"Al Sarfah",     sig=>"Protección y limpieza.", magia=>"Eliminar energías negativas.", talisman=>"Sales y símbolos purificadores.", espiritu=>"Ruh al Sarfah" },
  { num=>26,nombre=>"Al Risha al Thani", sig=>"Inspiración y creatividad.", magia=>"Favorecer la inspiración artística.", talisman=>"Instrumentos y símbolos creativos.", espiritu=>"Ruh al Risha al Thani" },
  { num=>27,nombre=>"Al Jabhah al Thalith", sig=>"Fuerza y estabilidad.", magia=>"Aumentar la estabilidad y fuerza.", talisman=>"Piedras sólidas y símbolos firmes.", espiritu=>"Ruh al Jabhah al Thalith" },
  { num=>28,nombre=>"Al Dhanab al Thani", sig=>"Renovación y espiritualidad.", magia=>"Renovación interna y protección espiritual.", talisman=>"Símbolos de renacer y luz.", espiritu=>"Ruh al Dhanab al Thani" },
);

# Planetas con longitud aproximada (grados zodiacales)
my %planetas = (
  Sol      => 0,
  Mercurio => 60,
  Venus    => 75,
  Marte    => 120,
  Júpiter  => 240,
  Saturno  => 300,
);

sub deg2rad { $_[0] * 3.14159265359 / 180 }
sub fmod { $_[0] - 360 * int($_[0]/360) }

# Calculo simplificado de longitudes solar y lunar (efemérides muy básicas)
sub obtener_longitudes {
  my ($dias) = @_;
  $dias ||= 0;

  my $t = time + $dias * 86400;
  my ($sec,$min,$hour,$mday,$mon,$year) = gmtime($t);
  $year += 1900; $mon += 1;

  # Cálculo aproximado del día juliano
  my $a = int((14 - $mon)/12);
  my $y = $year + 4800 - $a;
  my $m = $mon + 12*$a - 3;
  my $jd = $mday + int((153*$m + 2)/5) + 365*$y + int($y/4) - int($y/100) + int($y/400) - 32045;

  my $T = ($jd - 2451545.0)/36525.0;

  # Longitud media solar (grados)
  my $L_sun = 280.460 + 36000.770 * $T;
  $L_sun = fmod($L_sun, 360);

  # Longitud media lunar (grados)
  my $L_moon = 218.316 + 481267.881 * $T;
  $L_moon = fmod($L_moon, 360);

  # Desfasajes para la luna
  my $M_moon = 134.963 + 477198.867 * $T;
  my $D = 297.850 + 445267.111 * $T;

  # Correcciones lunares simplificadas
  my $lambda_moon = $L_moon + 6.289 * sin(deg2rad($M_moon)) - 3.274 * sin(deg2rad(2*$D));
  $lambda_moon = fmod($lambda_moon, 360);

  # Posición sideral simplificada luna
  my $pos_sidereal = fmod($lambda_moon - 24, 360);

  return ($pos_sidereal, $L_sun, $lambda_moon);
}

sub fase_lunar {
  my ($sun, $moon) = @_;
  my $dif = fmod($moon - $sun + 360, 360);
  return "🌑 Nueva"     if $dif < 22.5 || $dif > 337.5;
  return "🌓 Creciente" if $dif < 157.5;
  return "🌕 Llena"     if $dif < 202.5;
  return "🌗 Menguante";
}

sub conjunciones {
  my ($moon) = @_;
  my @cercanos;
  while (my ($planeta, $lon) = each %planetas) {
    my $dif = abs(fmod($moon - $lon + 360, 360));
    $dif = 360 - $dif if $dif > 180;
    push @cercanos, $planeta if $dif <= 6;
  }
  return @cercanos;
}

sub mostrar_mansion {
  my ($dias) = @_;
  $dias ||= 0;

  my ($pos_sidereal, $sun, $moon) = obtener_longitudes($dias);
  my $fase = fase_lunar($sun, $moon);
  my @cj = conjunciones($moon);

  my $tam = 360 / 28;
  my $i = int($pos_sidereal / $tam);

  my $m = $mansiones[$i];

  my $fecha = scalar gmtime(time + $dias * 86400);

  print "\n🌙 MANSIÓN LUNAR PICATRIX\n";
  print "Fecha UTC          : $fecha (+$dias días)\n";
  printf "Posición sideral   : %.2f°\n", $pos_sidereal;
  printf "Luna geocéntrica   : %.2f° | Sol: %.2f°\n", $moon, $sun;
  print  "Fase lunar         : $fase\n";
  print  "Conjunciones       : ", (@cj ? join(", ", @cj) : "Ninguna"), "\n";
  print  "----------------------------------\n";
  print  "Mansión número     : $m->{num}\n";
  print  "Nombre             : $m->{nombre}\n";
  printf "Grado zodiacal     : %.2f° – %.2f°\n", $i*$tam, ($i+1)*$tam;
  print  "Significado        : $m->{sig}\n";
  print  "Magia recomendada  : $m->{magia}\n";
  print  "Talismán           : $m->{talisman}\n";
  print  "Espíritu asociado  : $m->{espiritu}\n";
  print  "----------------------------------\n";
}

my $n = shift || 0;
mostrar_mansion($n);
