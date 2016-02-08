SELECT
	d2.ndocumento,
	to_char(d2.fecha,'yy-MM-dd HH24:MI') AS fecha,
	CASE WHEN dd.tcredito > 0 THEN d2.codigo_tipo||d2.numero||' (T)' ELSE d2.codigo_tipo||d2.numero END AS numero,
	COALESCE(dd.valor,0) AS valor
FROM
	documentos d1,
	documentos d2,
	datos_arqueo da,
	datos_documento dd,
	documentos_sucursales ds1,
	documentos_sucursales ds2,
	tipo_documento td
WHERE
	d1.codigo_tipo = ds1.codigo_tipo AND
	ds1.id_administracion_sucursales = ds2.id_administracion_sucursales AND
	td.descripcion ILIKE '%abonos%' AND
	(ds2.codigo_tipo = d2.codigo_tipo OR
	 d2.codigo_tipo = 'CI') AND
	ds2.codigo_tipo = td.codigo_tipo AND
	d1.ndocumento=da.narqueo AND
	da.ndocumento=d2.ndocumento AND
	d2.ndocumento=d2.ndocumento AND
	dd.ndocumento=d2.ndocumento AND
	d2.estado=true AND
	--(d2.codigo_tipo='FA' OR
	 --d2.codigo_tipo='FM') AND
	dd.efectivo IS NOT NULL AND
	(dd.efectivo > 0 OR dd.tcredito>0) AND
	d1.codigo_tipo='?' AND
	d1.numero=LPAD('?',10,'0')
ORDER BY
	d2.codigo_tipo,
	d2.numero;