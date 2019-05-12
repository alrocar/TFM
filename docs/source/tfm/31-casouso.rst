.. _casouso:

Espías en el cielo: Analizando con CARTO datos de vuelos almacenados en BigQuery
================================================================================

Un periodista quiere realizar una investigación sobre vuelos de vigilancia realizados en Estados Unidos, concretamente en la costa oeste, por parte del FBI, durante el último mes.

Para ello, tiene a su disposición un dataset de FlightRadar24 [#f1]_. FlightRadar24 es un servicio que permite a miles de colaboradores, subir datos de vuelos en tiempo real, utilizando el Sistema de Vigilancia Dependiente Automática (ADS-B), un sistema obligatorio para aviones que vuelan el espacio aéreo de Estados Unidos.

El sistema ADS-B, emite periódicamente la posición de un avión, obtenida a través de la navegación por satélite. Junto a la posición (longitud, latitud) se adjuntan algunos metadatos como son:

- `flight_id`: ID del vuelo en cuestión, que permite cruzarlo con datos provenientes de aerolíneas comerciales, por ejemplo.
- `timestamp`: `epoch` en el que se emitió la posición.
- `altitude`: Altitud en metros
- `speed`: Velocidad en millas por hora.

El tamaño de la información recogida por FlightRadar24 es del orden de `petabytes` y está en contínuo aumento. Actualmente, ofrece un servicio de suscripción a través de Google BigQuery, de manera que terceras partes pueden acceder a la información tanto en tiempo real como histórica a través de una cuenta de Google.

El objetivo del periodista, es poner a disposición del público general de una investigación, que incluya una herramienta visual (en este caso un mapa) que permita demostrar que estos vuelos de vigilancia se están produciendo. El mapa estará siempre actualizado con datos de los últimos 30 días y será interactivo, siendo posible efectuar filtros, sobre determinadas áreas geográficas o por identificador de vuelo.

TODO -> completar workflow

.. [#f1] https://www.flightradar24.com/60,15/6 - mayo 2019