#!/bin/bash

set -e

directorio_de_trabajo(){
    echo "Cambiando directorio..." >> /root/logs/informe_pokeapi.log
    
    if cd /root/admin/node/proyectos/pokeapi; then
        echo "Directorio cambiado a: $(pwd)" >> /root/logs/informe_pokeapi.log
    else
        echo "ERROR: No se pudo cambiar al directorio" >> /root/logs/informe_pokeapi.log
        exit 1
    fi
}

contruir_y_copiar(){

    
    # Construir proyecto
    if npm run build; then
        echo "Proyecto construido" >> /root/logs/informe_pokeapi.log
    else
        echo "ERROR: Falló npm run build" >> /root/logs/informe_pokeapi.log
        exit 1
    fi
    
    # Copiar a /var/www/html
    if [ -d dist ]; then
        cp -r dist/* /var/www/html/
        echo "Archivos copiados a /var/www/html" >> /root/logs/informe_pokeapi.log
    else
        echo "ERROR: Directorio dist no encontrado" >> /root/logs/informe_pokeapi.log
        exit 1
    fi
}

cargar_nginx(){
    echo "Configurando Nginx..." >> /root/logs/informe_pokeapi.log
    
    # Verificar configuración de Nginx
    if nginx -t; then
        echo "Configuración Nginx OK" >> /root/logs/informe_pokeapi.log
    else
        echo "ERROR: Configuración Nginx inválida" >> /root/logs/informe_pokeapi.log
        exit 1
    fi
    
    # Iniciar Nginx
    nginx -g 'daemon off;'
    echo "Nginx iniciado" >> /root/logs/informe_pokeapi.log
}

main(){
    mkdir -p /root/logs
    touch /root/logs/informe_web.log
    directorio_de_trabajo
    contruir_y_copiar
    cargar_nginx
}

main