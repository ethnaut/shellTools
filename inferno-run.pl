#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use List::Util qw/shuffle/;
use open ':std', ':encoding(UTF-8)';

binmode(STDIN,  ':encoding(UTF-8)');
binmode(STDOUT, ':encoding(UTF-8)');

# === DATOS DEL INFIERNO ===
my @circulos = (
  "Limbo", "Lujuria", "Gula", "Avaricia", "Ira", "Herejía", "Violencia", "Fraude", "Traición"
);

my @dilemas = (
  [ "¿Salvarías a un sabio pagano del olvido eterno?",
    "¿Defenderías a un alma que nunca conoció fe ni pecado?",
    "¿Justificarías la ignorancia si vino de la virtud?" ],
  [ "¿Perdonarías un deseo carnal nacido del amor?",
    "¿Excusarías una pasión que destruyó una familia?",
    "¿Admitirías el placer por encima del deber?" ],
  [ "¿Perdonarías a quien come mientras otros mueren de hambre?",
    "¿Aceptarías la gula como consuelo al sufrimiento?",
    "¿Verías como humano al que no supo parar?" ],
  [ "¿Defenderías a quien acumuló sin dar?",
    "¿Justificarías a quien roba al rico para vivir?",
    "¿La avaricia puede tener rostro de necesidad?" ],
  [ "¿Excusarías la ira por venganza personal?",
    "¿La furia es justicia si la ley es injusta?",
    "¿Ignorar la rabia la convierte en virtud?" ],
  [ "¿Salvarías a Hipatia, mártir del pensamiento?",
    "¿Puede ser santo quien negó el dogma?",
    "¿Justificarías herejía si trajo compasión?" ],
  [ "¿Está condenado quien lucha por honor sangriento?",
    "¿Puede el asesino ser héroe en otro mundo?",
    "¿Se puede matar por amor?" ],
  [ "¿Perdonarías al embustero si salvó una vida?",
    "¿Mentirías para proteger a alguien inocente?",
    "¿Es fraude prometer esperanza a cambio de fe?" ],
  [ "¿La traición por amor merece castigo eterno?",
    "¿Salvarías a un Judas arrepentido?",
    "¿La lealtad absoluta es una virtud o una trampa?" ],
);

my @castigos = (
  [ "Vagan sin propósito bajo un cielo sin estrellas.",
    "Habitan en sombras que imitan la vida.",
    "Escuchan ecos de lo que nunca dijeron." ],
  [ "Arrastrados por vientos eternos sin tocar tierra.",
    "Desean sin saciarse, cuerpo de llamas.",
    "Acarician fantasmas que se desvanecen." ],
  [ "Deben devorar barro y fuego por siempre.",
    "Revolcados en pantanos dulces que los ahogan.",
    "Sus lenguas hinchadas gritan sin sonido." ],
  [ "Encerrados en cofres dorados con clavos.",
    "Manos atadas con cadenas de oro ardiente.",
    "Todo lo que tocan se convierte en polvo." ],
  [ "Luchan en ríos de sangre hirviendo.",
    "Mueren una y otra vez por rabia.",
    "Sus gritos despiertan tormentas sin fin." ],
  [ "Encerrados en tumbas ardientes sin techo.",
    "Oyen sus doctrinas repetidas por demonios burlones.",
    "Sus pensamientos son espejos que los juzgan." ],
  [ "Llovidos por flechas eternas en un bosque seco.",
    "Cada paso sangra y cada decisión condena.",
    "Caminar sobre cuerpos que alguna vez amaron." ],
  [ "Lenguas arrancadas por corbatas de plomo.",
    "Sus rostros se multiplican en máscaras falsas.",
    "Vomitadores de mentiras con serpientes por lengua." ],
  [ "Congelados en hielo negro, sólo sus ojos se mueven.",
    "Son espejo de la traición que cometieron.",
    "La sangre los abandona y vuelve a entrar." ],
);

# Descripciones de demonios
my @descripciones_demonios = (
  [ "Caronte: el barquero que conduce almas al Infierno. No juzga, pero exige pago.",
    "Minos: juzga cada alma y envía al círculo correspondiente, enroscando su cola.",
    "Virgilio caído: tu guía original, ahora condenado por no conocer a Cristo." ],
  [ "Asmodeo: rey del Infierno en algunas tradiciones, símbolo del orgullo y deseo.",
    "Lilith: primera mujer de Adán, demonio del deseo prohibido y la seducción.",
    "Belphegor: tentador de la pereza y los placeres ocultos." ],
  [ "Beelzebub: 'Señor de las moscas', asociado a la corrupción y la descomposición.",
    "Gula: personificación del exceso alimentario y la autodestrucción.",
    "Geryon: monstruo del fraude, con rostro amable y cola escorpiónica." ],
  [ "Mammon: dios del dinero, símbolo de la codicia espiritual.",
    "Plutus: deidad romana de la riqueza, aquí convertido en guardián infernal.",
    "Avarice personificada: figura encadenada a su propio tesoro." ],
  [ "Satanás menor: sombra del gran enemigo, que alimenta la furia inútil.",
    "Alecto: una de las Furias, que incita al odio eterno.",
    "Megaera: otra Furia, castiga a quienes odian sin razón." ],
  [ "Belial: espíritu de la corrupción y la negación de lo sagrado.",
    "Typhon: titán rebelde, símbolo del caos contra el orden divino.",
    "Lucifuge Rofocale: 'el que huye de la luz', príncipe de las tinieblas." ],
  [ "Moloch: dios que exige sacrificios humanos, ícono de la brutalidad.",
    "Ares infernal: versión corrupta del dios de la guerra.",
    "Murciélago de sangre: criatura que vive del dolor ajeno." ],
  [ "Bael: rey de los infiernos en el Goetia, engaña con promesas de poder.",
    "Orobas: espíritu que revela verdades... pero nunca como se esperan.",
    "Paimon: sirve conocimiento, pero exige obediencia ciega." ],
  [ "Lucifer: el Caído, atrapado en hielo, muerde a los traidores por la eternidad.",
    "Bruto y Casio: traidores a César, considerados entre los peores por Dante.",
    "Caín espectral: reflejo del primer fratricida, condenado por siempre." ],
);

my @demonios = (
  [ "Caronte", "Minos", "Virgilio caído" ],
  [ "Asmodeo", "Lilith", "Belphegor" ],
  [ "Beelzebub", "Gula", "Geryon" ],
  [ "Mammon", "Plutus", "Avarice personificada" ],
  [ "Satanás menor", "Alecto", "Megaera" ],
  [ "Belial", "Typhon", "Lucifuge Rofocale" ],
  [ "Moloch", "Ares infernal", "Murciélago de sangre" ],
  [ "Bael", "Orobas", "Paimon" ],
  [ "Lucifer", "Bruto y Casio", "Caín espectral" ],
);

my @citas = (
  [ "El no bautizado no es culpable, pero tampoco libre.",
    "Sin culpa, sin gloria, sólo olvido." ],
  [ "El deseo que abrasa también ilumina.",
    "El placer sin amor es viento sin sentido." ],
  [ "La abundancia que ignora es condena suficiente.",
    "Entre manjares lloran los que una vez negaron pan." ],
  [ "La riqueza que no fluye se convierte en prisión.",
    "Poseer no es maldad, retener sin medida lo es." ],
  [ "El fuego interior puede consumir más que el infierno.",
    "La ira sin justicia es sólo destrucción." ],
  [ "Pensar distinto no absuelve, pero tampoco condena.",
    "El que duda con razón merece respuesta, no fuego." ],
  [ "Violencia en nombre del bien, ¿no es doble crimen?",
    "Cada golpe deja eco en el alma." ],
  [ "La mentira piadosa aún mancha.",
    "Verdades rotas por miedo generan infiernos nuevos." ],
  [ "Traicionar por amor, ¿acaso no es amar con miedo?",
    "La daga no siempre hiere más que el silencio." ],
);

# Frases finales que aluden a tus decisiones
my @frases_finales = (
  "En el Limbo, recordaste que la virtud sin fe no condena, pero tú elegiste %s: ¿fue compasión o duda?",
  "En la tormenta de la Lujuria, dijiste %s: ¿amor o debilidad guió tu voz?",
  "Frente al hambre del mundo, respondiste %s: ¿fue piedad o condena lo que sembraste?",
  "Ante el oro maldito, tu palabra fue %s: ¿necesidad o codicia habló por ti?",
  "Cuando la ira rugió, dijiste %s: ¿justicia o venganza llevas en el pecho?",
  "En la tumba del pensamiento, elegiste %s: ¿temiste a la verdad o la honraste?",
  "Ante el asesino con causa, respondiste %s: ¿puedes matar por un bien mayor?",
  "Cuando la mentira salvó una vida, dijiste %s: ¿el fin justifica el alma rota?",
  "Al final, ante la traición por amor, tu respuesta fue %s: ¿puede el amor romper el juramento eterno?"
);

# Bucle principal del juego
while (1) {
    # Reiniciar contadores
    my $sí = 0;
    my $no = 0;
    my $no_sé = 0;
    my @respuestas = ();  # Guardar respuestas para frases finales

    print "\n" . "="x70 . "\n";
    print "           INFERNO RUN - ¿ESTÁS LISTO PARA DESCENDER?\n";
    print "="x70 . "\n";
    print "Responde a 9 dilemas con:\n";
    print "  s  → sí\n";
    print "  n  → no\n";
    print "  ns → no sé\n\n";
    print "Presiona ENTER para comenzar...\n";
    <STDIN>;

    # Juego principal
    for my $i (0..$#circulos) {
        print "\n" . ("=" x 60) . "\n";
        printf "           [CÍRCULO %d: %s]\n", $i+1, $circulos[$i];
        print ("=" x 60) . "\n";

        my $idx = int(rand(3));
        my $d = $dilemas[$i][$idx];
        my $c = $castigos[$i][$idx];
        my $de = $demonios[$i][$idx];
        my $desc = $descripciones_demonios[$i][$idx];
        my $q = $citas[$i][int(rand @{$citas[$i]})];

        print "\n";
        print "🔥  DILEMA MORAL:\n";
        print "    $d\n\n";

        my $respuesta;
        while (1) {
            print "Responder (s / n / ns): ";
            $respuesta = <STDIN>;
            chomp $respuesta;
            $respuesta = lc($respuesta);

            if ($respuesta eq 's' || $respuesta eq 'n' || $respuesta eq 'ns') {
                last;
            } else {
                print "  Por favor: s (sí), n (no), ns (no sé)\n";
            }
        }

        # Guardar y contar
        push @respuestas, $respuesta;
        $sí++   if $respuesta eq 's';
        $no++   if $respuesta eq 'n';
        $no_sé++ if $respuesta eq 'ns';

        # Revelar
        print "\n➡️  CASTIGO ETERNO:\n";
        print "    $c\n\n";

        print "👹  DEMONIO REGENTE: $de\n";
        print "    $desc\n\n";

        print "📜  CITA INFERNAL: “$q”\n";
        print "\n";

        if ($i < $#circulos) {
            print "Presiona ENTER para descender...\n";
        } else {
            print "Presiona ENTER para alcanzar el centro...\n";
        }
        <STDIN>;
    }

    # === JUICIO FINAL ===
    print "\n" . ("#" x 70) . "\n";
    print "                   TU JUICIO FINAL\n";
    print ("#" x 70) . "\n";

    print "Tus respuestas:\n";
    print "  Sí:     $sí\n";
    print "  No:     $no\n";
    print "  No sé:  $no_sé\n\n";

    # Traducir respuestas a palabras
    my %trad = ('s' => 'sí', 'n' => 'no', 'ns' => 'no sé');
    my @respuestas_texto = map { $trad{$_} } @respuestas;

    # Frases finales que aluden a cada respuesta
    print "🔊 ÚLTIMAS VOCES DEL INFIERNO:\n";
    for my $i (0..8) {
        my $frase = $frases_finales[$i];
        printf "  • $frase\n", $respuestas_texto[$i];
    }
    print "\n";

    # Veredicto
    my $veredicto;
    if ($no_sé >= 5) {
        $veredicto = "Al infierno por pusilánime: evadiste el juicio cuando tu alma debía decidir.";
    } elsif ($no_sé >= 3 && $sí < 3 && $no < 3) {
        $veredicto = "Al limbo por tibio: ni condenaste ni redimiste. Flotaste entre mundos.";
    } elsif ($sí >= 5 && $no <= 3) {
        $veredicto = "Alcanzaste la virtud, por lo que podrás salir: tu compasión y razón te redimen.";
    } elsif ($no >= 5 && $sí <= 3) {
        $veredicto = "Al infierno por intransigente: tu justicia fue sin piedad, tu juicio sin duda.";
    } else {
        $veredicto = "Al limbo por rígido: tu moral es firme, pero tu corazón no se abrió.";
    }

    print "📢 SENTENCIA: $veredicto\n\n";

    # Opción de repetir
    while (1) {
        print "¿Deseas descender de nuevo? (s / n): ";
        my $retry = <STDIN>;
        chomp $retry;
        $retry = lc($retry);
        if ($retry eq 's' || $retry eq 'si' || $retry eq 'sí') {
            last;
        } elsif ($retry eq 'n' || $retry eq 'no') {
            print "\nGracias por tu viaje. El Infierno siempre te recordará.\n";
            exit;
        } else {
            print "Por favor, responde 's' o 'n'.\n";
        }
    }
}
