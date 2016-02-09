DROP TABLE IF EXISTS tmp_args;
CREATE TEMP TABLE tmp_args AS
SELECT
	'?'::DATE AS fechai,
	'?'::DATE AS fechaf;


DROP TABLE IF EXISTS tarqueo_efectivo;
CREATE TEMP TABLE tarqueo_efectivo AS
SELECT
	da.narqueo,
	sum(debe) AS total
FROM
	documentos d,
	datos_arqueo da,
	libro_auxiliar l,
	cuentas c,
	tmp_args t
WHERE
	d.ndocumento=da.ndocumento AND
	d.ndocumento=l.ndocumento AND
	c.id_cta=l.id_cta AND
	d.fecha::date>=t.fechai AND
	d.fecha::date<=t.fechaf AND
	c.char_cta like '1105%'
GROUP BY
	da.narqueo;

DROP TABLE IF EXISTS tarqueo_tarjetas;
CREATE TEMP TABLE tarqueo_tarjetas AS
SELECT
	da.narqueo,
	sum(debe) AS total
FROM
	documentos d,
	datos_arqueo da,
	libro_auxiliar l,
	cuentas c,
	tmp_args t
WHERE
	d.ndocumento=da.ndocumento AND
	d.ndocumento=l.ndocumento AND
	c.id_cta=l.id_cta AND
	d.fecha::date>=t.fechai AND
	d.fecha::date<=t.fechaf AND
	(c.char_cta like '1110%' OR
	c.char_cta='281010')
GROUP BY
	da.narqueo;

DROP TABLE IF EXISTS tarqueo_egresos;
CREATE TEMP TABLE tarqueo_egresos AS
SELECT
	da.narqueo,
	sum(haber) AS total
FROM
	documentos d,
	datos_arqueo da,
	libro_auxiliar l,
	cuentas c,
	tmp_args t
WHERE
	d.ndocumento=da.ndocumento AND
	d.ndocumento=l.ndocumento AND
	c.id_cta=l.id_cta AND
	d.fecha::date>=t.fechai AND
	d.fecha::date<=t.fechaf AND
	c.char_cta like '1105%'
GROUP BY
	da.narqueo;


DROP TABLE IF EXISTS tarqueo_recaudo;
CREATE TEMP TABLE tarqueo_recaudo AS
SELECT
	d.ndocumento AS narqueo,
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
	g.id=i.id_usuario;
	
DROP TABLE IF EXISTS tmp_mvaq;
CREATE TEMP TABLE tmp_mvaq AS
SELECT
	r.fecha,
	r.numero,
	r.cajero,
	e.total-te.total AS total_efectivo,
	t.total AS total_tarjetas,
	te.total AS total_egresos,
	pesos+(dolares*trm)+tcredito+tdebito+tregalo AS recaudo,
	ROUND(((e.total-te.total)-(pesos+(dolares*trm)+tcredito+tdebito+tregalo))::NUMERIC,2) AS diferencia,
	r.narqueo
FROM	
	tarqueo_recaudo r
LEFT OUTER JOIN
	tarqueo_efectivo e
ON
	r.narqueo = e.narqueo
LEFT OUTER JOIN
	tarqueo_tarjetas t
ON
	r.narqueo = t.narqueo
LEFT OUTER JOIN
	tarqueo_egresos te
ON
	r.narqueo = te.narqueo;


SELECT
	q.fecha,
	numero,
	cajero,
	total_tarjetas,
	total_efectivo,
	recaudo,
	diferencia,
	CASE WHEN diferencia < 0 THEN 'Sobró' ELSE CASE WHEN diferencia > 0 THEN 'Faltó' ELSE 'Perfect!!!' END END AS estado,
	gtotal,
	'MTR00202' AS perfil,
	narqueo
FROM
	tmp_mvaq AS q,
	(SELECT
		fecha,
		sum(total_efectivo+total_tarjetas-total_egresos) AS gtotal
	FROM
		tmp_mvaq
	GROUP BY
		fecha) AS f
WHERE
	f.fecha=q.fecha;