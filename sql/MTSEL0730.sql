SELECT	
	id_char,
	ads.nombre,
        COALESCE(nombre1,'')||' '||COALESCE(apellido1,'')AS vendedor,
        SUM(l.debe) AS total,
        ads.id_administracion_sucursales
FROM
	administracion_sucursales ads,
	documentos_sucursales ds,
        documentos d, 
        general g,
        libro_auxiliar l, 
        info_documento i,
        cuentas c,
	(SELECT
		d.ndocumento
	FROM
		documentos d
	WHERE
		d.estado
	EXCEPT
	SELECT
		da.ndocumento
	FROM
		datos_arqueo da,
		documentos d
	WHERE
		d.codigo_tipo IN (SELECT codigo_tipo FROM tipo_documento WHERE codigo_tipo LIKE 'Q%') AND
		da.narqueo=d.ndocumento AND
		d.estado
		) AS foo
WHERE
	ds.id_administracion_sucursales = ads.id_administracion_sucursales AND
	ds.codigo_tipo = d.codigo_tipo AND
        d.ndocumento=l.ndocumento AND
        d.fecha::date > '2013-01-01' AND
        l.id_cta = c.id_cta AND
	(c.char_cta like '11%' OR
	c.char_cta='281010') AND
        d.ndocumento=i.ndocumento AND
        d.estado=true AND
        i.id_usuario = g.id AND
	d.codigo_tipo NOT IN (SELECT codigo_tipo FROM tipo_documento WHERE codigo_tipo LIKE 'Q%') AND
	(d.codigo_tipo LIKE 'F%' OR
	d.codigo_tipo LIKE 'S%' OR
	d.codigo_tipo LIKE 'A%' OR
	d.codigo_tipo = 'CI' OR
	d.codigo_tipo LIKE 'C%' OR
	d.codigo_tipo LIKE 'T%' OR
	d.codigo_tipo = 'CN') AND
        d.ndocumento=foo.ndocumento
GROUP BY
	ads.nombre,
	id_char,
	COALESCE(nombre1,'')||' '||COALESCE(apellido1,''),
	ads.id_administracion_sucursales
ORDER BY
	ads.id_administracion_sucursales;
