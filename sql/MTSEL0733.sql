SELECT
	LTRIM(g.nombre1||' '||g.nombre2||' '||g.apellido1||' '||g.apellido2||' '||g.razon_social,' ') AS nombre,
	i.sigla,
	i.fecha_iniciacion,
        g.id,
        foo.id_administracion_sucursales
FROM
	general g,
	info_empleado i,
	(SELECT
		'?'::CHARACTER(14) AS id_char,
		'?'::INTEGER AS id_administracion_sucursales) AS foo
WHERE
	g.id_char = foo.id_char AND
	g.id = i.id;