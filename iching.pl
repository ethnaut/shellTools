#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use List::Util qw(shuffle);

# Configuración de caracteres UTF-8 para los hexagramas
binmode(STDOUT, ':utf8');

# Tabla completa de los 64 hexagramas
my @hexagramas = (
    {   num => 1, nombre => "El Creador", chino => "䷀", 
        hexagrama => "111111", descripcion => "Lo Creativo, el cielo" },
    {   num => 2, nombre => "Lo Receptivo", chino => "䷁", 
        hexagrama => "000000", descripcion => "La tierra, lo receptivo" },
    {   num => 3, nombre => "La Dificultad Inicial", chino => "䷂", 
        hexagrama => "100010", descripcion => "Dificultad al principio" },
    {   num => 4, nombre => "La Necedad Juvenil", chino => "䷃", 
        hexagrama => "010001", descripcion => "Inexperiencia, juventud" },
    {   num => 5, nombre => "La Espera", chino => "䷄", 
        hexagrama => "111010", descripcion => "Esperar, nutrirse" },
    {   num => 6, nombre => "El Conflicto", chino => "䷅", 
        hexagrama => "010111", descripcion => "Conflicto, disputa" },
    {   num => 7, nombre => "El Ejército", chino => "䷆", 
        hexagrama => "000010", descripcion => "El ejército, liderazgo" },
    {   num => 8, nombre => "La Unión", chino => "䷇", 
        hexagrama => "010000", descripcion => "Unión, solidaridad" },
    {   num => 9, nombre => "El Poder Domesticador", chino => "䷈", 
        hexagrama => "111011", descripcion => "Pequeña reserva" },
    {   num => 10, nombre => "La Conducta", chino => "䷉", 
        hexagrama => "110111", descripcion => "Avanzar, pisar" },
    {   num => 11, nombre => "La Paz", chino => "䷊", 
        hexagrama => "000111", descripcion => "Paz, armonía" },
    {   num => 12, nombre => "El Estancamiento", chino => "䷋", 
        hexagrama => "111000", descripcion => "Bloqueo, estancamiento" },
    {   num => 13, nombre => "La Comunidad", chino => "䷌", 
        hexagrama => "111101", descripcion => "Comunión con otros" },
    {   num => 14, nombre => "La Posesión", chino => "䷍", 
        hexagrama => "101111", descripcion => "Gran posesión" },
    {   num => 15, nombre => "La Modestia", chino => "䷎", 
        hexagrama => "001000", descripcion => "Humildad, modestia" },
    {   num => 16, nombre => "El Entusiasmo", chino => "䷏", 
        hexagrama => "000100", descripcion => "Entusiasmo" },
    {   num => 17, nombre => "El Seguimiento", chino => "䷐", 
        hexagrama => "100110", descripcion => "Seguir, adaptarse" },
    {   num => 18, nombre => "El Trabajo en lo Echado", chino => "䷑", 
        hexagrama => "011001", descripcion => "Corrección" },
    {   num => 19, nombre => "El Acercamiento", chino => "䷒", 
        hexagrama => "000011", descripcion => "Acercarse" },
    {   num => 20, nombre => "La Contemplación", chino => "䷓", 
        hexagrama => "110000", descripcion => "Contemplación" },
    {   num => 21, nombre => "La Mordedura", chino => "䷔", 
        hexagrama => "100101", descripcion => "Morder y romper" },
    {   num => 22, nombre => "La Gracia", chino => "䷕", 
        hexagrama => "101001", descripcion => "Elegancia, gracia" },
    {   num => 23, nombre => "El Desmembramiento", chino => "䷖", 
        hexagrama => "000001", descripcion => "Desintegración" },
    {   num => 24, nombre => "El Retorno", chino => "䷗", 
        hexagrama => "100000", descripcion => "El retorno" },
    {   num => 25, nombre => "La Inocencia", chino => "䷘", 
        hexagrama => "111001", descripcion => "Sin enredo" },
    {   num => 26, nombre => "El Poder Domesticador", chino => "䷙", 
        hexagrama => "100111", descripcion => "Gran reserva" },
    {   num => 27, nombre => "La Alimentación", chino => "䷚", 
        hexagrama => "100001", descripcion => "Nutrición, mandíbulas" },
    {   num => 28, nombre => "La Preponderancia", chino => "䷛", 
        hexagrama => "011110", descripcion => "Gran exceso" },
    {   num => 29, nombre => "El Abismo", chino => "䷜", 
        hexagrama => "010010", descripcion => "Lo abismal, agua" },
    {   num => 30, nombre => "El Fuego", chino => "䷝", 
        hexagrama => "101101", descripcion => "Lo adherente, fuego" },
    {   num => 31, nombre => "La Influencia", chino => "䷞", 
        hexagrama => "001110", descripcion => "Estímulo, cortejo" },
    {   num => 32, nombre => "La Duración", chino => "䷟", 
        hexagrama => "011100", descripcion => "Perseverancia" },
    {   num => 33, nombre => "El Retiro", chino => "䷠", 
        hexagrama => "001111", descripcion => "Retirada" },
    {   num => 34, nombre => "El Gran Poder", chino => "䷡", 
        hexagrama => "111100", descripcion => "Gran fortaleza" },
    {   num => 35, nombre => "El Progreso", chino => "䷢", 
        hexagrama => "101000", descripcion => "Avance" },
    {   num => 36, nombre => "El Oscurecimiento", chino => "䷣", 
        hexagrama => "000101", descripcion => "Herida de la luz" },
    {   num => 37, nombre => "La Familia", chino => "䷤", 
        hexagrama => "101011", descripcion => "El clan familiar" },
    {   num => 38, nombre => "La Oposición", chino => "䷥", 
        hexagrama => "110101", descripcion => "Contrariedad" },
    {   num => 39, nombre => "El Obstáculo", chino => "䷦", 
        hexagrama => "001010", descripcion => "Dificultad" },
    {   num => 40, nombre => "La Liberación", chino => "䷧", 
        hexagrama => "010100", descripcion => "Alivio, liberación" },
    {   num => 41, nombre => "La Disminución", chino => "䷨", 
        hexagrama => "100011", descripcion => "Pérdida, disminución" },
    {   num => 42, nombre => "El Aumento", chino => "䷩", 
        hexagrama => "110001", descripcion => "Ganancia, aumento" },
    {   num => 43, nombre => "La Decisión", chino => "䷪", 
        hexagrama => "011111", descripcion => "Irrupción" },
    {   num => 44, nombre => "El Acoplamiento", chino => "䷫", 
        hexagrama => "111110", descripcion => "Encuentro" },
    {   num => 45, nombre => "La Reunión", chino => "䷬", 
        hexagrama => "011000", descripcion => "Agrupación" },
    {   num => 46, nombre => "La Ascensión", chino => "䷭", 
        hexagrama => "000110", descripcion => "Empuje hacia arriba" },
    {   num => 47, nombre => "La Opresión", chino => "䷮", 
        hexagrama => "010110", descripcion => "Agotamiento" },
    {   num => 48, nombre => "El Pozo", chino => "䷯", 
        hexagrama => "011010", descripcion => "El pozo" },
    {   num => 49, nombre => "La Revolución", chino => "䷰", 
        hexagrama => "011101", descripcion => "Muda, cambio" },
    {   num => 50, nombre => "El Caldero", chino => "䷱", 
        hexagrama => "101110", descripcion => "El recipiente" },
    {   num => 51, nombre => "El Trueno", chino => "䷲", 
        hexagrama => "100100", descripcion => "Lo conmovedor" },
    {   num => 52, nombre => "La Montaña", chino => "䷳", 
        hexagrama => "001001", descripcion => "El aquietamiento" },
    {   num => 53, nombre => "El Desarrollo", chino => "䷴", 
        hexagrama => "110100", descripcion => "Progreso gradual" },
    {   num => 54, nombre => "La Doncella", chino => "䷵", 
        hexagrama => "001011", descripcion => "La doncella casadera" },
    {   num => 55, nombre => "La Abundancia", chino => "䷶", 
        hexagrama => "101100", descripcion => "Plenitud" },
    {   num => 56, nombre => "El Viajero", chino => "䷷", 
        hexagrama => "001101", descripcion => "El errante" },
    {   num => 57, nombre => "El Viento", chino => "䷸", 
        hexagrama => "110110", descripcion => "Lo suave, viento" },
    {   num => 58, nombre => "La Alegría", chino => "䷹", 
        hexagrama => "110011", descripcion => "Lo sereno, lago" },
    {   num => 59, nombre => "La Dispersión", chino => "䷺", 
        hexagrama => "110010", descripcion => "Disolución" },
    {   num => 60, nombre => "La Regulación", chino => "䷻", 
        hexagrama => "010011", descripcion => "Limitación" },
    {   num => 61, nombre => "La Verdad Interior", chino => "䷼", 
        hexagrama => "110011", descripcion => "Verdad interna" },
    {   num => 62, nombre => "La Preponderancia", chino => "䷽", 
        hexagrama => "001100", descripcion => "Pequeño exceso" },
    {   num => 63, nombre => "Después de la Culminación", chino => "䷾", 
        hexagrama => "101010", descripcion => "Ya cumplido" },
    {   num => 64, nombre => "Antes de la Culminación", chino => "䷿", 
        hexagrama => "010101", descripcion => "Aún no cumplido" }
);

# Función para mostrar un hexagrama
sub mostrar_hexagrama {
    my ($h) = @_;
    printf "Número: %d\n", $h->{num};
    printf "Nombre: %s\n", $h->{nombre};
    printf "Grafía China: %s\n", $h->{chino};
    printf "Hexagrama: %s\n", $h->{hexagrama};
    printf "Descripción: %s\n", $h->{descripcion};
    print "--------------------\n";
}

# Función para mostrar todos los hexagramas
sub mostrar_todos {
    print "=== TODOS LOS HEXAGRAMAS DEL I CHING ===\n\n";
    foreach my $h (@hexagramas) {
        mostrar_hexagrama($h);
    }
}

# Función para buscar por número
sub buscar_por_numero {
    my $num = shift;
    foreach my $h (@hexagramas) {
        if ($h->{num} == $num) {
            return $h;
        }
    }
    return undef;
}

# Función para buscar por nombre
sub buscar_por_nombre {
    my $nombre = lc shift;
    foreach my $h (@hexagramas) {
        if (lc($h->{nombre}) =~ /$nombre/) {
            return $h;
        }
    }
    return undef;
}

# Función para generar un hexagrama aleatorio (consulta)
sub consulta_iching {
    print "\n=== CONSULTA AL I CHING ===\n\n";
    
    # Generar 6 líneas aleatorias (0 para yin, 1 para yang)
    my @lineas;
    for (1..6) {
        push @lineas, int(rand(2));
    }
    my $hexagrama_generado = join('', @lineas);
    
    # Buscar el hexagrama correspondiente
    my $encontrado;
    foreach my $h (@hexagramas) {
        if ($h->{hexagrama} eq $hexagrama_generado) {
            $encontrado = $h;
            last;
        }
    }
    
    if ($encontrado) {
        print "Líneas obtenidas (1=Yang, 0=Yin): @lineas\n";
        print "Hexagrama generado: $hexagrama_generado\n\n";
        print "=== RESPUESTA DEL I CHING ===\n";
        mostrar_hexagrama($encontrado);
        
        # Generar también hexagrama complementario (cambiar todas las líneas)
        my @complementarias = map { $_ ? 0 : 1 } @lineas;
        my $hex_complementario = join('', @complementarias);
        
        foreach my $h (@hexagramas) {
            if ($h->{hexagrama} eq $hex_complementario) {
                print "\nHexagrama complementario (yin/yang invertido):\n";
                mostrar_hexagrama($h);
                last;
            }
        }
    } else {
        print "Error: No se encontró el hexagrama generado\n";
    }
}

# Menú principal
sub mostrar_menu {
    print "\n=== I CHING - EL LIBRO DE LAS MUTACIONES ===\n";
    print "1. Mostrar todos los hexagramas\n";
    print "2. Buscar hexagrama por número\n";
    print "3. Buscar hexagrama por nombre\n";
    print "4. Hacer una consulta al I Ching\n";
    print "5. Hexagrama aleatorio\n";
    print "6. Salir\n";
    print "Elige una opción: ";
}

# Función para mostrar hexagrama aleatorio
sub hexagrama_aleatorio {
    my @shuffled = shuffle @hexagramas;
    print "\n=== HEXAGRAMA ALEATORIO ===\n";
    mostrar_hexagrama($shuffled[0]);
}

# Programa principal
while (1) {
    mostrar_menu();
    my $opcion = <STDIN>;
    chomp $opcion;
    
    if ($opcion == 1) {
        mostrar_todos();
    }
    elsif ($opcion == 2) {
        print "Introduce el número del hexagrama (1-64): ";
        my $num = <STDIN>;
        chomp $num;
        my $h = buscar_por_numero($num);
        if ($h) {
            mostrar_hexagrama($h);
        } else {
            print "No se encontró el hexagrama número $num\n";
        }
    }
    elsif ($opcion == 3) {
        print "Introduce parte del nombre: ";
        my $nombre = <STDIN>;
        chomp $nombre;
        my $h = buscar_por_nombre($nombre);
        if ($h) {
            mostrar_hexagrama($h);
        } else {
            print "No se encontró ningún hexagrama con '$nombre'\n";
        }
    }
    elsif ($opcion == 4) {
        consulta_iching();
    }
    elsif ($opcion == 5) {
        hexagrama_aleatorio();
    }
    elsif ($opcion == 6) {
        print "¡Hasta pronto!\n";
        last;
    }
    else {
        print "Opción no válida. Intenta de nuevo.\n";
    }
    
    print "\nPresiona Enter para continuar...";
    <STDIN>;
}
