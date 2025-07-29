#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Encode qw(decode encode);
use List::Util qw(shuffle);

# Configuración de codificación
binmode(STDOUT, ':utf8');
binmode(STDIN,  ':utf8');

# -----------------------------
# 1. DEFINICIÓN DE LAS CARTAS
# -----------------------------

my @cartas = (
    # Arcanos Mayores
    {
        nombre => "El Loco",
        tipo => "Mayor",
        numero => 0,
        letra_hebrea => "Aleph",
        caracter_hebreo => "א",
        signo_astrologico => "Acuario",
        simbolo_signo => "♒",
        elemento => "Aire",
        caracter_signo => "Fijo",
        significado => {
            derecho => "Libertad, espontaneidad, nuevos comienzos, fe en el destino.",
            invertido => "Locura, imprudencia, inestabilidad, falta de dirección."
        }
    },
    {
        nombre => "El Mago",
        tipo => "Mayor",
        numero => 1,
        letra_hebrea => "Beth",
        caracter_hebreo => "ב",
        signo_astrologico => "Géminis",
        simbolo_signo => "♊",
        elemento => "Aire",
        caracter_signo => "Mutable",
        significado => {
            derecho => "Habilidad, recursos, comunicación, manifestación.",
            invertido => "Engaño, manipulación, habilidades mal utilizadas."
        }
    },
    {
        nombre => "La Sacerdotisa",
        tipo => "Mayor",
        numero => 2,
        letra_hebrea => "Ghimel",
        caracter_hebreo => "ג",
        signo_astrologico => "Luna",
        simbolo_signo => "☽",
        elemento => "Agua",
        caracter_signo => "Cambiante",
        significado => {
            derecho => "Intuición, misterio, conocimiento oculto, sabiduría interior.",
            invertido => "Secretos, ocultamiento, desconfianza, aislamiento."
        }
    },
    {
        nombre => "La Emperatriz",
        tipo => "Mayor",
        numero => 3,
        letra_hebrea => "Daleth",
        caracter_hebreo => "ד",
        signo_astrologico => "Virgo",
        simbolo_signo => "♍",
        elemento => "Tierra",
        caracter_signo => "Mutable",
        significado => {
            derecho => "Abundancia, fertilidad, creatividad, cuidado maternal.",
            invertido => "Infertilidad, dependencia, sobreprotección."
        }
    },
    {
        nombre => "El Emperador",
        tipo => "Mayor",
        numero => 4,
        letra_hebrea => "He",
        caracter_hebreo => "ה",
        signo_astrologico => "Aries",
        simbolo_signo => "♈",
        elemento => "Fuego",
        caracter_signo => "Cardinal",
        significado => {
            derecho => "Autoridad, estructura, estabilidad, liderazgo.",
            invertido => "Tiranía, rigidez, abuso de poder."
        }
    },
    {
        nombre => "El Sumo Sacerdote",
        tipo => "Mayor",
        numero => 5,
        letra_hebrea => "Vav",
        caracter_hebreo => "ו",
        signo_astrologico => "Tauro",
        simbolo_signo => "♉",
        elemento => "Tierra",
        caracter_signo => "Fijo",
        significado => {
            derecho => "Tradición, espiritualidad, guía, moral.",
            invertido => "Rigidez religiosa, dogmatismo, falta de innovación."
        }
    },
    {
        nombre => "Los Enamorados",
        tipo => "Mayor",
        numero => 6,
        letra_hebrea => "Zain",
        caracter_hebreo => "ז",
        signo_astrologico => "Libra",
        simbolo_signo => "♎",
        elemento => "Aire",
        caracter_signo => "Cardinal",
        significado => {
            derecho => "Elección, amor, armonía, valores.",
            invertido => "Conflicto, mala elección, desequilibrio."
        }
    },
    {
        nombre => "El Carro",
        tipo => "Mayor",
        numero => 7,
        letra_hebrea => "Cheth",
        caracter_hebreo => "ח",
        signo_astrologico => "Cáncer",
        simbolo_signo => "♋",
        elemento => "Agua",
        caracter_signo => "Cardinal",
        significado => {
            derecho => "Victoria, determinación, control, progreso.",
            invertido => "Derrota, descontrol, obstáculos internos."
        }
    },
    {
        nombre => "La Fuerza",
        tipo => "Mayor",
        numero => 8,
        letra_hebrea => "Teth",
        caracter_hebreo => "ט",
        signo_astrologico => "Leo",
        simbolo_signo => "♌",
        elemento => "Fuego",
        caracter_signo => "Fijo",
        significado => {
            derecho => "Coraje, compasión, dominio interior, paciencia.",
            invertido => "Debilidad, ira, impaciencia, victimismo."
        }
    },
    {
        nombre => "El Ermitaño",
        tipo => "Mayor",
        numero => 9,
        letra_hebrea => "Yod",
        caracter_hebreo => "י",
        signo_astrologico => "Virgo",
        simbolo_signo => "♍",
        elemento => "Tierra",
        caracter_signo => "Mutable",
        significado => {
            derecho => "Reflexión, sabiduría, búsqueda interior, guía.",
            invertido => "Aislamiento, soledad, retraimiento excesivo."
        }
    },
    {
        nombre => "La Rueda de la Fortuna",
        tipo => "Mayor",
        numero => 10,
        letra_hebrea => "Kaph",
        caracter_hebreo => "כ",
        signo_astrologico => "Júpiter",
        simbolo_signo => "♃",
        elemento => "Aire",
        caracter_signo => "Mutable",
        significado => {
            derecho => "Cambio, ciclo, suerte, destino.",
            invertido => "Mala suerte, resistencia al cambio, estancamiento."
        }
    },
    {
        nombre => "La Justicia",
        tipo => "Mayor",
        numero => 11,
        letra_hebrea => "Lamed",
        caracter_hebreo => "ל",
        signo_astrologico => "Libra",
        simbolo_signo => "♎",
        elemento => "Aire",
        caracter_signo => "Cardinal",
        significado => {
            derecho => "Equilibrio, justicia, verdad, causa y efecto.",
            invertido => "Injusticia, prejuicio, desequilibrio kármico."
        }
    },
    {
        nombre => "El Colgado",
        tipo => "Mayor",
        numero => 12,
        letra_hebrea => "Mem",
        caracter_hebreo => "מ",
        signo_astrologico => "Piscis",
        simbolo_signo => "♓",
        elemento => "Agua",
        caracter_signo => "Mutable",
        significado => {
            derecho => "Sacrificio, nueva perspectiva, suspensión.",
            invertido => "Estancamiento, victimismo, resistencia al sacrificio."
        }
    },
    {
        nombre => "La Muerte",
        tipo => "Mayor",
        numero => 13,
        letra_hebrea => "Nun",
        caracter_hebreo => "נ",
        signo_astrologico => "Escorpio",
        simbolo_signo => "♏",
        elemento => "Agua",
        caracter_signo => "Fijo",
        significado => {
            derecho => "Transformación, final, renacimiento.",
            invertido => "Resistencia al cambio, miedo a lo nuevo."
        }
    },
    {
        nombre => "La Temperancia",
        tipo => "Mayor",
        numero => 14,
        letra_hebrea => "Samekh",
        caracter_hebreo => "ס",
        signo_astrologico => "Sagitario",
        simbolo_signo => "♐",
        elemento => "Fuego",
        caracter_signo => "Mutable",
        significado => {
            derecho => "Armonía, paciencia, equilibrio, alquimia.",
            invertido => "Desbalance, impaciencia, conflicto interno."
        }
    },
    {
        nombre => "El Diablo",
        tipo => "Mayor",
        numero => 15,
        letra_hebrea => "Ayin",
        caracter_hebreo => "ע",
        signo_astrologico => "Capricornio",
        simbolo_signo => "♑",
        elemento => "Tierra",
        caracter_signo => "Cardinal",
        significado => {
            derecho => "Materialismo, tentación, atracción, dependencia.",
            invertido => "Liberación, superación de ataduras, claridad."
        }
    },
    {
        nombre => "La Torre",
        tipo => "Mayor",
        numero => 16,
        letra_hebrea => "Pe",
        caracter_hebreo => "פ",
        signo_astrologico => "Marte",
        simbolo_signo => "♂",
        elemento => "Fuego",
        caracter_signo => "Cardinal",
        significado => {
            derecho => "Revelación, caída, despertar brusco, destrucción necesaria.",
            invertido => "Resistencia al cambio, miedo al colapso."
        }
    },
    {
        nombre => "La Estrella",
        tipo => "Mayor",
        numero => 17,
        letra_hebrea => "Tsade",
        caracter_hebreo => "צ",
        signo_astrologico => "Acuario",
        simbolo_signo => "♒",
        elemento => "Aire",
        caracter_signo => "Fijo",
        significado => {
            derecho => "Esperanza, inspiración, sanación, fe.",
            invertido => "Desesperanza, desilusión, pérdida de fe."
        }
    },
    {
        nombre => "La Luna",
        tipo => "Mayor",
        numero => 18,
        letra_hebrea => "Qoph",
        caracter_hebreo => "ק",
        signo_astrologico => "Piscis",
        simbolo_signo => "♓",
        elemento => "Agua",
        caracter_signo => "Mutable",
        significado => {
            derecho => "Ilusión, intuición, miedo, subconsciente.",
            invertido => "Confusión, engaño, miedos ocultos."
        }
    },
    {
        nombre => "El Sol",
        tipo => "Mayor",
        numero => 19,
        letra_hebrea => "Resh",
        caracter_hebreo => "ר",
        signo_astrologico => "Sol",
        simbolo_signo => "☉",
        elemento => "Fuego",
        caracter_signo => "Fijo",
        significado => {
            derecho => "Alegría, éxito, vitalidad, claridad.",
            invertido => "Depresión, falta de energía, oscuridad."
        }
    },
    {
        nombre => "El Juicio",
        tipo => "Mayor",
        numero => 20,
        letra_hebrea => "Shin",
        caracter_hebreo => "ש",
        signo_astrologico => "Escorpio",
        simbolo_signo => "♏",
        elemento => "Agua",
        caracter_signo => "Fijo",
        significado => {
            derecho => "Renacimiento, llamado, redención, despertar.",
            invertido => "Autoengaño, miedo al juicio, culpa."
        }
    },
    {
        nombre => "El Mundo",
        tipo => "Mayor",
        numero => 21,
        letra_hebrea => "Tau",
        caracter_hebreo => "ת",
        signo_astrologico => "Saturno",
        simbolo_signo => "♄",
        elemento => "Tierra",
        caracter_signo => "Cardinal",
        significado => {
            derecho => "Logro, cumplimiento, viaje, integración.",
            invertido => "Incompletitud, retraso, falta de cierre."
        }
    },
);

# -----------------------------
# FUNCIONES AUXILIARES PARA CARTAS MENORES
# -----------------------------

sub crear_cartas_menores {
    my ($palo, $elemento, $significados_derecho, $significados_invertido) = @_;
    my @cartas;
    my %figuras = (
        11 => "Sota",
        12 => "Caballo",
        13 => "Reina",
        14 => "Rey"
    );

    for my $num (1..14) {
        my $nombre_num = $num <= 10 ? $num : $figuras{$num};

        push @cartas, {
            nombre => "$nombre_num de $palo",
            tipo => "Menor",
            palo => $palo,
            numero => $nombre_num,
            letra_hebrea => "",
            caracter_hebreo => "",
            signo_astrologico => "",
            simbolo_signo => "",
            elemento => $elemento,
            caracter_signo => "",
            significado => {
                derecho => $significados_derecho->($num),
                invertido => $significados_invertido->($num),
            }
        };
    }
    return @cartas;
}

# -----------------------------
# DATOS DE SIGNIFICADOS PARA CARTAS MENORES
# -----------------------------

# Oros - Tierra
my @oro_derecho = (
    "Nuevos recursos, estabilidad material.",
    "Elección financiera, equilibrio.",
    "Trabajo en equipo, construcción.",
    "Conservación, avaricia.",
    "Pérdida, preocupación material.",
    "Generosidad, equilibrio económico.",
    "Espera, reflexión sobre ganancias.",
    "Trabajo duro, mejora gradual.",
    "Éxito material, satisfacción.",
    "Éxito material, herencia.",
    "Joven ambicioso, oportunidad.",
    "Ambición, progreso.",
    "Mujer práctica, riqueza.",
    "Líder material, estabilidad."
);

my @oro_invertido = (
    "Bloqueo financiero.",
    "Inestabilidad económica.",
    "Proyectos fallidos.",
    "Avaricia, estancamiento.",
    "Recuperación financiera.",
    "Egoísmo, desequilibrio.",
    "Impaciencia, abandono.",
    "Agotamiento laboral.",
    "Insatisfacción pese al éxito.",
    "Exceso material.",
    "Inmadurez financiera.",
    "Ambición desmedida.",
    "Codicia, manipulación.",
    "Tirano económico."
);

# Copas - Agua
my @copas_derecho = (
    "Amor, nuevas emociones.",
    "Relación armoniosa.",
    "Celebración, alegría.",
    "Reflexión emocional.",
    "Pérdida emocional.",
    "Recuerdos felices, nostalgia.",
    "Elecciones emocionales.",
    "Abandono emocional.",
    "Felicidad emocional.",
    "Armonía familiar.",
    "Mensajero emocional, juventud.",
    "Idealismo, romance.",
    "Mujer emocional, intuición.",
    "Líder emocional, compasión."
);

my @copas_invertido = (
    "Bloqueo emocional.",
    "Desarmonía en relación.",
    "Superficialidad.",
    "Aburrimiento emocional.",
    "Sanación emocional.",
    "Idealización.",
    "Ilusión, engaño.",
    "Regreso emocional.",
    "Insatisfacción emocional.",
    "Conflictos familiares.",
    "Inmadurez emocional.",
    "Frustración romántica.",
    "Inestabilidad emocional.",
    "Manipulación emocional."
);

# Espadas - Aire
my @espadas_derecho = (
    "Pensamiento claro, verdad.",
    "Indecisión, evasión.",
    "Pena, tristeza.",
    "Descanso, recuperación.",
    "Conflicto, derrota.",
    "Avance lento, ayuda.",
    "Engaño, evasión.",
    "Oportunidad de escape.",
    "Ansiedad, culpa.",
    "Sufrimiento extremo.",
    "Juventud inquieta, noticias.",
    "Movimiento intelectual.",
    "Mujer intelectual, crítica.",
    "Líder intelectual, autoridad."
);

my @espadas_invertido = (
    "Verdad oculta.",
    "Decisión forzada.",
    "Sanación emocional.",
    "Negligencia.",
    "Recuperación del conflicto.",
    "Autosuficiencia.",
    "Confrontación.",
    "Atrapado sin salida.",
    "Superación del miedo.",
    "Fin del sufrimiento.",
    "Noticias negativas.",
    "Impulsividad mental.",
    "Crueldad intelectual.",
    "Tiranía mental."
);

# Bastos - Fuego
my @bastos_derecho = (
    "Nuevo proyecto, inspiración.",
    "Planificación, decisión.",
    "Progreso, comunicación.",
    "Celebración, estabilidad.",
    "Competencia, conflicto.",
    "Victoria, apoyo.",
    "Desafío, perseverancia.",
    "Acción rápida, movimiento.",
    "Prevención, vigilancia.",
    "Carga, estrés.",
    "Mensajero entusiasta.",
    "Ambición, impulso.",
    "Mujer enérgica, pasión.",
    "Líder carismático, fuerza."
);

my @bastos_invertido = (
    "Retraso en proyecto.",
    "Indecisión, retraso.",
    "Retraso en comunicaciones.",
    "Fiesta forzada.",
    "Resolución de conflictos.",
    "Victorias falsas.",
    "Derrota evitable.",
    "Acción precipitada.",
    "Paranoia, estrés.",
    "Alivio de carga.",
    "Falta de entusiasmo.",
    "Impulsividad.",
    "Agresividad.",
    "Abuso de poder."
);

# -----------------------------
# CREACIÓN DE CARTAS MENORES
# -----------------------------

my @cartas_menores = (
    crear_cartas_menores("Oros", "Tierra",
        sub { my $n = shift; $oro_derecho[$n-1] },
        sub { my $n = shift; $oro_invertido[$n-1] }
    ),
    crear_cartas_menores("Copas", "Agua",
        sub { my $n = shift; $copas_derecho[$n-1] },
        sub { my $n = shift; $copas_invertido[$n-1] }
    ),
    crear_cartas_menores("Espadas", "Aire",
        sub { my $n = shift; $espadas_derecho[$n-1] },
        sub { my $n = shift; $espadas_invertido[$n-1] }
    ),
    crear_cartas_menores("Bastos", "Fuego",
        sub { my $n = shift; $bastos_derecho[$n-1] },
        sub { my $n = shift; $bastos_invertido[$n-1] }
    ),
);

# Añadir cartas menores a la baraja principal
push @cartas, @cartas_menores;

# -----------------------------
# 2. FUNCIONES AUXILIARES
# -----------------------------

sub mostrar_carta {
    my ($carta, $invertida) = @_;
    print "→ " . $carta->{nombre};
    print " (invertida)" if $invertida;
    print "\n";
    print "  Elemento: " . $carta->{elemento} . "\n";
    if ($carta->{tipo} eq "Mayor") {
        print "  Letra hebrea: " . $carta->{letra_hebrea} . " (" . $carta->{caracter_hebreo} . ")\n";
        print "  Signo: " . $carta->{signo_astrologico} . " " . $carta->{simbolo_signo} . "\n";
        print "  Carácter: " . $carta->{caracter_signo} . "\n";
    }
    my $sentido = $invertida ? "invertido" : "derecho";
    print "  Significado: " . $carta->{significado}->{$sentido} . "\n\n";
}

# -----------------------------
# 3. FUNCIONES DE TIRADAS
# -----------------------------

sub tirada_unica {
    my ($cartas_seleccionadas) = @_;
    print "\n=== TIRADA ÚNICA ===\n";
    print "Una carta para iluminar la situación actual.\n\n";
    mostrar_carta($cartas_seleccionadas->[0]{carta}, $cartas_seleccionadas->[0]{invertida});
    print "Esta carta representa el núcleo de tu situación presente.\n";
}

sub ahora_despues {
    my ($cartas_seleccionadas) = @_;
    return unless @$cartas_seleccionadas >= 2;
    print "\n=== AHORA - DESPUÉS ===\n";
    print "Dos cartas: la situación actual y su evolución.\n\n";
    print "1. AHORA:\n";
    mostrar_carta($cartas_seleccionadas->[0]{carta}, $cartas_seleccionadas->[0]{invertida});
    print "2. DESPUÉS:\n";
    mostrar_carta($cartas_seleccionadas->[1]{carta}, $cartas_seleccionadas->[1]{invertida});
    print "La primera carta muestra tu presente. La segunda indica hacia dónde te diriges.\n";
}

sub pasado_presente_futuro {
    my ($cartas_seleccionadas) = @_;
    return unless @$cartas_seleccionadas >= 3;
    print "\n=== PASADO - PRESENTE - FUTURO ===\n";
    print "Tres cartas que revelan la evolución temporal.\n\n";
    print "1. PASADO:\n";
    mostrar_carta($cartas_seleccionadas->[0]{carta}, $cartas_seleccionadas->[0]{invertida});
    print "2. PRESENTE:\n";
    mostrar_carta($cartas_seleccionadas->[1]{carta}, $cartas_seleccionadas->[1]{invertida});
    print "3. FUTURO:\n";
    mostrar_carta($cartas_seleccionadas->[2]{carta}, $cartas_seleccionadas->[2]{invertida});
    print "Esta tirada muestra cómo el pasado influye en el presente y cómo ambos configuran el futuro.\n";
}

sub cruz_celta {
    my ($cartas_seleccionadas) = @_;
    return unless @$cartas_seleccionadas >= 7;
    print "\n=== CRUZ CELTA ===\n";
    print "Siete cartas que exploran profundamente una situación.\n\n";
    my @t = @$cartas_seleccionadas[0..6];
    print "1. SITUACIÓN ACTUAL:\n";
    mostrar_carta($t[0]{carta}, $t[0]{invertida});
    print "2. OBSTÁCULO:\n";
    mostrar_carta($t[1]{carta}, $t[1]{invertida});
    print "3. RAÍZ DEL ASUNTO:\n";
    mostrar_carta($t[2]{carta}, $t[2]{invertida});
    print "4. PASADO RECIENTE:\n";
    mostrar_carta($t[3]{carta}, $t[3]{invertida});
    print "5. POSIBLE FUTURO:\n";
    mostrar_carta($t[4]{carta}, $t[4]{invertida});
    print "6. AUTOCONCIENCIA:\n";
    mostrar_carta($t[5]{carta}, $t[5]{invertida});
    print "7. CONSEJO FINAL:\n";
    mostrar_carta($t[6]{carta}, $t[6]{invertida});
    print "La Cruz Celta ofrece una visión completa: desde el presente hasta el consejo final.\n";
}

sub tirada_astrológica {
    my ($cartas_seleccionadas) = @_;
    return unless @$cartas_seleccionadas >= 12;
    print "\n=== TIRADA ASTROLÓGICA ===\n";
    print "Doce cartas que representan las casas astrológicas.\n\n";
    my @casas = (
        "Identidad, cuerpo", "Recursos, dinero", "Comunicación, hermanos",
        "Hogar, familia", "Creatividad, hijos", "Trabajo, salud",
        "Relaciones, socios", "Sexo, transformación", "Viajes, filosofía",
        "Carrera, estatus", "Amigos, grupos", "Secretos, subconsciente"
    );
    for my $i (0..11) {
        print ($i+1) . ". $casas[$i]:\n";
        mostrar_carta($cartas_seleccionadas->[$i]{carta}, $cartas_seleccionadas->[$i]{invertida});
    }
    print "Esta tirada simula una carta natal con enfoque simbólico. Cada carta ilumina un área de tu vida.\n";
}

sub rueda_de_la_vida {
    my ($cartas_seleccionadas) = @_;
    return unless @$cartas_seleccionadas >= 8;
    print "\n=== RUEDA DE LA VIDA ===\n";
    print "Ocho cartas en círculo que representan ciclos vitales.\n\n";
    my @areas = qw(Inicio Desafío Apoyo Decisión Cambio Resultado Sabiduría Exterior);
    for my $i (0..7) {
        print ($i+1) . ". $areas[$i]:\n";
        mostrar_carta($cartas_seleccionadas->[$i]{carta}, $cartas_seleccionadas->[$i]{invertida});
    }
    print "La Rueda muestra el ciclo completo: desde el inicio hasta la sabiduría adquirida.\n";
}

# -----------------------------
# 4. SELECCIÓN MANUAL DE CARTAS
# -----------------------------

sub seleccionar_cartas_manualmente {
    my @seleccionadas = ();
    print "\n=== SELECCIÓN MANUAL DE CARTAS ===\n";
    print "Introduce el nombre de una carta (o 'fin' para terminar).\n";
    print "Ej: El Mago, 3 de Copas, Reina de Bastos\n\n";

    while (1) {
        print "Nombre de la carta (o 'fin'): ";
        my $entrada = <STDIN>;
        chomp $entrada;
        $entrada = decode('utf8', $entrada);
        last if $entrada =~ /^fin$/i;

        my $carta = buscar_carta_por_nombre($entrada);
        if (!$carta) {
            print "❌ No se encontró la carta '$entrada'. Intenta de nuevo.\n\n";
            next;
        }

        print "¿Posición? (1 = derecha, 2 = invertida): ";
        my $pos = <STDIN>;
        chomp $pos;
        my $invertida = ($pos eq "2") ? 1 : 0;

        push @seleccionadas, { carta => $carta, invertida => $invertida };
        print "✅ Añadida: " . $carta->{nombre} . ($invertida ? " (invertida)" : "") . "\n\n";
    }

    return @seleccionadas;
}

sub buscar_carta_por_nombre {
    my ($nombre) = @_;
    $nombre = lc($nombre);
    for my $c (@cartas) {
        return $c if lc($c->{nombre}) eq $nombre;
    }
    return undef;
}

# -----------------------------
# 5. MENÚ PRINCIPAL
# -----------------------------

sub menu {
    print "="x60 . "\n";
    print "        TAROT DE MARSELLA - INTERPRETACIÓN COMPLETA\n";
    print "          (78 cartas, UTF-8, manual o aleatorio)\n";
    print "="x60 . "\n";
    print "Elige una opción:\n";
    print "1. Tirada Única (aleatoria)\n";
    print "2. Ahora - Después (aleatoria)\n";
    print "3. Pasado - Presente - Futuro (aleatoria)\n";
    print "4. Cruz Celta (aleatoria)\n";
    print "5. Tirada Astrológica (aleatoria)\n";
    print "6. Rueda de la Vida (aleatoria)\n";
    print "7. Seleccionar cartas manualmente y elegir tirada\n";
    print "8. Salir\n";
    print "Opción: ";
}

# -----------------------------
# 6. BUCLE PRINCIPAL
# -----------------------------

while (1) {
    menu();
    my $opcion = <STDIN>;
    chomp $opcion;
    $opcion = decode('utf8', $opcion);

    my @cartas_usar;

    if ($opcion eq "7") {
        @cartas_usar = seleccionar_cartas_manualmente();
        if (@cartas_usar == 0) {
            print "No se seleccionaron cartas. Volviendo al menú...\n";
            <STDIN>;
            next;
        }

        print "\nCartas seleccionadas: " . scalar(@cartas_usar) . "\n";
        print "Elige una tirada para usar tus cartas:\n";
        print "1. Única (1 carta)\n";
        print "2. Ahora-Después (2 cartas)\n";
        print "3. Pasado-Presente-Futuro (3 cartas)\n";
        print "4. Cruz Celta (7 cartas)\n";
        print "5. Astrológica (12 cartas)\n";
        print "6. Rueda de la Vida (8 cartas)\n";
        print "Opción: ";
        my $tirada = <STDIN>;
        chomp $tirada;

        if    ($tirada eq "1" && @cartas_usar >= 1) { tirada_unica(\@cartas_usar); }
        elsif ($tirada eq "2" && @cartas_usar >= 2) { ahora_despues(\@cartas_usar); }
        elsif ($tirada eq "3" && @cartas_usar >= 3) { pasado_presente_futuro(\@cartas_usar); }
        elsif ($tirada eq "4" && @cartas_usar >= 7) { cruz_celta(\@cartas_usar); }
        elsif ($tirada eq "5" && @cartas_usar >=12) { tirada_astrológica(\@cartas_usar); }
        elsif ($tirada eq "6" && @cartas_usar >= 8) { rueda_de_la_vida(\@cartas_usar); }
        else { print "❌ No hay suficientes cartas para esta tirada.\n"; }
    }
    elsif ($opcion eq "1") {
        @cartas_usar = map { { carta => $_, invertida => int(rand(2)) } } (shuffle(@cartas))[0..0];
        tirada_unica(\@cartas_usar);
    }
    elsif ($opcion eq "2") {
        @cartas_usar = map { { carta => $_, invertida => int(rand(2)) } } (shuffle(@cartas))[0..1];
        ahora_despues(\@cartas_usar);
    }
    elsif ($opcion eq "3") {
        @cartas_usar = map { { carta => $_, invertida => int(rand(2)) } } (shuffle(@cartas))[0..2];
        pasado_presente_futuro(\@cartas_usar);
    }
    elsif ($opcion eq "4") {
        @cartas_usar = map { { carta => $_, invertida => int(rand(2)) } } (shuffle(@cartas))[0..6];
        cruz_celta(\@cartas_usar);
    }
    elsif ($opcion eq "5") {
        @cartas_usar = map { { carta => $_, invertida => int(rand(2)) } } (shuffle(@cartas))[0..11];
        tirada_astrológica(\@cartas_usar);
    }
    elsif ($opcion eq "6") {
        @cartas_usar = map { { carta => $_, invertida => int(rand(2)) } } (shuffle(@cartas))[0..7];
        rueda_de_la_vida(\@cartas_usar);
    }
    elsif ($opcion eq "8") {
        print "Que el camino te acompañe. ✡️ ☯️ ☀️\n";
        last;
    }
    else {
        print "Opción no válida.\n";
    }

    print "\n" . "-"x50 . "\n";
    print "Pulsa ENTER para continuar...";
    <STDIN>;
}
