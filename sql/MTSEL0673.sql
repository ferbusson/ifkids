SELECT
	u.login,
	LTRIM('Usuario: '||u.login||' / '||g.id_char||' - '||g.nombre1||' '||g.nombre2||' '||g.apellido1||' '||g.apellido2||' '||g.razon_social,' ')
FROM
	general g,
	usuarios u
WHERE
	g.id = u.id_usuario AND
	u.login||' '||g.id_char||' '||g.nombre1||' '||g.nombre2||' '||g.apellido1||' '||g.apellido2||' '||g.razon_social ILIKE '%?%'
ORDER BY
	g.nombre1||' '||g.nombre2||' '||g.apellido1||' '||g.apellido2||' '||g.razon_social;