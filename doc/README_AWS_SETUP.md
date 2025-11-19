# README – Configuración de Credenciales AWS en Codespaces  
### Usando el script `aws_confi.sh` con soporte para `.env`

## 1. ¿Qué hace este script?

El archivo `aws_confi.sh` permite:

- Configurar automáticamente el perfil `default` de AWS CLI  
- Cargar credenciales desde `.env` si existe  
- Pedir datos de forma interactiva si no los encuentra  
- Crear automáticamente:
  - `~/.aws/credentials`
  - `~/.aws/config`
- Evitar usar `aws configure` manualmente  
- Mantener credenciales fuera del repositorio  

---

## 2. Estructura del proyecto

```
repo/
 ├── aws_confi.sh
 ├── .env              (opcional, no subir a GitHub)
 ├── src/
 └── .devcontainer/
```

---

## 3. Archivo `.env` (opcional)

Formato recomendado:

```
AWS_ACCESS_KEY_ID=AKIAxxxxxx
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxx
AWS_REGION=us-east-1
```

Asegura agregar `.env` a tu `.gitignore`.

---

## 4. Cómo usar el script

1. Dar permisos:

```bash
chmod +x aws_confi.sh
```

2. Ejecutar:

```bash
./aws_confi.sh
```

3. Si `.env` existe: se cargan variables automáticamente  
   Si no existe: se piden al usuario

---

## 5. Validación de configuración

### Identidad:

```bash
aws sts get-caller-identity
```

### Configuración actual:

```bash
aws configure list
```

### Probar acceso a S3:

```bash
aws s3 ls
```

---

## 6. Buenas prácticas

- ❌ No subir `.env`  
- ❌ No pegar credenciales en scripts  
- ❌ No incluir claves en Dockerfile  

- ✔ Ejecutar siempre este script  
- ✔ Rotar credenciales si se exponen  
- ✔ Mantener claves privadas fuera del repositorio  

---

## 7. Troubleshooting

### “Unable to locate credentials”
Ejecutar:

```
./aws_confi.sh
```

### “InvalidAccessKeyId”
Clave mal escrita → crear nueva en IAM

### Región incorrecta
Ejecutar de nuevo el script

### El contenedor no reconoce claves al reiniciar
Rebuild del contenedor:

```
Dev Containers: Rebuild Container
```

---

## 8. Conclusión

Este script proporciona una forma estandarizada, segura y profesional para configurar credenciales AWS en Codespaces, ideal para estudiantes y entornos educativos.
