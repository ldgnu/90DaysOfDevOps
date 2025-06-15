---

### 📄 `dia02/README.md`

````markdown
# 🧱 Día 2 – VirtualBox desde consola como los pros 😎

Hoy nos metimos de lleno en crear VMs de forma **100% por terminal**, usando `VBoxManage` para armar una máquina virtual con Ubuntu Server.

---

## 🧠 ¿Cómo me sentí?

Me sentí **muy cómodo**. La verdad que levantar la VM desde la terminal, configurar RAM, CPU, disco y arrancar todo sin tocar un solo clic… fue 🔥.  
Sentí que tenía el control total. Y encima, dejé todo listo para romperlo tranquilo gracias a los snapshots. Un antes y un después para laburar con infraestructura local.

---

## ⚙️ Creación completa de la VM

### 📥 Descargar Ubuntu Server
```bash
wget https://releases.ubuntu.com/22.04/ubuntu-22.04.4-live-server-amd64.iso -O ubuntu-server.iso
````

### 📦 Crear VM

```bash
VBoxManage createvm --name "UbuntuServerCLI" --ostype Ubuntu_64 --register
VBoxManage modifyvm "UbuntuServerCLI" --memory 2048 --cpus 2 --nic1 nat --boot1 dvd --boot2 disk --graphicscontroller vmsvga
```

### 💾 Crear disco

```bash
VBoxManage createhd --filename "$HOME/VirtualBox VMs/UbuntuServerCLI/UbuntuServerCLI.vdi" --size 10000
```

### 🔗 Configurar almacenamiento

```bash
VBoxManage storagectl "UbuntuServerCLI" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "UbuntuServerCLI" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/UbuntuServerCLI/UbuntuServerCLI.vdi"
VBoxManage storageattach "UbuntuServerCLI" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$PWD/ubuntu-server.iso"
```

### 🚀 Arrancar la VM

```bash
VBoxManage startvm "UbuntuServerCLI" --type gui
# o en modo headless
# VBoxManage startvm "UbuntuServerCLI" --type headless
```

---

## 🧷 Snapshots (para romper sin culpa)

### Crear snapshot después de instalar

```bash
VBoxManage snapshot "UbuntuServerCLI" take "fresh-install" --description "Ubuntu Server recién instalado"
```

### Ver snapshots disponibles

```bash
VBoxManage snapshot "UbuntuServerCLI" list
```

### Restaurar snapshot

```bash
VBoxManage snapshot "UbuntuServerCLI" restore "fresh-install"
```

---

## 🕵️ Búsqueda de archivos con permisos peligrosos

Esto es oro en producción: encontré archivos con permisos `777` que pueden ser un agujero de seguridad.

```bash
find / -type f -perm 0777 2>/dev/null
```

> Permisos 0777 → usuario puede leer, escribir y ejecutar; grupo puede leer y ejecutar; otros sin permisos. ⚠️ Siempre revisar antes de dejar así en un server real.

---

## 🧹 Limpiar todo (opcional)

Si querés borrar la VM:

```bash
VBoxManage unregistervm "UbuntuServerCLI" --delete
rm ubuntu-server.iso
```

---
📄 dia02/README.md

# 🧠 VirtualBox, NGINX y publicación con Cloudflare Tunnel

Tambien aparte de crear máquinas virtuales con VirtualBox **desde la terminal**, instalé **Ubuntu Server**, levanté un sitio con **NGINX**, y lo publiqué con **Cloudflare Tunnel** ¡sin abrir puertos! 🔥

---

## 🧰 Herramientas usadas

- 🖥️ VirtualBox (`VBoxManage`)
- 🐧 Ubuntu Server
- 🌐 NGINX
- ☁️ Cloudflare Tunnel
- 🔍 Comandos de sistema para diagnósticos y seguridad

---

## 🔧 Crear VM desde terminal con VBoxManage

### 📥 Descargar Ubuntu Server

```bash
wget https://releases.ubuntu.com/22.04/ubuntu-22.04.4-live-server-amd64.iso -O ubuntu-server.iso

⚙️ Crear y configurar la VM

VBoxManage createvm --name "UbuntuServerCLI" --ostype Ubuntu_64 --register
VBoxManage modifyvm "UbuntuServerCLI" --memory 2048 --cpus 2 --nic1 nat --boot1 dvd --boot2 disk --graphicscontroller vmsvga
VBoxManage createhd --filename "$HOME/VirtualBox VMs/UbuntuServerCLI/UbuntuServerCLI.vdi" --size 10000
VBoxManage storagectl "UbuntuServerCLI" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "UbuntuServerCLI" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/UbuntuServerCLI/UbuntuServerCLI.vdi"
VBoxManage storageattach "UbuntuServerCLI" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$PWD/ubuntu-server.iso"

🚀 Arrancar la VM

VBoxManage startvm "UbuntuServerCLI" --type gui

    También podés usar --type headless si no querés abrir la ventana.

🧷 Snapshots para guardar el estado

VBoxManage snapshot "UbuntuServerCLI" take "fresh-install" --description "Ubuntu Server recién instalado"
VBoxManage snapshot "UbuntuServerCLI" list
VBoxManage snapshot "UbuntuServerCLI" restore "fresh-install"

🌐 Instalar y configurar NGINX

sudo apt update && sudo apt install -y nginx
cd /var/www/html/
sudo mv index.html index-original.html
sudo nano index.html
sudo chown www-data:www-data index.html
sudo chmod 644 index.html
sudo systemctl reload nginx

🚪 Publicar el sitio con Cloudflare Tunnel (sin abrir puertos)
Instalar Cloudflared

sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt-get update && sudo apt-get install cloudflared

Crear y lanzar el túnel

sudo cloudflared service install <TOKEN_DE_CLOUDFLARE>

    Ahora el sitio es accesible por una URL segura de Cloudflare. ✨

🔍 Chequeos útiles
Ver archivos con permisos peligrosos (full 777)

find / -type f -perm 0777 2>/dev/null

Chequear hora y uptime del servidor

date
uptime


