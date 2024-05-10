Cantidad total de extintores por cada ubicación:

SELECT u.nombre AS ubicacion, COUNT(e.id) AS cantidad_extintores
FROM ubicaciones u
LEFT JOIN extintores e ON u.id = e.idubicacion
GROUP BY u.id;

Suma de las capacidades de todos los extintores por cada tipo de extintor:
SELECT t.nombre AS tipo_extintor, SUM(e.capacidad) AS suma_capacidades
FROM tipos t
LEFT JOIN extintores e ON t.id = e.idtipo
GROUP BY t.id;

Fecha de fabricación más reciente de cada tipo de extintor:
SELECT t.nombre AS tipo_extintor, MAX(e.fechafabricacion) AS fecha_mas_reciente
FROM tipos t
LEFT JOIN extintores e ON t.id = e.idtipo
GROUP BY t.id;

Número de inspecciones realizadas en cada extintor:
SELECT idextintor, COUNT(id) AS numero_inspecciones
FROM inspecciones
GROUP BY idextintor;

Suma de las capacidades de los extintores suministrados por cada proveedor en un rango de fechas:
SELECT p.nombre AS proveedor, SUM(e.capacidad) AS suma_capacidades
FROM proveedores p
LEFT JOIN extintores e ON p.id = e.idproveedor
WHERE e.fechafabricacion BETWEEN '2023-01-01' AND '2024-12-31'
GROUP BY p.id;

Cantidad de recargas realizadas en extintores de un tipo específico en ubicaciones que sean salas:
SELECT COUNT(r.id) AS cantidad_recargas
FROM recargas r
INNER JOIN extintores e ON r.idextintor = e.id
INNER JOIN ubicaciones u ON e.idubicacion = u.id
WHERE e.idtipo = 1 -- Cambia el ID del tipo de extintor específico
AND u.nombre LIKE 'Sala%'

Número de recargas realizadas en extintores cuya última inspección fue hace más de seis meses:
SELECT COUNT(r.id) AS cantidad_recargas
FROM recargas r
INNER JOIN inspecciones i ON r.idextintor = i.idextintor
WHERE DATEDIFF(CURDATE(), i.fecha) > 180

Cantidad de inspecciones realizadas en extintores que tienen al menos dos recargas en el último año:
SELECT COUNT(i.id) AS cantidad_inspecciones
FROM inspecciones i
INNER JOIN (
    SELECT idextintor
    FROM recargas
    WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    GROUP BY idextintor
    HAVING COUNT(id) >= 2
) AS r ON i.idextintor = r.idextintor

Promedio de las capacidades de los extintores que tienen más de tres recargas en total:

SELECT AVG(e.capacidad) AS promedio_capacidades
FROM extintores e
INNER JOIN (
    SELECT idextintor, COUNT(id) AS total_recargas
    FROM recargas
    GROUP BY idextintor
    HAVING total_recargas > 3
) AS r ON e.id = r.idextintor

Cantidad de recargas realizadas en extintores cuya fecha de última inspección está entre dos fechas específicas:
SELECT COUNT(r.id) AS cantidad_recargas
FROM recargas r
INNER JOIN inspecciones i ON r.idextintor = i.idextintor
WHERE i.fecha BETWEEN '2023-01-01' AND '2024-12-31'
