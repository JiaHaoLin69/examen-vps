#!/bin/bash

set -e

load_entrypoint_nginx(){
    echo "Cargando entrypoint Nginx..." >> /root/logs/informe_web.log
    
    if [ -f /root/admin/sweb/nginx/start.sh ]; then
        bash /root/admin/sweb/nginx/start.sh
        echo "Entrypoint Nginx ejecutado" >> /root/logs/informe_web.log
    else
        echo "ADVERTENCIA: start.sh de Nginx no encontrado" >> /root/logs/informe_web.log
    fi
}

directorio_de_trabajo(){
    echo "Cambiando directorio..." >> /root/logs/informe_web.log

    if cd /root/admin/node/proyectos/autocaravaneando; then
        echo "Directorio cambiado a: $(pwd)" >> /root/logs/informe_web.log
    else
        echo "ERROR: No se pudo cambiar al directorio" >> /root/logs/informe_web.log
        exit 1
    fi
}

contruir_y_copiar(){
    
    npm install
    # Construir proyecto
    if npm run build; then
        echo "Proyecto construido" >> /root/logs/informe_web.log
    else
        echo "ERROR: Falló npm run build" >> /root/logs/informe_web.log
        exit 1
    fi
    
    # Copiar a /var/www/html
    if [ -d build ]; then
        cp -r build/* /var/www/html/
        echo "Archivos copiados a /var/www/html" >> /root/logs/informe_web.log
    else
        echo "ERROR: Directorio build no encontrado" >> /root/logs/informe_web.log
        exit 1
    fi
}

cargar_nginx(){
    echo "Configurando Nginx..." >> /root/logs/informe_web.log
    
    # Verificar configuración de Nginx
    if nginx -t; then
        echo "Configuración Nginx OK" >> /root/logs/informe_web.log
        echo "ERROR: Configuración Nginx inválida" >> /root/logs/informe_web.log
        exit 1
    fi
    
    # Iniciar Nginx
    nginx -g 'daemon off;'
    echo "Nginx iniciado" >> /root/logs/informe_web.log
}

main(){
    mkdir -p /root/logs
    touch /root/logs/informe_web.log
    load_entrypoint_nginx
    directorio_de_trabajo
    contruir_y_copiar
    cargar_nginx
}

main