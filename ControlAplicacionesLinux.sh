#!/bin/bash

#VARIABLES PRINCIPALES
# con export son las variables necesarias para exportar al los siguientes script
#variables para el menu_info

export NombreScript="$0"
export DescripcionDelScript="Controla las aplicaciones que puede ejecutar uno o varios usuarios del sistema."
export Correo="scripts@mbbsistemas.com"
export Web="https://repositorio.mbbsistemas.es"
export version="1.0"
conexion="Sin comprobar"
software="Sin comprobar"
actualizado="No se ha podido comprobar la actualizacion del script"

# VARIABLE QUE RECOJEN LAS RUTAS
ruta_ejecucion=$(dirname "$(readlink -f "$0")") #es la ruta de ejecucion del script sin la / al final
ruta_escritorio=$(xdg-user-dir DESKTOP) #es la ruta de tu escritorio sin la / al final

# VARIABLES PARA LA ACTUALIZAION CON GITHUB
NombreScriptActualizar="ControlAplicacionesLinux.sh" #contiene el nombre del script para poder actualizar desde github
DireccionGithub="https://github.com/sukigsx/ControlAplicacionesLinux" #contiene la direccion de github para actualizar el script

#VARIABLES DE SOFTWARE NECESARIO
# Asociamos comandos con el paquete que los contiene [comando a comprobar]="paquete a instalar"
    declare -A requeridos
    requeridos=(
        [git]="git"
        [nano]="nano"
        [curl]="curl"
        [konsole]="konsole"
        [getfacl]="acl"
        [zenity]="zenity"
        [diff]="diff"
        [ping]="ping"
        [tr]="coreutils"
        [sed]="sed"
    )


#colores
rojo="\e[0;31m\033[1m" #rojo
verde="\e[;32m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
rosa="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
borra_colores="\033[0m\e[0m" #borra colores

#toma el control al pulsar control + c
trap ctrl_c INT
function ctrl_c()
{
clear
echo ""
echo -e "${azul} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
echo ""
sleep 1
exit
}

menu_info(){
# muestra el menu de sukigsx
echo ""
echo -e "${rosa}            _    _                  ${azul}   Nombre del script${borra_colores} ($NombreScript)"
echo -e "${rosa}  ___ _   _| | _(_) __ _ _____  __  ${azul}   Descripcion${borra_colores} ($DescripcionDelScript)"
echo -e "${rosa} / __| | | | |/ / |/ _\ / __\ \/ /  ${azul}   Version            =${borra_colores} $version"
echo -e "${rosa} \__ \ |_| |   <| | (_| \__ \>  <   ${azul}   Conexion Internet  =${borra_colores} $conexion"
echo -e "${rosa} |___/\__,_|_|\_\_|\__, |___/_/\_\  ${azul}   Software necesario =${borra_colores} $software"
echo -e "${rosa}                  |___/             ${azul}   Actualizado        =${borra_colores} $actualizado"
echo -e ""
echo -e "${azul} Contacto:${borra_colores} (Correo $Correo) (Web $Web)${borra_colores}"
echo ""
}


actualizar_script(){
    # actualizar el script
    #para que esta funcion funcione necesita:
    #   conexion a internet
    #   la paleta de colores
    #   software: git diff

    git clone $DireccionGithub /tmp/comprobar >/dev/null 2>&1

    diff $ruta_ejecucion/$NombreScriptActualizar /tmp/comprobar/$NombreScriptActualizar >/dev/null 2>&1


    if [ $? = 0 ]
    then
        #esta actualizado, solo lo comprueba
        echo ""
        echo -e "${verde} El script${borra_colores} $0 ${verde}esta actualizado.${borra_colores}"
        echo ""
        chmod -R +w /tmp/comprobar
        rm -R /tmp/comprobar
        actualizado="SI"
        sleep 2
    else
        #hay que actualizar, comprueba y actualiza
        echo ""
        echo -e "${amarillo} EL script${borra_colores} $0 ${amarillo}NO esta actualizado.${borra_colores}"
        echo -e "${verde} Se procede a su actualizacion automatica.${borra_colores}"
        sleep 3
        cp -r /tmp/comprobar/* $ruta_ejecucion
        chmod -R +w /tmp/comprobar
        rm -R /tmp/comprobar
        echo ""
        echo -e "${amarillo} El script se ha actualizado, es necesario cargarlo de nuevo.${borra_colores}"
        echo ""
        sleep 2
        exit
    fi
}


software_necesario(){
#funcion software necesario
#para que funcione necesita:
#   conexion a internet
#   la paleta de colores
#   software: which

echo ""
echo -e "${azul} Comprobando el software necesario.${borra_colores}"
echo ""
#which git diff ping figlet xdotool wmctrl nano fzf
#########software="which git diff ping figlet nano gdebi curl konsole" #ponemos el foftware a instalar separado por espacion dentro de las comillas ( soft1 soft2 soft3 etc )
for comando in "${!requeridos[@]}"; do
        which $comando &>/dev/null
        sino=$?
        contador=1
        while [ $sino -ne 0 ]; do
            if [ $contador -ge 4 ] || [ "$conexion" = "no" ]; then
                clear
                echo ""
                echo -e " ${amarillo}NO se ha podido instalar ${rojo}${requeridos[$comando]}${amarillo}.${borra_colores}"
                echo -e " ${amarillo}Inténtelo usted con: (${borra_colores}sudo apt install ${requeridos[$comando]}${amarillo})${borra_colores}"
                echo -e ""
                echo -e " ${rojo}No se puede ejecutar el script sin el software necesario.${borra_colores}"
                echo ""; read p
                echo ""
                exit 1
            else
                echo " Instalando ${requeridos[$comando]}. Intento $contador/3."
                sudo apt install ${requeridos[$comando]} -y &>/dev/null
                let "contador=contador+1"
                which $comando &>/dev/null
                sino=$?
            fi
        done
        echo -e " [${verde}ok${borra_colores}] $comando (${requeridos[$comando]})."; software="SI"
    done

    echo ""
    echo -e "${azul} Todo el software ${verde}OK${borra_colores}"
    sleep 2
}


conexion(){
#funcion de comprobar conexion a internet
#para que funciones necesita:
#   conexion ainternet
#   la paleta de colores
#   software: ping

if ping -c1 google.com &>/dev/null
then
    conexion="SI"
    echo ""
    echo -e " Conexion a internet = ${verde}SI${borra_colores}"
else
    conexion="NO"
    echo ""
    echo -e " Conexion a internet = ${rojo}NO${borra_colores}"
fi
}

#logica de arranque
#variables de resultado $conexion $software $actualizado
#funciones actualizar_script, conexion, software_necesario

#logica para ejecutar o no ejecutar
#comprobado conexcion
#    si=actualizar_script
#        si=software_necesario
#            si=ejecuta, poner variables a sii todo
#            no=Ya sale el solo desde la funcion
#        no=software_necesario
#            si=ejecuta, variables software="SI", conexion="SI", actualizado="No se ha podiso comprobar actualizacion de script"
#            no=Ya sale solo desde la funcion
#
#    no=software_necesario
#        si=ejecuta, variables software="SI", conexion="NO", actualizado="No se ha podiso comprobar actualizacion de script"
#        no=Ya sale solo desde la funcion


clear
menu_info
conexion
if [ $conexion = "SI" ]; then
    actualizar_script
    if [ $actualizado = "SI" ]; then
        software_necesario
        if [ $software = "SI" ]; then
            export software="SI"
            export conexion="SI"
            export actualizado="SI"
            #bash $ruta_ejecucion/ #PON LA RUTA
        else
            echo ""
        fi
    else
        software_necesario
        if [ $software = "SI" ]; then
            export software="SI"
            export conexion="NO"
            export actualizado="No se ha podido comprobar la actualizacion del script"
            #bash $ruta_ejecucion/ #PON LA RUTA
        else
            echo ""
        fi
    fi
else
    software_necesario
    if [ $software = "SI" ]; then
        export software="SI"
        export conexion="NO"
        export actualizado="No se ha podido comprobar la actualizacion del script"
        #bash $ruta_ejecucion/ #PON LA RUTA
    else
        echo ""
    fi
fi


# Evitar advertencias de GTK/Zenity en la consola
export ZENITY_NO_GTK_WARNINGS=1

# Comprobar si el script se ejecuta con privilegios de root
clear
if [ "$EUID" -ne 0 ]; then
  clear
  echo -e "\e[31mEste script necesita permisos de sudo.\e[0m"
  echo ""
  echo -e "\e[33mPor favor, ejecútalo con:\e[0m"
  echo "   sudo $0"
  echo "   sudo bash $0"
  echo ""
  read -rp "Pulsa Enter para salir..."
  exit 1
else
  clear
  echo -e "\e[33mOK. Tenemos permisos sudo.\e[0m"
fi

while true; do
    usuario=$(getent passwd | awk -F: '$3>=1000 && $7!="/usr/sbin/nologin" {print $1}' | sort | \
        zenity --list --title="Diseñado por SUKIGSX" \
        --text="Selecciona el usuario para administrar permisos de ejecución:" \
        --column="Usuario" --height=300 --width=300 \
        --ok-label="Seleccionar" --cancel-label="Salir" 2>/dev/null)

    [ -z "$usuario" ] && exit 0

    # NUEVA VENTANA con botones
    opcion_usuario=$(zenity --list --radiolist \
        --title="Diseñado por SUKIGSX" \
        --text="¿Qué deseas hacer para el usuario $usuario?" \
        --column="Selecciona" --column="Acción" \
        TRUE "Configurar permisos de aplicaciones" \
        FALSE "Listar aplicaciones sin permiso de ejecución" \
        --height=250 --width=500 \
        --ok-label="Continuar" --cancel-label="Atras" 2>/dev/null)

    [ -z "$opcion_usuario" ] && continue

    # -------------------------------------------------------
    # OPCIÓN 1: Listar aplicaciones sin permiso de ejecución
    # -------------------------------------------------------
    if [ "$opcion_usuario" == "Listar aplicaciones sin permiso de ejecución" ]; then
        sin_permiso=()
        IFS=: read -ra path_dirs <<< "$PATH"
        for fdir in "${rutas_adicionales[@]}"; do
            [ -d "$fdir" ] && path_dirs+=("$fdir")
        done
        for dir in "${path_dirs[@]}"; do
            [ -d "$dir" ] || continue
            while IFS= read -r file; do
                if [ -f "$file" ] && [ -x "$file" ]; then
                    acl_output=$(getfacl -p "$file" 2>/dev/null | grep "^user:$usuario:")
                    if [ -n "$acl_output" ]; then
                        permisos=$(echo "$acl_output" | awk -F: '{print $3}')
                        [[ "$permisos" != *x* ]] && sin_permiso+=("$file")
                    fi
                fi
            done < <(find "$dir" -maxdepth 1 -type f 2>/dev/null)
        done

        if [ ${#sin_permiso[@]} -eq 0 ]; then
            zenity --info --title="Diseñado por SUKIGSX" \
                   --text="El usuario $usuario tiene permiso de ejecución en todas las aplicaciones." \
                   --width=400 --height=200 2>/dev/null
        else
	    zenity --info \
  		--title="Aplicaciones sin permiso de ejecución" \
  		--width=500 --height=500 \
  		--text="El usuario $usuario NO tiene permiso de ejecución en los siguientes archivos:\n\n$(printf '%s\n' "${sin_permiso[@]}")"
		--ok-label="Acertar" --cancel-label="" 2>/dev/null

        fi
        continue
    fi

    # -------------------------------------------------------
    # OPCIÓN 2: Configurar permisos manualmente
    # -------------------------------------------------------
    # Añadir rutas adicionales (binarios y lanzadores)
rutas_adicionales=(
    "/var/lib/flatpak/exports/bin"
    "/home/$usuario/.local/share/flatpak/exports/bin"
    "/var/lib/flatpak/exports/share/applications"
    "/home/$usuario/.local/share/flatpak/exports/share/applications"
    "/snap/bin"
    "/home/$usuario/Applications/"
)
    apps_array=()
    IFS=: read -ra path_dirs <<< "$PATH"
    for fdir in "${rutas_adicionales[@]}"; do
        [ -d "$fdir" ] && path_dirs+=("$fdir")
    done

    for dir in "${path_dirs[@]}"; do
        if [ -d "$dir" ]; then
            while IFS= read -r file; do
                if { [ -x "$file" ] && [ -f "$file" ]; } || [[ "$file" == *.desktop ]]; then
                    apps_array+=("$file")
                fi
            done < <(find "$dir" -maxdepth 1 \( -type f -o -type l \) 2>/dev/null)
        fi
    done

    mapfile -t apps_array < <(printf "%s\n" "${apps_array[@]}" | sort -u)

    zenity_list=()
    for app in "${apps_array[@]}"; do
        zenity_list+=("$app" "$app" FALSE)
    done

    selected_apps=$(zenity --list --checklist \
        --title="Diseñado por SUKIGSX" \
        --text="Selecciona las aplicaciones marcando las casillas.\nPuedes buscar escribiendo el nombre:" \
        --column="Selecciona" --column="Archivo" --column="Seleccionada" \
        "${zenity_list[@]}" \
        --height=500 --width=800 \
        --ok-label="Seleccionar" --cancel-label="Atrás" 2>/dev/null)

    [ -z "$selected_apps" ] && continue

    action=$(zenity --list --radiolist \
        --title="Diseñado por SUKIGSX" \
        --text="Aplicaciones seleccionadas para el usuario $usuario:" \
        --column="Selecciona" --column="Acción" \
        TRUE "Quitar permisos de ejecución (rw-)" \
        FALSE "Dar permisos de ejecución (rwx)" \
        --ok-label="Aplicar" --cancel-label="Salir" 2>/dev/null)

    [ -z "$action" ] && continue

    IFS="|" read -ra apps_selected <<< "$selected_apps"

    for app in "${apps_selected[@]}"; do
        target="$app"
        if [[ "$app" == *.desktop ]]; then
            exec_line=$(grep -m1 "^Exec=" "$app" | cut -d'=' -f2- | awk '{print $1}')
            if [ -n "$exec_line" ]; then
                if command -v flatpak &>/dev/null && [[ "$exec_line" == flatpak* ]]; then
                    flatpak_id=$(echo "$exec_line" | awk '{print $2}')
                    [ -x "/var/lib/flatpak/exports/bin/$flatpak_id" ] && target="/var/lib/flatpak/exports/bin/$flatpak_id"
                    [ -x "/home/$usuario/.local/share/flatpak/exports/bin/$flatpak_id" ] && target="/home/$usuario/.local/share/flatpak/exports/bin/$flatpak_id"
                elif [ -x "$exec_line" ]; then
                    target="$exec_line"
                fi
            fi
        fi

        real_app=$(readlink -f "$target")

        if [ "$action" == "Quitar permisos de ejecución (rw-)" ]; then
            sudo setfacl -m u:"$usuario":rw- "$real_app"
            [[ "$real_app" == *.AppImage ]] && sudo chown root:root "$real_app"
        else
            sudo setfacl -m u:"$usuario":rwx "$real_app"
            [[ "$real_app" == *.AppImage ]] && sudo chown "$usuario":"$usuario" "$real_app"
        fi
    done

    zenity --info --text="Permisos ACL aplicados correctamente al usuario $usuario." 2>/dev/null
done
