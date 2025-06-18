````markdown
# 🧠 Día 4 – Git, conflictos y rebase: una historia de amor y odio

Hoy fue el día donde Git me llevó del cielo al infierno y de vuelta al cielo.  
Aprendí a clonar, crear ramas, hacer rebase, merges, resolver conflictos y... **sufrir dignamente**.

---

## 🧪 Qué hice paso a paso

### 🔹 Fork + Clone

1. Hice fork del repo `git-exercises` desde GitHub.
2. Cloné mi fork en local:
   ```bash
   git clone https://github.com/ldgnu/git-exercises.git
````

3. Cambié el `remote` a SSH:

   ```bash
   git remote set-url origin git@github.com:ldgnu/git-exercises.git
   ```

> ✅ SSH configurado con clave `github-wsl` y archivo `config` en `.ssh`. Alta jugada para no depender de contraseñas.

---

### 🔹 Branching

1. Creé una rama nueva:

   ```bash
   git checkout -b feature-branch
   ```
2. Modifiqué `feature.txt`, lo agregué y lo commiteé:

   ```bash
   git add feature.txt
   git commit -m "Agregado feature.txt con nueva funcionalidad"
   ```
3. Subí la rama:

   ```bash
   git push origin feature-branch
   ```

---

### 🔁 Merge

1. Cambié a `main` y traje lo último:

   ```bash
   git checkout main
   git pull origin main
   ```
2. Mergeé:

   ```bash
   git merge feature-branch
   ```
3. Push a `main`:

   ```bash
   git push origin main
   ```

> 😤 Git no me dejó pushear porque el repo remoto tenía historia diferente (por resets y rebase anteriores). Tuve que aprender la lección:
> **“Si cambias la historia local, tenés que usar `--force` para subirla.”**

```bash
git push origin main --force
```

---

### 🔄 Rebase (y la confusión)

1. Desde `feature-branch` hice:

   ```bash
   git rebase main
   ```
2. No hubo conflictos, pero después corrí:

   ```bash
   git rebase --continue
   ```

> 🧠 Git me gritó:
> ❌ *"fatal: No rebase in progress?"*

Y ahí entendí: **¡no siempre necesitás `--continue`! Solo cuando el rebase se detiene por conflictos. Si terminó, listo, no hay más que hacer.**

---

### 💣 Conflicto real y manual (el bardo)

1. Creé un archivo:

   ```bash
   echo "Hola, DevOps!" > archivo.txt
   ```
2. Lo modifiqué en `main` y en `feature-branch` con contenido distinto.
3. Al mergear:

   ```bash
   git merge feature-branch
   ```

   Git me tiró:

   > ⚔️ `Merge conflict in archivo.txt`
4. Edité el archivo, borré las marcas `<<<<<<<`, `=======`, `>>>>>>>` y dejé el contenido final.
5. Luego:

   ```bash
   git add archivo.txt
   git commit -m "Resuelto conflicto de merge en archivo.txt"
   ```

✅ **Merge completado con éxito.** Git me respeta ahora.

---

## 🧠 Lecciones aprendidas (y cicatrices)

* ⚡ `git push` no siempre funciona si hiciste rebase, necesitás `--force`
* 💣 Los conflictos de merge se resuelven **a mano**, editando el archivo y luego `add` + `commit`
* 😵‍💫 No existe `--continue` si no hay un rebase activo
* 🔐 Trabajar con SSH te ahorra mil dramas

---

## 🤕 Dolor real

* Cuando Git me decía que no podía continuar el rebase y yo no sabía por qué
* Cuando no me dejaba hacer push después del merge y me tiraba errores en rojo
* Cuando edité `pruebas.txt` y me olvidé de hacer `git add`, y el commit me decía que no había nada para commitear 🙃

---

## ✅ Conclusión

Ahora me llevo mejor con Git. Lo respeto. Me respeta.
Peleamos un rato, pero al final quedó claro:

> “El que escribe el `merge conflict`, lo resuelve.” – Javi, 2025

---


