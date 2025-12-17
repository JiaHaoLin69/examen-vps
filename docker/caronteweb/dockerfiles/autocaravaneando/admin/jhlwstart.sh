#!/bin/bash

load_entrypoint_seguridad() {
    echo "Ejecutando entrypoint seguridad..." >> /root/logs/informe_nginx.log
    
    if [ -f /root/admin/ubseguridad/jhlwstart.sh ]; then
        bash /root/admin/ubseguridad/jhlwstart.sh
        echo "Entrypoint seguridad ejecutado" >> /root/logs/informe_nginx.log
    else
        echo "ERROR: No se encontró /root/admin/ubseguridad/jhlwstart.sh" >> /root/logs/informe_nginx.log
    fi
}

load_entrypoint_nginx(){
    echo "Cargando entrypoint Nginx..." >> /root/logs/informe_react.log
    
    if [ -f /root/admin/sweb/nginx/start.sh ]; then
        bash /root/admin/sweb/nginx/start.sh
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
        npm install -g npm@11.7.0
        npm install && echo "Dependencias instaladas" >> /root/logs/informe_react.log
        # Inciar el servidor de desarrollo de React
        HOST=0.0.0.0 PORT=3000 npm start &
    else
        echo "ERROR: package.json no encontrado" >> /root/logs/informe_react.log
        exit 1
    fi
}




main(){
    mkdir -p /root/logs
    touch /root/logs/informe_react.log
    load_entrypoint_nginx
    load_entrypoint_seguridad
    workdir
    dependencias-y-servicio
}


main