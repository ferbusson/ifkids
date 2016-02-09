SELECT
	r.id_tcredito,
	r.nom_suc,
	r.nombre,
	SUM(r.valor) AS valor,
	r.id_administracion_sucursales
FROM
	(SELECT
		ads.nombre AS nom_suc,
		CASE WHEN c.char_cta like '1105%' THEN
			'0' 
		ELSE
			CASE WHEN c.char_cta like '2810%' THEN
				'1' 
			ELSE
				tc.id_tcredito
		END END AS id_tcredito,
		CASE WHEN c.char_cta like '1105%' THEN
			'Efectivo' 
		ELSE
			CASE WHEN c.char_cta like '2810%' THEN
				'Anticipos' 
			ELSE
				tc.nombre
		END END AS nombre,
		SUM(debe) AS valor,
		ads.id_administracion_sucursales
	FROM
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
			d.estado) AS foo,
		documentos d,
		documentos_sucursales ds,
		administracion_sucursales ads,
		cuentas c,
		info_documento i,
		libro_auxiliar l
	LEFT OUTER JOIN
		tarjetas t
	ON
		t.ndocumento=l.ndocumento
	LEFT OUTER JOIN
		tcredito tc
	ON
		t.id_tcredito=tc.id_tcredito
	WHERE
		d.codigo_tipo = ds.codigo_tipo AND
		ds.id_administracion_sucursales = ads.id_administracion_sucursales AND
		i.ndocumento = l.ndocumento AND
		l.fecha::DATE > '2013-01-01' AND
		c.id_cta=l.id_cta AND
		(c.char_cta like '11%' OR
		c.char_cta like '1305%' OR
		c.char_cta like '2810%') AND
		d.codigo_tipo NOT IN (SELECT codigo_tipo FROM tipo_documento WHERE codigo_tipo LIKE 'Q%') AND
		(d.codigo_tipo LIKE 'F%' OR
		d.codigo_tipo LIKE 'S%' OR
		d.codigo_tipo LIKE 'A%' OR
		d.codigo_tipo LIKE 'C%' OR
		d.codigo_tipo LIKE 'T%' OR
		d.codigo_tipo LIKE 'S%' OR		
		d.codigo_tipo = 'CN' OR	
		d.codigo_tipo = 'CI') AND
		l.ndocumento=foo.ndocumento AND
		d.ndocumento=foo.ndocumento
	GROUP BY
		ads.nombre,
		d.ndocumento,
		tc.id_tcredito,
		tc.nombre,
		c.char_cta,
		ads.id_administracion_sucursales) AS r
GROUP BY
	r.nom_suc,
	r.id_tcredito,
	r.nombre,
	r.id_administracion_sucursales
ORDER BY
	id_administracion_sucursales,
	nombre;