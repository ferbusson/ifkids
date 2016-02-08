SELECT
	d2.ndocumento,
	to_char(d2.fecha,'yy-MM-dd HH24:MI') AS fecha,
	CASE WHEN dd.tcredito > 0 THEN d2.codigo_tipo||d2.numero||' (T)' ELSE d2.codigo_tipo||d2.numero END AS numero,
	dd.valor
FROM
	documentos d1,
	documentos d2,
	datos_arqueo da,
	datos_documento dd
WHERE
	d1.ndocumento=da.narqueo AND
	da.ndocumento=d2.ndocumento AND
	d2.ndocumento=d2.ndocumento AND
	dd.ndocumento=d2.ndocumento AND
	d2.estado=FALSE AND
	d1.codigo_tipo='Q1' AND
	d1.numero=LPAD('2',10,'0')
ORDER BY
	d2.codigo_tipo,
	d2.ndocumento;