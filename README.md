# Rick and Morty App

## Descripción del Proyecto

Esta aplicación móvil en Flutter consume la API pública de Rick and Morty para mostrar una lista de personajes, episodios y ubicaciones. Implementa Clean Architecture con BLoC (usando Cubits) para una gestión eficiente del estado. Además, utiliza Dio para el manejo de la API y SharedPreferences para la persistencia de datos.

## Instrucciones de Instalación y Ejecución

### Requisitos Previos

- Tener instalado Flutter y Dart en su sistema.
- Tener configurado un emulador o un dispositivo físico.
- Contar con conexión a internet para realizar las peticiones a la API.

### Pasos para Ejecutar la Aplicación

1. **Clonar el repositorio**:
   ```sh
   git clone <URL_DEL_REPOSITORIO>
   ```
2. **Moverse al directorio del proyecto**:
   ```sh
   cd rick_and_morty_app
   ```
3. **Instalar las dependencias**:
   ```sh
   flutter pub get
   ```
4. **Ejecutar la aplicación**:
   ```sh
   flutter run
   ```

## Estructura del Proyecto

La aplicación sigue el principio de **Clean Architecture**, dividiendo la lógica en capas:

- **core**: Contiene configuraciones globales, como la gestión de red y casos de uso reutilizables.
- **data**:
  - `datasources`: Implementaciones remotas de la API.
  - `models`: Modelos de datos que representan las respuestas de la API.
  - `repositories`: Implementaciones de los repositorios.
- **domain**:
  - `entities`: Modelos de dominio que encapsulan las reglas de negocio.
  - `repositories`: Interfaces de los repositorios para la inyección de dependencias.
- **presentation**:
  - `bloc/cubits`: Gestión del estado utilizando BLoC con Cubits.
  - `pages`: Pantallas de la aplicación.
  - `widgets`: Componentes reutilizables.

## Decisiones Técnicas

1. **Arquitectura**: Se utilizó Clean Architecture para lograr una mayor escalabilidad y separación de responsabilidades.
2. **Gestión del Estado**: Se implementó BLoC con Cubits para un manejo eficiente y estructurado del estado.
3. **Consumo de API**: Se empleó Dio para realizar peticiones HTTP, junto con interceptores para manejo de logs y errores.
4. **Persistencia de Datos**: Se optó por SharedPreferences para almacenar la última búsqueda exitosa y la lista de favoritos.
5. **Optimización de Widgets**:
   - Se crearon widgets genéricos y personalizados para reutilizarlos de manera eficiente y mejorar la estructura del código.

## Posibles Mejoras

1. **Refactorizar la página de Home (**``**)** para mejorar su estructura y legibilidad.
2. **Implementar caching avanzado** con Hive o Isar en lugar de SharedPreferences para una persistencia más eficiente.
3. **Manejo de errores más robusto**, implementando retry automático en fallos de conexión.
4. **Optimización de UI** agregando animaciones y transiciones para mejorar la experiencia de usuario.
5. **Soporte para modo offline** almacenando datos previamente obtenidos para su consulta sin conexión.

## Autor

Luis Alejandro Sanmiguel Galeano.

## Enlaces de Referencia

- [API de Rick and Morty](https://rickandmortyapi.com/)

