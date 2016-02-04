SELECT
	trm
FROM
	documentos d,
	datos_documento dd
WHERE
	d.ndocumento = dd.ndocumento AND
	d.codigo_tipo = '?' AND
	d.numero = LPAD('?',10,'0');