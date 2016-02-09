SELECT
	COALESCE("50000",0)+COALESCE("20000",0)+COALESCE("10000",0)+COALESCE("5000",0)+COALESCE("2000",0)+COALESCE("1000",0)+COALESCE(monedas,0)+(COALESCE(dolares,0)*COALESCE(trm,0))
FROM
	efectivo e,
	documentos d
WHERE
	d.ndocumento = '?' AND
	d.ndocumento=e.narqueo;