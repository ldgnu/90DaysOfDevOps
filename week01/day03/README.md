# 🛠️ Día 3 – Automatizando con Vagrant como un DevOps real

Hoy fue el turno de meterle con todo a **Vagrant**: levanté una VM con Ubuntu desde cero, configuré provisión automática, instalé NGINX y dejé un sitio listo para navegar.  
Todo esto desde mi **Arch Linux**, usando solo terminal como Dios y Linus Torvalds mandan 🧔🐧.

---

## 💻 ¿Qué hice hoy?

- Instalé Vagrant (`paru vagrant`)
- Inicialicé un nuevo proyecto y configuré un `Vagrantfile`
- Usé scripts de shell externos para provisionar automáticamente la VM
- Instalé NGINX dentro de la VM
- Descomprimí un sitio web con Bootstrap y lo dejé sirviendo desde `/var/www/html/`
- Probé `vagrant provision`, `vagrant reload` y todo lo que te hace sentir como un verdadero infra master 😎

---
![imagen](https://github.com/user-attachments/assets/77e455d2-fc76-450b-b118-93a96af4c5ec)

## 📁 Estructura del proyecto

```bash
mi_proyecto/
├── Vagrantfile
├── site.zip                  # Sitio Bootstrap comprimido
├── scripts/
│   └── instalar_nginx.sh     # Script de provisión
└── vagrant.log               # Logs de provisión
```
⚙️ Vagrantfile utilizado

```bash
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "web-devops"
  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.provision "shell", path: "scripts/instalar_nginx.sh"
end
```
    El sitio queda accesible desde el navegador en:
    👉 http://192.168.56.10
![imagen](https://github.com/user-attachments/assets/60c7de78-e451-4929-8075-b4b5f29f07eb)

🧪 Script de provisión scripts/instalar_nginx.sh
```bash
#!/bin/bash
apt update && apt install -y nginx unzip

# Descomprimir y desplegar sitio
unzip /vagrant/site.zip -d /tmp/sitio
cp -r /tmp/sitio/* /var/www/html/

# Agregar marca personalizada
echo "<!-- Desplegado automáticamente por Javi el $(date) -->" >> /var/www/html/index.html

# Permisos y reinicio del servicio
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
systemctl enable nginx
systemctl restart nginx
```
🔍 Comandos usados (highlights del día)
```bash
vagrant init
vagrant up --provision | tee vagrant.log
vagrant ssh
vagrant reload
vagrant destroy -f
```
![imagen](https://github.com/user-attachments/assets/02003ac8-fe9f-45a3-a221-d28bf3d11f42)

🌟 ¿Qué aprendí?

Que con Vagrant podés tener entornos reproducibles y 100% automatizados.
Que separar scripts en archivos externos es clave para mantener orden.
Que una vez que entendés la provisión… Vagrant se vuelve adictivo 🔁

Además, poder destruir y recrear entornos con un solo comando me hace pensar lo genial que es esto para testing, demos, labs o pipelines.
📸 Resultado

📍 El sitio web con Bootstrap quedó publicado en:
http://192.168.56.10

Con NGINX corriendo y el archivo index.html personalizado con mi nombre y fecha.
🧠 Bonus: ¿Y si le meto Docker y Kubernetes?
![imagen](https://github.com/user-attachments/assets/dfbf9a32-93cf-454f-b1dd-bc5f083894db)

Vagrant también permite instalar Docker y kubectl automáticamente, ejemplo:

config.vm.provision "shell", inline: <<-SHELL
  apt update
  apt install -y docker.io
  systemctl enable --now docker

  curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
SHELL
![imagen](https://github.com/user-attachments/assets/19a24006-3473-4460-88c7-f96c3ecf0575)

📌 Pro tips para DevOps
vagrant destroy && vagrant up = entorno nuevo en 1 minuto
Ideal para CI/CD y reproducir entornos locales
Nunca subestimes un buen tee vagrant.log para debuggear
