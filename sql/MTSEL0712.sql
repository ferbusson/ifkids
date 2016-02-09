DROP TABLE IF EXISTS tmp_mvaq;
CREATE TEMP TABLE tmp_mvaq AS
SELECT
	f.fecha,
	f.numero,
	f.cajero,
	total,
	pesos+(dolares*trm)+tcredito+tdebito+tregalo AS recaudo,
	ROUND((total-(pesos+(dolares*trm)+tcredito+tdebito+tregalo))::NUMERIC,2) AS diferencia,
	d.narqueo AS ndocumento
FROM	
	(SELECT
		da.narqueo,
		sum(debe) AS total
	FROM
		documentos d,
		datos_arqueo da,
		libro_auxiliar l,
		cuentas c
	WHERE
		d.ndocumento=da.ndocumento AND
		d.ndocumento=l.ndocumento AND
		c.id_cta=l.id_cta AND
		d.fecha::date>='2016-02-01' AND
		d.fecha::date<='2016-02-28' AND
		(c.char_cta like '11%' OR
		c.char_cta='281010')
	GROUP BY
		da.narqueo) AS d,
	(SELECT
		d.ndocumento,
		d.codigo_tipo||d.numero AS numero,
		d.fecha::date as fecha,
		g.nombre1||' '||g.apellido1 AS cajero,
		coalesce("50000",0)+coalesce("20000",0)+coalesce("10000",0)+coalesce("5000",0)+coalesce("2000",0)+coalesce("1000",0)+coalesce(monedas,0) AS pesos,
		coalesce("100",0)+coalesce("50",0)+coalesce("20",0)+coalesce("10",0)+coalesce("5",0)+coalesce("1",0)+coalesce(monedasd,0) AS dolares,
		trm,
		coalesce(tcredito,0) as tcredito,
		coalesce(tdebito,0) as tdebito,
		coalesce(tregalo,0) as tregalo
	FROM
		documentos d,
		efectivo e,
		info_documento i,
		general g
	WHERE
		i.ndocumento=d.ndocumento AND
		d.ndocumento=e.narqueo AND
		g.id=i.id_usuario) AS f
WHERE
	d.narqueo=f.ndocumento;


SELECT
	q.fecha,
	numero,
	cajero,
	total,
	recaudo,
	diferencia,
	CASE WHEN diferencia < 0 THEN 'Sobró' ELSE CASE WHEN diferencia > 0 THEN 'Faltó' ELSE 'Perfect!!!' END END AS estado,
	gtotal,
	'MTR00201' AS perfil,
	ndocumento
FROM
	tmp_mvaq AS q,
	(SELECT
		fecha,
		sum(total) AS gtotal
	FROM
		tmp_mvaq
	GROUP BY
		fecha) AS f
WHERE
	f.fecha=q.fecha;