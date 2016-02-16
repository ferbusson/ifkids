SELECT
	g.id_char,
	LTRIM('Sigla: '||i.sigla||' / '||g.id_char||' - '||g.nombre1||' '||g.nombre2||' '||g.apellido1||' '||g.apellido2||' '||g.razon_social,' ')
FROM
	general g,
	info_empleado i
WHERE
	g.id = i.id AND
	i.sigla||' '||g.id_char||' '||g.nombre1||' '||g.nombre2||' '||g.apellido1||' '||g.apellido2||' '||g.razon_social ILIKE '%%'
ORDER BY
	g.nombre1||' '||g.nombre2||' '||g.apellido1||' '||g.apellido2||' '||g.razon_social;