🐧 Linux App Access & ACL Manager
Conjunto de scripts en Bash diseñados para administrar y restringir el acceso a aplicaciones en sistemas Linux utilizando Listas de Control de Acceso (ACLs a través de setfacl/getfacl).

El repositorio incluye dos alternativas según tus necesidades: una versión en consola ultra rápida basada en fzf y otra versión gráfica basada en zenity.

🛠️ Características Principales
Control Granular por Usuario: Selecciona cualquier usuario del sistema de forma interactiva.

Auditoría en Tiempo Real: Analiza el estado actual de los permisos (PERMITIDO / DENEGADO) sobre los binarios o ejecutables asociados a los lanzadores (.desktop, binarios directos, Flatpaks, Snaps, etc.).

Sistema de Envoltorios (Wrappers) Inteligentes (Script FZF): Al revocar permisos, el script mueve el binario original a .real y genera un wrapper frontal. Si el usuario bloqueado intenta ejecutarlo, se le deniega el acceso mediante consola y se le muestra una alerta gráfica emergente.

Soporte Multi-entorno: Compatible con aplicaciones tradicionales del sistema (/usr/share/applications), Flatpak, Snap y rutas locales del usuario.

📋 Requisitos del Sistema
Para el correcto funcionamiento de cualquiera de los dos scripts, asegúrate de tener instaladas las siguientes dependencias:

Bash (versión 4 o superior)

ACL (setfacl y getfacl)

Sudo (privilegios de administración)

Herramientas de interfaz:

Para el script CLI: fzf y column (generalmente incluido en bsdmainutils).

Para el script gráfico: zenity.

Instalación rápida de dependencias (Ubuntu / Debian / Mint)
Bash
sudo apt update
sudo apt install acl fzf zenity bsdmainutils
📂 Contenido del Repositorio
ControlAplicacionesLinux.sh (Versión Terminal / TUI): Interfaz interactiva de alta velocidad orientada a terminal utilizando fzf, con soporte de wrappers de seguridad automáticos.

ControlAplicacionesLinuxGui.sh (Versión Gráfica / GUI): Interfaz de ventanas mediante zenity que permite tanto la configuración visual como la auditoría rápida de aplicaciones sin permisos de ejecución.

🚀 Uso de los Scripts
1. Versión con FZF (ControlAplicacionesLinux.sh)
Ejecuta el script con privilegios o asegúrate de que el usuario tenga capacidad de ejecución con sudo para aplicar las ACLs:

Bash
ControlAplicacionesLinux.sh
Funcionamiento:

Te listará los usuarios del sistema para que elijas uno.

Hará un escaneo de los archivos .desktop y auditará el estado de ejecución.

Usa [TAB] para marcar o desmarcar las aplicaciones que deseas modificar y presiona [ENTER].

Selecciona si deseas Otorgar u Revocar los permisos.

2. Versión con Zenity (ControlAplicacionesLinuxGui.sh)
Ejecuta el script desde tu entorno gráfico:

Bash
ControlAplicacionesLinuxGui.sh
Funcionamiento:

Se abrirá una ventana gráfica para seleccionar el usuario.

Podrás elegir entre dos acciones principales:

Configurar permisos de aplicaciones: Mediante checklists visuales para dar o quitar accesos (rwx / rw-).

Listar aplicaciones sin permiso de ejecución: Muestra un reporte rápido de los binarios donde el usuario seleccionado tiene restricciones activas.

⚠️ Notas Técnicas
Aplicaciones Snap: Debido a que la mayoría de los paquetes Snap redirigen a un único ejecutable en /usr/bin/snap, modificar los permisos ACL de un Snap puede repercutir de forma global en los demás paquetes Snap del sistema. El script con Zenity incluye un aviso preventivo para esto.

Seguridad: Los cambios se aplican directamente a nivel de sistema de ficheros mediante ACLs de Linux, lo que garantiza que los usuarios no puedan saltarse la restricción ejecutando los binarios directamente.

👨‍💻 Autor
Diseñado por SUKIGSX.

📄 Licencia
Este proyecto se distribuye bajo los términos de la licencia MIT. Siéntete libre de modificarlo y adaptarlo a tus necesidades.



## Instalacion
Clonar el repositorio (se clonaran las dos versiones, la de terminal fzf y la de zenity)

```
git clone https://github.com/sukigsx/ControlAplicacionesLinux.git
```

Tambien puedes utilizar mi script (ejecutar_scripts).

```
git clone https://github.com/sukigsx/ejecutar_scripts.git
```
