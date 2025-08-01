#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Term::ANSIColor;
use Time::HiRes qw(usleep);

# Asegurar salida UTF-8
binmode(STDOUT, ':utf8');

# Verificar argumentos
my $modo_oraculo = 0;
if (@ARGV) {
    my $arg = lc($ARGV[0]);
    if ($arg eq '--oraculo' || $arg eq '-o') {
        $modo_oraculo = 1;
    }
}

# Estado del alquimista
my $pureza      = 30;
my $espiritu    = 20;
my $corrupcion  = 0;
my $fase        = 0;
my $piedra      = 0;

# Función de escritura lenta
sub type {
    my ($text, $delay) = @_;
    $delay ||= 25000;
    for my $char (split //, $text) {
        print $char;
        usleep($delay);
        STDOUT->flush();
    }
}

# Limpiar pantalla
sub clear { print "\033[2J\033[H" }

# Mostrar estado
sub estado {
    print color("bold white"), "="x50, "\n", color("reset");
    printf color("cyan")."Pureza: %3d | ", $pureza;
    printf color("yellow")."Espíritu: %3d | ", $espiritu;
    printf color("red")."Corrupción: %3d\n", $corrupcion;
    print color("green")."Fase: ";
    my @fases = ('Nigredo', 'Albedo', 'Citrinitas', 'Rubedo');
    print $fases[$fase];
    print color("reset"), "\n";
    print color("bold white"), "="x50, "\n", color("reset");
}

# Elección aleatoria de acción (modo oráculo)
sub accion_aleatoria {
    my @validas = qw(calentar destilar invocar meditar leer\ libro);
    if ($fase >= 1) { push @validas, 'mezclar'; }
    return $validas[int(rand(@validas))];
}

# Profecías del oráculo
my @profecias = (
    "El cuervo negro anuncia transformación. No temas la oscuridad.",
    "La sal se endurece: tu cuerpo resistirá. Pero tu alma está débil.",
    "El azufre arde: pasión desmedida. Cuidado con el fuego interior.",
    "El mercurio huye: algo se te escapa. Presta atención al silencio.",
    "Veo un círculo roto... alguien rompió el sello. Desconfía.",
    "Una luz dorada sobre montañas lejanas. El camino aún no termina.",
    "Tres llaves, una puerta. Pero la cerradura está en tu mente.",
    "No hay oro sin sombra. Acepta tu corrupción como parte del todo.",
    "El fuego consume al que no purifica su intención.",
    "Tu reflejo en el vaso ya no parpadea. ¿Eres tú?"
);

# 📜 Comando AYUDA - El Grimorio Revela un Secreto
sub mostrar_ayuda {
    clear();
    type(color("magenta")."📜 EL GRIMORIO SE ABRE... UN SECRETO OLVIDADO EMERGE 📜\n\n", 50000);
    type(color("yellow")."Oíd, oh buscador de la Piedra Oculta,\n", 40000);
    type("vos que agitáis el Vaso Hermético en la noche sin luna.\n", 40000);
    type("La Obra Mayor no es del cuerpo, sino del espíritu rectificado.\n\n", 40000);

    type(color("white")."Escuchad las Cuatro Etapas del Camino:\n", 40000);
    type("  1. NIGREDO: La materia muere. Calienta hasta que la corrupción hable.\n", 40000);
    type("  2. ALBEDO: Lava el alma. Destila hasta que brille como el alba.\n", 40000);
    type("  3. CITRINITAS: Fija el cuerpo. Mezcla SAL para iluminar el templo.\n", 40000);
    type("  4. RUBEDO: Une los opuestos. Mezcla MERCURIO y nacerá el Uno.\n\n", 40000);

    type(color("red")."¡Advertencia! Si mezcláis MERCURIO antes del tiempo,\n", 40000);
    type("la sombra os devorará y el homúnculo reirá con vuestra voz.\n\n", 40000);

    type(color("cyan")."Secuencia del Iniciado:\n", 40000);
    type("  calentar, calentar → abre la puerta de la muerte.\n", 40000);
    type("  meditar, leer libro → fortalece el espíritu.\n", 40000);
    type("  destilar, destilar → purifica el alma.\n", 40000);
    type("  invocar → eleva la luz.\n", 40000);
    type("  mezclar sal → sella el templo.\n", 40000);
    type("  mezclar mercurio → completa la Obra.\n\n", 40000);

    type(color("green")."Recuerda la Palabra Sagrada:\n", 40000);
    type(color("bright_yellow")."\"Visita interiora terrae, rectificando invenies occultum lapidem.\"\n\n", 50000);
    type(color("white")."Que la llama filosofal guíe tus pasos, oh alquimista.\n", 40000);
    type("Pero cuidado... no todo conocimiento es para los vivos.\n", 40000);
    type("El libro se cierra...\n", 60000);
    print color("reset");
    usleep(1_000_000);
    clear();
}

# Inicio del juego
clear();

if ($modo_oraculo) {
    type(color("magenta")."🌌 EL ORÁCULO DEL LABORATORIO HA SIDO INVOCADO 🌌\n\n", 50000);
    type(color("white")."Los espíritus del fuego y la sal han tomado el control.\n", 40000);
    type("Tu voluntad ya no importa. Solo el Destino Alquímico.\n\n", 40000);
    print color("reset");
    usleep(1_000_000);
}
else {
    type(color("yellow")."🔥 EL OUROBOROS DE PARACELSO 🔥\n\n", 50000);
    type(color("white")."Eres el último alquimista de Augsburgo.\n", 40000);
    type("Tu laboratorio huele a azufre, sal y recuerdos olvidados.\n", 40000);
    type("Ante ti, el Vaso Hermético contiene la Materia Prima:\n", 40000);
    type(color("bold red")."Una sustancia negra, palpitante, que susurra en latín.\n\n", 60000);
    type("Tu misión: completar la Magnum Opus y crear la Piedra Filosofal.\n", 40000);
    type("Pero cuidado: la corrupción acecha al que desea demasiado.\n\n", 40000);
    print color("reset");
}

# Bucle principal
while ($fase < 4 && $corrupcion < 100 && $pureza > 0) {
    estado() unless $modo_oraculo;

    my $input;
    if ($modo_oraculo) {
        usleep(1_200_000);
        $input = accion_aleatoria();
        type(color("magenta")."[ORÁCULO] > $input\n", 40000);
    }
    else {
        print "\n¿Qué deseas hacer?\n";
        print color("bold green")."  [calentar]  [destilar]  [mezclar]  [invocar]  [meditar]  [leer libro]\n";
        print color("blue")."  [ayuda]  [ayuda secreta]\n";
        print color("red")."  [rendirse]\n";
        print color("reset")."> ";
        chomp($input = <STDIN>);
        $input = lc($input);
    }

    # Procesar comandos
    if ($input eq 'ayuda' || $input eq 'ayuda secreta') {
        mostrar_ayuda();
        next;
    }
    elsif ($input eq 'calentar') {
        type("El fuego lento lame el Vaso...\n");
        usleep(500000);
        if ($fase == 0) {
            type(color("red")."La materia se retuerce. Grita en latín antiguo.\n", 40000);
            $pureza -= 5;
            $corrupcion += 10;
            $fase = 1 if $corrupcion >= 20;
        } else {
            type("El fuego purifica... o corrompe.\n");
            $pureza += 5;
            $espiritu += 10;
        }
    }
    elsif ($input eq 'destilar') {
        type("Condensas los vapores...\n");
        usleep(500000);
        if ($fase == 1) {
            type(color("white")."Una esencia clara cae como lágrima de ángel.\n", 40000);
            $pureza += 15;
            $espiritu += 5;
            $fase = 2 if $pureza >= 50;
        } else {
            type("Destilas demasiado... pierdes espíritu.\n");
            $espiritu -= 10;
        }
    }
    elsif ($input eq 'mezclar') {
        my @elementos = qw(azufre sal mercurio);
        my $elegido = $elementos[int(rand(3))];
        type("Mezclas $elegido en el Vaso...\n");
        usleep(500000);
        if ($elegido eq 'azufre' && $fase >= 1) {
            type(color("yellow")."¡Fuego interno! El alma se fortalece.\n");
            $espiritu += 20;
        }
        elsif ($elegido eq 'sal' && $fase >= 2) {
            type(color("white")."La estabilidad del cuerpo. La materia se ordena.\n");
            $pureza += 10;
            $fase = 3;
        }
        elsif ($elegido eq 'mercurio' && $fase == 3) {
            type(color("bold blue")."¡El Mercurio Filosófico! Todo se une...\n");
            usleep(1000000);
            $piedra = 1;
        }
        else {
            type("La mezcla falla... una explosión sutil envenena tu alma.\n");
            $corrupcion += 25;
        }
    }
    elsif ($input eq 'invocar') {
        type("Pronuncias: ");
        type(color("magenta")."'Per arcanum aeternitatis...'\n", 30000);
        usleep(500000);
        if ($espiritu >= 50) {
            type("Una luz dorada llena el laboratorio.\n");
            $pureza += 10;
            $fase++ if $fase < 3;
        } else {
            type("Solo el eco responde. Algo te observa desde el vaso.\n");
            $corrupcion += 15;
        }
    }
    elsif ($input eq 'meditar') {
        type("Cierras los ojos. El tiempo se detiene.\n");
        usleep(800000);
        $espiritu += 15;
        $pureza += 5;
        $corrupcion -= 5 if $corrupcion > 0;
    }
    elsif ($input eq 'leer libro') {
        type(color("yellow")."...Visita interiora terrae, rectificando invenies occultum lapidem...\n", 40000);
        type(color("white")."El texto se mueve. Las letras forman ojos.\n", 40000);
        $espiritu += 5;
        if ($fase == 3) {
            type("Una voz susurra: 'El azufre une, la sal fija, el mercurio vive.'\n");
        }
    }
    elsif ($input eq 'rendirse' && !$modo_oraculo) {
        type("Dejas caer la varilla de hierro. El fuego se apaga.\n");
        type("La materia se enfría... y se ríe.\n");
        exit;
    }
    else {
        type("El laboratorio no reconoce ese acto.\n");
        usleep(300000);
    }

    print "\n";
    usleep(500000);
}

# FINALES
clear();

if ($piedra) {
    if ($modo_oraculo) {
        type(color("bold bright_yellow"));
        type("✨ EL ORÁCULO HA CREADO LA PIEDRA FILOSOFAL ✨\n\n", 40000);
        type("La voluntad humana fue solo un instrumento.\n", 40000);
        type("El destino alquímico se ha cumplido sin tu consentimiento.\n", 40000);
    } else {
        type(color("bold bright_yellow"));
        type("🏆 LA PIEDRA FILOSOFAL HA SIDO CREADA 🏆\n\n", 40000);
        type("La luz dorada llena el mundo. Tu cuerpo se transforma.\n", 40000);
        type("Ya no eres hombre. Eres el Uno que lo contiene todo.\n", 40000);
    }
    type("Paracelso sonríe desde las sombras.\n", 40000);
    type("FIN: EL ALQUIMISTA DIVINO\n");
}
elsif ($corrupcion >= 100) {
    type(color("bold red"));
    type("💀 EL HOMÚNCULO HA NACIDO... Y NO ES TUYO 💀\n\n", 40000);
    type("La materia se retuerce. De tu boca salen palabras que no entiendes.\n", 40000);
    type("El laboratorio ya no es tuyo. Algo más viejo lo habita.\n", 40000);
    type("FIN: LA CORRUPCIÓN DEL SABIO\n");
}
elsif ($pureza <= 0) {
    type(color("bold black"));
    type("🌑 TU ALMA SE HA DISUELTO EN LA OBRA 🌑\n\n", 40000);
    type("Te conviertes en sombra. En recuerdo. En error olvidado.\n", 40000);
    type("FIN: EL ALQUIMISTA PERDIDO\n");
}
else {
    type("El tiempo se detiene. El juego termina.\n");
}

# Profecía final en modo oráculo
if ($modo_oraculo) {
    usleep(1_000_000);
    type("\n");
    type(color("blue")."📜 PROFECÍA DEL LABORATORIO 📜\n\n", 50000);
    type(color("white"));
    type($profecias[int(rand(@profecias))] . "\n", 40000);
    type("Que así sea escrito en el Libro de las Sombras.\n", 40000);
}

print color("reset");
