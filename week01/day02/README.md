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

📍 **Siguiente día:** [Día 4 – Por definir](../dia04/README.md)

---

```

¿Querés que además te genere un script `.sh` que automatice todo eso? ¿O que te arme una plantilla que podés copiar cada día para tus READMEs?
```
