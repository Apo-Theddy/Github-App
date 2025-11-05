# Github App

f## que es esto

una app para manejar tus repos de github desde el celular sin complicarte la vida ni abrir el navegador

### que hace

- ver los repos mas populares del dia, semana o mes
- buscar repos de cualquier usuario por nombre
- guardar tus repos favoritos
- quitar favoritos cuando quieras
- ver tus favoritos sin internet
- ver detalles completos: readme, estrellas, forks, issues, pull requests, lenguajes, colaboradores
- ver perfiles de usuarios: bio, seguidores, seguidos, contribuciones, repos publicos

---

### tecnologias

| herramienta            | para que sirve                   |
| ---------------------- | -------------------------------- |
| flutter                | base multiplataforma android ios |
| dart                   | lenguaje de programacion         |
| flutter bloc           | manejo de estado reactivo        |
| github api             | obtener datos en tiempo real     |
| hive                   | base de datos local rapida       |
| dio                    | cliente http con cache           |
| equatable              | comparacion de objetos           |
| getit                  | inyeccion de dependencias        |
| go router              | navegacion entre pantallas       |
| json serializable      | generacion automatica de modelos |
| cached network image   | cache de imagenes                |
| flutter launcher icons | iconos para las tiendas          |
| flutter svg            | iconos vectoriales               |

---

### requisitos

- flutter instalado (o fvm para manejar versiones)
- version de flutter usada: 3.35.4
- version de dart 3.9.2
- emulador o celular fisico
- conexion a internet para consumir la api
- apk disponible en la carpeta apk/ para instalar directo en android

---

### arquitectura

clean architecture con capas separadas para mantener todo ordenado

```bash
lib/
├── core/             → errores, constantes, extensiones
├── shared/           → componentes compartidos entre features
└── features/         → features de la app
      └── repos/       → feature principal
            ├── data/     → implementacion especifica de la feature
            ├── domain/   → entidades, casos de uso, repos abstractos
            └── presentation/ → ui especifica de la feature
                  ├── widgets/     → componentes ui
                  ├── pages/       → pantallas
                  └── bloc/        → gestion de estado

└── main.dart         → punto de entrada
└── app.dart          → configuracion de la app
```

---

### patrones de diseno

| patron         | como se usa                       |
| -------------- | --------------------------------- |
| inyeccion deps | getit para acceso global          |
| repository     | capa data implementa domain       |
| bloc           | flutter bloc para flujos de datos |
| singleton      | servicios que viven toda la app   |
| factory        | crear instancias segun el caso    |

---

### por que clean architecture

al principio parece complicado pero tiene sus ventajas

- cambias una parte y el resto sigue funcionando
- agregar features nuevas sin romper lo que ya esta
- hacer tests de casos de uso sin depender de la interfaz
- la interfaz no sabe nada de api ni base de datos
- si github cambia su api solo tocas la capa de data
- equipos grandes pueden trabajar cada uno en su capa
- bugs mas faciles de encontrar
- integracion continua mas estable
- codigo mas limpio y rapido de entender

en pocas palabras: proyecto profesional, facil de mantener y listo para escalar

---

## como ejecutar

```bash
# clonar el repo
git clone https://github.com/Apo-Theddy/Github-App.git

# entrar al proyecto
cd Github-App

# instalar dependencias
flutter pub get

# generar codigo si es necesario
flutter pub run build_runner build --delete-conflicting-outputs

# ejecutar la app
flutter run
```

---

## Autor: Apo Theddy

- github: github.com/Apo-Theddy
- linkedin: https://www.linkedin.com/in/juan-esquives-579397239/
- email: jesquivesza@gmail.com
- contacto: +51 960 710 852
