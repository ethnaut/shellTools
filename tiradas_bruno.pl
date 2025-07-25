#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use List::Util qw(shuffle);
binmode STDOUT, ':utf8';

# Letras/símbolos de Giordano Bruno (sigilla)
my @sigilla = qw(
  A B C D E F G H I K L M N O P Q R S T V X Y Z & Ͻ Ͻ̅ Ͻ̿ Ʒ Ʒ̅ Ʒ̿
);

# Datos: MITO, FORMA, AGENTE, DESTINO, INFLUENCIA
my @mito = qw(
  Dafne Narciso Aracne Acteón Ícaro Faetón Calisto Eco Licaón Níobe
  Filemón Baucis Progne Filomela Ceyx Alcíone Mirra Adonis Atalanta Hipómenes
  Píramo Tisbe Cipariso Céfalo Aurora Midas Orión Tiresias Penélope Medea
);

my @forma = qw(
  Árbol Ave Río Flor Estrella Roca Sombra Fuego Estatua Niebla
  "Animal salvaje" "Eco (sonido)" Insecto Luna Mar Llama Pez Musgo Arena Vid
  Cuervo Ciervo Gato Cisne "Cielo estrellado" Nube Brisa Espina Cristal Sangre
);

my @agente = qw(
  Apolo Artemisa Atenea Zeus Hera Afrodita Ares Hermes Hades Dionisio
  Eros Hécate Némesis Fortuna Cronos Perséfone Morfeo Jano Nereo Pan
  Bóreas Tetis Circe Selene Eolo Ananké Iris Caronte Caos "Las Moiras"
);

my @destino = qw(
  Castigo Redención "Gloria eterna" Perdición "Amor imposible" "Sabiduría oculta"
  "Muerte ritual" "Tragedia ejemplar" "Compasión divina" Transfiguración
  "Dolor eterno" "Libertad espiritual" "Silencio impuesto" "Oscuridad moral" "Belleza inmortal"
  "Justicia poética" "Revelación profética" "Obsesión sin fin" "Inmovilidad sagrada" "Integración cósmica"
  "Dualidad rota" "Deseo negado" "Disolución del ego" "Perdón inesperado" "Violencia transformadora"
  "Inocencia anulada" "Unión espiritual" "Renacimiento cíclico" "Confusión identitaria" "Fusión con el Todo"
);

my @cielo = (
  "Aries / Marte", "Tauro / Venus", "Géminis / Mercurio", "Cáncer / Luna", "Leo / Sol", "Virgo / Mercurio",
  "Libra / Venus", "Escorpio / Plutón", "Sagitario / Júpiter", "Capricornio / Saturno",
  "Acuario / Urano", "Piscis / Neptuno", "Orión (constelación)", "Sirio (estrella)", "Antares", "Algol",
  "Aldebarán", "Procyon", "Polaris", "Vega", "Eclipse solar", "Eclipse lunar", "Nodo Norte", "Nodo Sur",
  "Cauda Draconis", "Caput Draconis", "Estrella fija de Saturno", "Anima Mundi", "Eje ascendente", "Esfera de las estrellas fijas"
);

# Generar 5 índices aleatorios
my @indices = map { int(rand(30)) } (1..5);

# Obtener letras sigilla
my @letras = map { $sigilla[$_] } @indices;

# Mostrar tirada simbólica
print "\n📜 Tirada: $letras[0]-$letras[1]-$letras[2]-$letras[3]-$letras[4]\n\n";

# Mostrar correspondencias
print "🧩 Correspondencias:\n";
printf "Mito              [%s] → %s\n", $letras[0], $mito[$indices[0]];
printf "Forma             [%s] → %s\n", $letras[1], $forma[$indices[1]];
printf "Agente divino     [%s] → %s\n", $letras[2], $agente[$indices[2]];
printf "Destino simbólico [%s] → %s\n", $letras[3], $destino[$indices[3]];
printf "Influencia celeste[%s] → %s\n", $letras[4], $cielo[$indices[4]];

