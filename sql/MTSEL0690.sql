SELECT
	d.codigo_tipo
FROM 
	administracion_sucursales a,
	documentos_sucursales d
WHERE
	a.id_administracion_sucursales = d.id_administracion_sucursales AND
	d.codigo_tipo ILIKE 'S%' AND
	a.nombre = '?';