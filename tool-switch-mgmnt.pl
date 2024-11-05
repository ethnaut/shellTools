#!/usr/bin/perl
use strict;
use warnings;
use POSIX qw(strftime);

# Muestra el mensaje de ayuda
sub show_help {
    print <<"END_HELP";
Uso: perl $0 <modo> [comando] [opciones]

Modo:
    show      - Muestra información del switch
    config    - Configura el switch
    reboot    - Reinicia el switch
    backup    - Realiza un backup de la configuración actual

Comando:
    interfaz   - Información o configuración de interfaces
    vlan        - Información o configuración de VLANs
    version     - Muestra la versión del sistema operativo
    config      - Realiza un backup de la configuración actual

Opciones:
    -h <host>      - Host del switch
    -u <usuario>   - Usuario para autenticación
    -p <password>  - Contraseña para autenticación
    -c <comando>   - Comando específico a ejecutar (para `config`)
    -o <archivo>   - Archivo para guardar el backup (para `backup`, se puede usar `%DATE%` para fecha y hora)

Ejemplo:
    perl $0 show version -h switch.example.com -u usuario -p password
    perl $0 config interfaz -h switch.example.com -u usuario -p password -c "interface GigabitEthernet1/0/1"
    perl $0 reboot -h switch.example.com -u usuario -p password
    perl $0 backup -h switch.example.com -u usuario -p password -o backup_%DATE%.txt
END_HELP
    exit;
}

# Verifica los argumentos
@ARGV >= 2 || !-t and show_help();
my ($mode, $command) = @ARGV;

# Procesa opciones adicionales
my ($host, $user, $password, $config_command, $output_file);
while (@ARGV) {
    my $arg = shift @ARGV;
    if ($arg eq '-h') { $host = shift @ARGV; }
    elsif ($arg eq '-u') { $user = shift @ARGV; }
    elsif ($arg eq '-p') { $password = shift @ARGV; }
    elsif ($arg eq '-c') { $config_command = shift @ARGV; }
    elsif ($arg eq '-o') { $output_file = shift @ARGV; }
}

# Verifica los parámetros
defined $host && defined $user && defined $password or show_help();

# Genera el nombre de archivo con la fecha y hora en formato ICAO
sub generate_backup_filename {
    my $date = strftime "%Y%m%d_%H%M", localtime;
    my $filename = $output_file || "backup_$date.txt";
    $filename =~ s/%DATE%/$date/;  # Sustituye %DATE% con la fecha actual
    return $filename;
}

# Si se especifica archivo de salida
if ($output_file) {
    $output_file = generate_backup_filename();
    open my $out_fh, '>', $output_file or die "No se puede abrir $output_file: $!";
    select $out_fh;  # Cambia la salida estándar al archivo
}

# Función para ejecutar comandos en el switch usando ssh
sub execute_ssh_command {
    my ($cmd) = @_;
    my $ssh_command = <<"END_SSH";
sshpass -p '$password' ssh -o StrictHostKeyChecking=no $user\@$host "$cmd"
END_SSH
    system($ssh_command) == 0 or die "No se pudo ejecutar el comando '$cmd' en el switch.";
}

# Función para mostrar la versión del sistema operativo
sub show_version {
    execute_ssh_command('show version');
}

# Función para mostrar información de interfaces
sub show_interfaces {
    execute_ssh_command('show interfaces');
}

# Función para mostrar información de VLANs
sub show_vlans {
    execute_ssh_command('show vlan brief');
}

# Función para configurar una interfaz
sub config_interface {
    defined $config_command or show_help();
    execute_ssh_command("configure terminal; $config_command; end; write memory");
}

# Función para configurar una VLAN
sub config_vlan {
    defined $config_command or show_help();
    execute_ssh_command("configure terminal; $config_command; end; write memory");
}

# Función para reiniciar el switch
sub reboot_switch {
    execute_ssh_command('reload');
}

# Función para realizar un backup de la configuración actual
sub backup_config {
    my $backup_command = 'show running-config';
    my $config = `sshpass -p '$password' ssh -o StrictHostKeyChecking=no $user\@$host "$backup_command"`;
    if (defined $output_file) {
        open my $fh, '>', $output_file or die "No se puede abrir $output_file: $!";
        print $fh $config;
        close $fh;
    } else {
        print $config;
    }
}

# Mapeo de modos y comandos
my %commands = (
    'show' => {
        'version' => \&show_version,
        'interfaces' => \&show_interfaces,
        'vlan' => \&show_vlans
    },
    'config' => {
        'interfaz' => \&config_interface,
        'vlan' => \&config_vlan
    },
    'reboot' => \&reboot_switch,
    'backup' => \&backup_config
);

# Verifica si el comando es válido para el modo especificado
if ($mode eq 'show') {
    exists $commands{$mode}{$command} or show_help();
    $commands{$mode}{$command}->();
} elsif ($mode eq 'config') {
    exists $commands{$mode}{$command} or show_help();
    $commands{$mode}{$command}->();
} elsif ($mode eq 'reboot') {
    $commands{$mode}->();
} elsif ($mode eq 'backup') {
    $commands{$mode}->();
} else {
    show_help();
}

