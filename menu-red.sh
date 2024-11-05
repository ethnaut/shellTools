#!/bin/bash

# Verificar si se pasó un argumento como host
if [ -z "$1" ]; then
    echo "No se proporcionó ningún host. Usando el valor por defecto: madtr6.madrid.opentransit.net"
    host="madtr6.madrid.opentransit.net"
else
    host=$1
    echo "Host inicial: $host"
fi

# Funciones para cada opción del menú
seleccionar_host() {
    read -p "Introduce el host que deseas utilizar: " nuevo_host
    host=$nuevo_host
    echo "Host seleccionado: $host"
}

ping_host() {
    echo "Haciendo ping a $host..."
    sudo ping -c3 $host
}

traceroute_host() {
    echo "Realizando traceroute a $host..."
    mtr  $host
}

dns_resolution() {
    echo "Resolución DNS para $host..."
    dig  $host
}

nmap_scan() {
    echo "Escaneando puertos abiertos en $host..."
    nmap $host
}

show_ip() {
    echo "Mostrando dirección IP de $host..."
    host $host | awk '/has address/ { print $4 }'
}

# Mostrar el menú
mostrar_menu() {
    echo "Host seleccionado: $host"
    echo "Por favor selecciona una opción:"
    echo "1) Seleccionar host"
    echo "2) Hacer ping al host"
    echo "3) Realizar traceroute al host"
    echo "4) Consultar la resolución DNS del host"
    echo "5) Comprobar puertos abiertos del host"
    echo "6) Mostrar la dirección IP del host"
    echo "7) Salir"
}

# Leer la elección del usuario
leer_opcion() {
    local opcion
    read -p "Introduce una opción [1-7]: " opcion
    case $opcion in
        1) seleccionar_host ;;
        2) ping_host ;;
        3) traceroute_host ;;
        4) dns_resolution ;;
        5) nmap_scan ;;
        6) show_ip ;;
        7) echo "Saliendo..." ; exit 0 ;;
        *) echo "Opción inválida. Inténtalo de nuevo." ;;
    esac
}

# Bucle principal
while true; do
    mostrar_menu
    leer_opcion
done

