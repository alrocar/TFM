Introducción
============

Contexto
--------

*CARTO* [#f1]_ es una plataforma de :ref:`location-intelligence` que permite resolver problemas geoespaciales con los mejores datos y análisis.

Actualmente, las organizaciones que utilizan *CARTO* como herramienta de análisis geoespacial tienen multitud de fuentes de información y aplicaciones ya instaladas que generan continuamente nuevos datos.

El principal valor de *CARTO* para estas organizaciones es el de conectarse con esas fuentes de información (datos de :ref:`crm`, :ref:`erp`, hojas de cálculo, archivos con contenido geoespacial, bases de datos relacionales, etc.) a través de una interfaz sencilla e intuitiva, para generar nueva información de valor añadido para su negocio mediante análisis geoespaciales y visualizaciones.

En determinadas organizaciones, especialmente de tamaño medio o grande, ocurre que diversos equipos gestionan sus datos con sistemas de información heterogéneos que utilizan repositorios de datos tales como:

* Hojas de cálculo y archivos CSV (valores separados por comas)
* Documentos de Google Drive [#f2]_
* CRMs tales como Salesforce [#f3]_
* Herramientas de marketing digital como Mailchimp [#f4]_
* Servidores de datos geoespaciales como ArcGIS [#f5]_
* Bases de datos operacionales (relacionales o :ref:`nosql`)
* Sistemas de ficheros distribuidos :ref:`hdfs`
* Otros sistemas (Twitter [#f6]_, Dropbox [#f7]_, etc.)

Definición del problema
-----------------------

Estas organizaciones utilizan *CARTO* para importar sus datos y analizar la información que generan los distintos departamentos de manera conjunta, respondiendo a sus preguntas de negocio y encontrando además respuesta a otras preguntas que no se habían planteado en un principio.

*CARTO* ofrece un flujo de trabajo formado por cinco pasos:

1. Ingestión de datos: Consiste en llevar los datos de negocio, provenientes de distintas fuentes a la plataforma.
2. Enriquecimiento de los datos: CARTO cuenta con un catálogo de datos previamente analizados y curados de diferente tipología (demográficos, económicos, movilidad, puntos de interés, ...) que son clave para añadir nueva información a los datos de negocio y relacionar variables para buscar respuesta a preguntas complejas tales como: ¿de dónde vienen los visitantes de mis tiendas físicas? ¿cuál es su perfil demográfico? ¿cuál es su poder adquisitivo? etc.
3. Análisis: APIs y soluciones orientadas al análisis espacial
4. Soluciones y visualización: Librerías, SDKs, APIs y herramientas específicas que permiten crear soluciones y exponer de manera visual los resultados obtenidos en los análisis
5. Integraciones: Otros flujos para dar salida a los resultados obtenidos hacia la plataforma del cliente.

![](../_static/flujo.png)

*CARTO* cuenta con la posibilidad de importar datos desde diversas fuentes de datos, pero carece de soporte nativo para conectar a muchos de estos sistemas de almacenamiento Big Data usados generalmente para almacenar datos operacionales o secuencias de datos temporales.

Objetivo
--------

El objetivo de este trabajo final de máster, está centrado en la primera fase del flujo de trabajo descrito previamente la ingestión de datos. Más concretamente, consiste en el desarrollo de conectores para *CARTO* que permitan incluir en los cuadros de mandos (:ref:`dashboard`), información proveniente de los siguientes sistemas de almacenamiento y/o procesamiento Big Data.

![](../_static/flujo01.png)

El objetivo es encontrar un mecanismo fácilmente reproducible que permita en el futuro integrar otros sistemas de almacenamiento. Para el actual trabajo, el objetivo consiste en integrar al menos:

- Google BigQuery

Y describir un proceso que permitiera la integración de otros sistemas tales como:

- Apache Hive
- Impala
- MongoDB
- Amazon Redshift
- Cassandra
- SparkSQL
- Amazon Aurora
- Oracle

Los "conectores Big Data para *CARTO*" permitirán a las organizaciones mantener sus actuales flujos de ingestión y procesamiento de información, además de aprovechar lo mejor de dos mundos: el almacenamiento y procesamiento distribuido que ofrecen algunas de estas herramientas orientadas a Big Data y la visualiación y análisis geoespacial de *CARTO*.

Cabe destacar que los resultados de este trabajo no son de carácter teórico, sino que consiste en código fuente y herramientas que se incluirán en la distribución :ref:`on-premise` de *CARTO*

Organización de este trabajo final de máster
--------------------------------------------

Este trabajo final de máster está organizado en capítulos, siguiendo la siguiente estructura:

1. :ref:`estado-del-arte`: Se repasan las herramientas de almacenamiento y procesamiento Big Data con las que se va a trabajar y se definen algunos de los conceptos teóricos que sirven de fundamentación para el trabajo.
2. :ref:`metodologia`: Definición de una metodología de trabajo sistemática y desglose en tareas del trabajo a realizar.
3. :ref:`desarrollo`: Descripción de la implementación de cada uno de los conectores, demostración de uso, etc.
4. :ref:`conclusiones`
5. :ref:`bibliografia`
6. :ref:`anexos`
7. :ref:`glosario`


Palabras clave: *BASH, Docker, Vagrant, Location Intelligence, AWS, HDFS, Hadoop, BigQuery, Hive, Impala, Spark, NoSQL, Cassandra, MongoDB, CARTO, dashboards, análisis geoespacial*

.. [#f1] https://www.carto.com - mayo 2019
.. [#f2] https://drive.google.com - mayo 2019
.. [#f3] https://www.salesforce.com - mayo 2019
.. [#f4] https://mailchimp.com - mayo 2019
.. [#f5] https://www.arcgis.com - mayo 2019
.. [#f6] https://www.twitter.com - mayo 2019
.. [#f7] https://www.dropbox.com - mayo 2019
