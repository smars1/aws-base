# Guia Completa para Calcular CIDR, Subnets y Direcciones IP

## 1. Introduccion
CIDR (Classless Inter-Domain Routing) es el metodo moderno para representar redes IP. Permite definir cuantas direcciones IP tiene una red, como dividir una red grande en subredes, y como calcular rangos IP validos.

Este documento explica CIDR desde cero, usando ejemplos simples y tablas claras para estudiantes sin experiencia previa.

---

## 2. Formato CIDR
Un CIDR tiene el formato:

```
<direccion IP>/<prefijo>
```

Ejemplo:

```
10.0.0.0/24
```

El numero despues de la diagonal (/) indica cuantos bits pertenecen a la parte de red.

---

## 3. Formula para saber cuantas IPs tiene un CIDR

La formula es:

```
2^(32 - prefijo_CIDR)
```

Ejemplos:

| CIDR | Calculo | IPs totales |
|------|---------|--------------|
| /24 | 2^(32-24) = 2^8 | 256 |
| /25 | 2^(32-25) = 2^7 | 128 |
| /26 | 2^(32-26) = 2^6 | 64 |
| /27 | 2^(32-27) = 2^5 | 32 |

---

## 4. Tabla rapida de CIDR

| CIDR | IPs totales | IPs usables en AWS |
|------|-------------|--------------------|
| /16 | 65536 | 65531 |
| /20 | 4096 | 4091 |
| /24 | 256 | 251 |
| /25 | 128 | 123 |
| /26 | 64 | 59 |
| /27 | 32 | 27 |
| /28 | 16 | 11 |
| /29 | 8 | 3 |

AWS reserva 5 direcciones de cada subnet.

---

## 5. Como dividir una red en subnets (Subnetting)

Ejemplo:

### VPC:
```
10.0.0.0/24
```

Queremos dividirla en 2 subnets del mismo tamano.

Una /24 tiene 256 IPs.

Para dividirla en 2 subnets:

```
256 / 2 = 128 IPs por subnet
```

128 IPs corresponde a un **/25**.

### Resultado:

| Subnet | CIDR |
|--------|------|
| Subnet 1 | 10.0.0.0/25 |
| Subnet 2 | 10.0.0.128/25 |

---

## 6. Como calcular el siguiente bloque CIDR

Formula:

```
tamaño_bloque = 2^(32 - CIDR)
```

Ejemplo:

CIDR: 10.0.0.0/26  
Tamaño:

```
2^(32 - 26) = 64 IPs
```

Bloques:

- 10.0.0.0
- 10.0.0.64
- 10.0.0.128
- 10.0.0.192

---

## 7. Ejemplos practicos

### Ejemplo 1
Red: 192.168.1.0/24  
Quiero 4 subnets:

/24 → 256 IPs  
4 subnets → 256 / 4 = 64 IPs  
64 IPs → /26

Resultado:

| Subnet | CIDR |
|--------|------|
| A | 192.168.1.0/26 |
| B | 192.168.1.64/26 |
| C | 192.168.1.128/26 |
| D | 192.168.1.192/26 |

---

## 8. Ejercicios para alumnos

### Ejercicio 1
Dada la red `10.10.0.0/24`, crea 4 subnets iguales.

### Ejercicio 2
Dada la subnet `172.31.0.0/20`, calcula cuantas IPs tiene.

### Ejercicio 3
Cual es el siguiente bloque despues de `10.0.5.0/27`?

---

## 9. Respuestas

### Ejercicio 1
Una /24 → 256 IPs  
4 subnets → 64 IPs → /26  

- 10.10.0.0/26  
- 10.10.0.64/26  
- 10.10.0.128/26  
- 10.10.0.192/26  

### Ejercicio 2
/20 = 2^(32-20) = 4096 IPs totales.

### Ejercicio 3
/27 = 32 IPs  
Siguiente bloque:  
10.0.5.0 + 32 = 10.0.5.32/27

---

## 10. Conclusiones

- CIDR define el tamano de una red.  
- El prefijo indica cuantos bits son de red.  
- Puedes dividir redes calculando tamanos de bloque.  
- AWS reserva 5 IPs por subnet.  
- Subnetting permite planificar redes limpias y organizadas.

---

Fin del archivo.
