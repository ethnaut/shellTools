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

# Datos simbólicos
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

# Explicación general
sub intro_explicacion {
  print "\n📖 Las Ruedas de Giordano Bruno\n";
  print "Las ruedas combinatorias de Bruno generan una imagen simbólica compuesta por cinco elementos: \n";
  print "- Un MITO que representa la base narrativa o arquetipo en juego.\n";
  print "- Una FORMA que da cuerpo sensible o visible a la idea.\n";
  print "- Un AGENTE DIVINO como fuerza que mueve o transforma.\n";
  print "- Un DESTINO que muestra la dirección o sentido del símbolo.\n";
  print "- Una INFLUENCIA CELESTE que tiñe el conjunto con un matiz cósmico.\n";
  print "Estas ruedas no predicen: revelan el orden oculto de una experiencia simbólica actual.\n";
}

# Tirada simbólica
sub tirar_giordano {
  my @indices = map { int(rand(30)) } (1..5);
  my @letras = map { $sigilla[$_] } @indices;

  print "\n🔮 TIRADA SIMBÓLICA: $letras[0]-$letras[1]-$letras[2]-$letras[3]-$letras[4]\n\n";

  print "📘 INTERPRETACIÓN:\n";
  print "1. 🧙 Mito [$letras[0]] → $mito[$indices[0]]\n";
  print "   Representa la historia o arquetipo central que rige la imagen.\n";

  print "2. 🌿 Forma [$letras[1]] → $forma[$indices[1]]\n";
  print "   La apariencia sensible que adopta el símbolo en tu imaginación.\n";

  print "3. 👁️ Agente Divino [$letras[2]] → $agente[$indices[2]]\n";
  print "   El poder o impulso que pone en marcha el símbolo.\n";

  print "4. 🧭 Destino [$letras[3]] → $destino[$indices[3]]\n";
  print "   El desenlace simbólico o transfiguración en juego.\n";

  print "5. ✨ Influencia Celeste [$letras[4]] → $cielo[$indices[4]]\n";
  print "   Energía astrológica que impregna la imagen con un matiz superior.\n";

  # Descripción final de la imagen simbólica
  print "\n🖼️ IMAGEN RESULTANTE:\n";
  print "Imagina a $mito[$indices[0]] manifestado como $forma[$indices[1]],\n";
  print "impulsado por la fuerza de $agente[$indices[2]],\n";
  print "con el destino de $destino[$indices[3]],\n";
  print "bajo la influencia de $cielo[$indices[4]].\n";
  print "Esta es tu constelación simbólica actual.\n";
}

# Menú principal
sub menu {
  intro_explicacion();
  while (1) {
    print "\n===== MENÚ SIMBÓLICO DE GIORDANO BRUNO =====\n";
    print "1. Hacer una tirada\n";
    print "0. Salir\n";
    print "Elige una opción: ";
    chomp(my $opt = <STDIN>);
    if ($opt eq '1') {
      tirar_giordano();
    } elsif ($opt eq '0') {
      print "\n🌀 Que las ruedas giren en tu interior. Hasta pronto.\n";
      last;
    } else {
      print "⚠️  Opción no válida. Intenta de nuevo.\n";
    }
  }
}

menu();

