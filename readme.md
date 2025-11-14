## ⚙️ 1️⃣ Requisitos previos
gh repo bootcamp-auxiliar --public --source=. --remote=origin --push

Antes de comenzar, asegúrate de tener instaladas las siguientes herramientas:

| Herramienta | Requerido | Comando para verificar | url descarga |
|--------------|------------|------------------------| --- |
| **Git** | ✅ | `git --version` | [git oficial](https://git-scm.com/) |
| **Visual Code** | ✅ | `Editor de codigo` | [visual code](https://code.visualstudio.com/) |
| **Python 3.10+** | ✅ | `python --version` | [python3.11.7](https://www.python.org/ftp/python/3.11.7/python-3.11.7-amd64.exe) |
| **AWS CLI v2** | ✅ | `aws --version` | [CLI Windows](https://awscli.amazonaws.com/AWSCLIV2.msi), [CLI MAC](https://awscli.amazonaws.com/AWSCLIV2.pkg) |
| **Cuenta AWS personal o sandbox educativa** | ✅ | — |

---

## 🧩 2️⃣ Verificar version de python
Ejecuta el comando
```bash
py -0
```
``Output``:
```
PS C:\Users\USER\Desktop\estudio\bootcamp_institue> py -0
  *               Active venv
 -V:3.11          Python 3.11 (64-bit)
```


---

## 🌱 3️⃣ Verificar pip para gestion de paquetes de python

```bash
pip list
```
`Output`
```bash
PS C:\Users\USER\Desktop\estudio\bootcamp_institue> pip list
Package           Version
----------------- -------
distlib           0.4.0
filelock          3.19.1
pip               21.2.4
platformdirs      4.4.0
setuptools        58.1.0
typing_extensions 4.15.0
```
Si no se encuentra pip, se deben agregar las variables de entorno de python al path del sistema

![alt text](image-3.png)

![alt text](image-2.png)

![alt text](image-4.png)

![alt text](image-5.png)


deben agregar 2 rutas:
```
C:\Users\USER\AppData\Local\Programs\Python\Python311\Scripts\
```
```
C:\Users\USER\AppData\Local\Programs\Python\Python311\
```

su directorio de usuario puede variar el mio se llamar ``C:\Users\USER\`` el resto es estandar
- ``AppData\Local\Programs\Python\Python311\Scripts\``
- ``AppData\Local\Programs\Python\Python311\``

una vez configurando esto cierren su visual code y cualquier terminal y vuelvan a abrir y ejecutar el comando pip list
```bash
pip list
```
`Output`
```bash
PS C:\Users\USER\Desktop\estudio\bootcamp_institue> pip list
Package           Version
----------------- -------
distlib           0.4.0
filelock          3.19.1
pip               21.2.4
platformdirs      4.4.0
setuptools        58.1.0
typing_extensions 4.15.0
```


---

## ⚙️ 4️⃣ Configurar entorno de desarrollo local

### a) Crear entorno virtual (recomendado)

Desde la terminal bash nstala el paquete virtualenv
```bash
py -3.11 -m pip install virtualenv
```

```bash
py -3.11 -m virtualvenv venv
source venv/Scripts/activate
```

```bash
py -3.11 -m virtualvenv venv  # version python
source venv/bin/activate        # Linux/Mac
venv\Scripts\activate         # Windows
```
### Comprobar que se activo el entorno
Se debera visualizar el nombre del entorno virtual a la izquierda o arriba del path en el que se encuentra
```js
(venv) PS C:\Users\USER\Desktop\estudio\bootcamp_institue>
```

### b) Instalar dependencias (ejemplo)
```bash
pip install boto3
```

### c) Confirmar instalación
```bash
pip list
```
### OutPut
Despues de hacer `pip list` deberas ver algo como:
```js
(venv) PS C:\Users\USER\Desktop\estudio\bootcamp_institue> pip list
Package         Version
--------------- -----------
boto3           1.40.73
botocore        1.40.73
jmespath        1.0.1
pip             25.2
python-dateutil 2.9.0.post0
s3transfer      0.14.0
setuptools      80.9.0
six             1.17.0
urllib3         2.5.0
```

---

## 🔐 5️⃣ Configurar credenciales AWS

Ejecuta:
```bash
aws configure
```

Completa los datos:
```
AWS Access Key ID [None]: <tu_access_key>
AWS Secret Access Key [None]: <tu_secret_key>
Default region name [None]: us-east-1
Default output format [None]: json
```
