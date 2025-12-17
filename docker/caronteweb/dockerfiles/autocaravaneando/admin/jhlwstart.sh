#!/bin/bash

set -e 

load_entrypoint_nginx(){
    echo "Cargando entrypoint Nginx..." >> /root/logs/informe_react.log
    
    if [ -f /root/admin/sweb/nginx/jhlwstart.sh ]; then
        bash /root/admin/sweb/nginx/admin/jhlwstart.sh
        echo "Entrypoint Nginx ejecutado" >> /root/logs/informe_react.log
    else
        echo "ADVERTENCIA: start.sh de Nginx no encontrado" >> /root/logs/informe_react.log
    fi
}

workdir(){
    echo "Cambiando directorio..." >> /root/logs/informe_react.log
    
    if [ -d /root/admin/node/proyectos/autocaravaneando ]; then
        cd /root/admin/node/proyectos/autocaravaneando
        echo "Directorio cambiado a: $(pwd)" >> /root/logs/informe_react.log
    else
        echo "ERROR: Directorio /root/admin/node/proyectos/autocaravaneando no existe" >> /root/logs/informe_react.log
        exit 1
    fi
}

dependencias-y-servicio(){
    echo "Instalando dependencias..." >> /root/logs/informe_react.log
    
    # Verificar si package.json existe
    if [ -f package.json ]; then
        npm install && echo "Dependencias instaladas" >> /root/logs/informe_react.log
        # Inciar el servidor de desarrollo de React
        npm run dev -- --host 0.0.0.0 --port 3000 && echo "Servidor React iniciado" >> /root/logs/informe_react.log
    else
        echo "ERROR: package.json no encontrado" >> /root/logs/informe_react.log
        exit 1
    fi
}

main(){
    mkdir -p /root/logs
    touch /root/logs/informe_react.log
    load_entrypoint_nginx
    workdir
    dependencias-y-servicio
}

main