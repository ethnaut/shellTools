#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket::INET;

# Mostrar mensaje de ayuda si no se proporcionan parámetros
if (@ARGV == 0 && -t STDIN) {
    die <<"END_USAGE";
Uso: perl netcat_emulado.pl [tx|rx] [opciones]
Opciones:
  tx <host> <puerto>  - Enviar datos a <host>:<puerto>
  rx <puerto>         - Escuchar en <puerto> y recibir datos

Ejemplos:
  Enviar datos usando tuberías:
    echo "Mensaje de prueba" | perl netcat_emulado.pl tx 127.0.0.1 12345

  Enviar datos de forma interactiva (escribe el mensaje y presiona Ctrl+D para enviar):
    perl netcat_emulado.pl tx 127.0.0.1 12345

  Recibir datos (escuchar en el puerto 12345):
    perl netcat_emulado.pl rx 12345

  Recibir datos y redirigir la salida a un archivo:
    perl netcat_emulado.pl rx 12345 > salida.txt

Nota: Asegúrate de que el puerto esté abierto y accesible para el envío y recepción de datos.
END_USAGE
}

# Verificar si se está ejecutando en modo "tx" o "rx"
my $mode = shift @ARGV || '';

if ($mode eq 'tx') {
    # Modo Transmisión (Enviar datos a un servidor)
    my ($host, $port) = @ARGV;
    if (!$host || !$port) {
        die "Debes especificar el host y el puerto en modo tx.\n";
    }

    # Crear socket cliente para enviar datos
    my $socket = IO::Socket::INET->new(
        PeerAddr => $host,
        PeerPort => $port,
        Proto    => 'tcp',
    ) or die "No se pudo conectar a $host:$port: $!\n";

    print "Conectado a $host en el puerto $port. Enviando datos...\n";

    # Leer desde la entrada estándar (pipe o teclado)
    while (my $line = <STDIN>) {
        $socket->send($line) or die "Error al enviar datos: $!\n";
    }

    # Cerrar el socket
    $socket->close();
    print "Datos enviados y conexión cerrada.\n";

} elsif ($mode eq 'rx') {
    # Modo Recepción (Escuchar en un puerto)
    my $port = shift @ARGV;
    if (!$port) {
        die "Debes especificar el puerto en modo rx.\n";
    }

    # Crear socket servidor para recibir datos
    my $server_socket = IO::Socket::INET->new(
        LocalPort => $port,
        Proto     => 'tcp',
        Listen    => 5,
        Reuse     => 1,
    ) or die "No se pudo crear el socket en el puerto $port: $!\n";

    print "Escuchando en el puerto $port...\n";

    # Aceptar conexión y recibir datos
    while (1) {
        my $client_socket = $server_socket->accept();
        my $client_address = $client_socket->peerhost();
        my $client_port = $client_socket->peerport();
        print "Conexión recibida desde $client_address:$client_port\n";

        # Recibir datos y mostrarlos
        while (my $data = <$client_socket>) {
            print $data;
        }

        # Cerrar el socket cliente después de recibir los datos
        $client_socket->close();
        print "Conexión cerrada con $client_address:$client_port\n";
    }

    # Cerrar el socket servidor (aunque nunca llegamos aquí en este caso)
    $server_socket->close();
} else {
    # Modo sin parámetros o incorrectos
    die "Modo inválido. Usa 'tx' o 'rx'. Ejecuta el script sin parámetros para ver la ayuda.\n";
}

