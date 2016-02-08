DROP TABLE IF EXISTS aq;
CREATE TEMP TABLE aq AS
SELECT 
	'?'::CHARACTER(2) as tipo,
	CAST(LPAD('?',10,'0') AS character(10)) AS numero;

-- EFECTIVO
SELECT	
	'Efectivo Recaudado',
	sum(l.debe-l.haber),
	sum(l.debe-l.haber)
FROM
	libro_auxiliar l,
	cuentas c,
	documentos d,
	documentos d2,
	datos_arqueo da,
	aq
WHERE
	l.id_cta=c.id_cta AND
	c.char_cta='11050501' AND
	d.ndocumento=l.ndocumento AND
	d.ndocumento=da.ndocumento AND
	d.codigo_tipo NOT IN(SELECT codigo_tipo FROM documentos_sucursales WHERE codigo_tipo ILIKE 'Q%') AND
	da.narqueo=d2.ndocumento AND
	d.estado AND
	d2.codigo_tipo = aq.tipo AND
	d2.numero=aq.numero
UNION
-- CHEQUES
SELECT	
	'Cheques',
	sum(l.debe-l.haber),
	sum(l.debe-l.haber)
FROM
	libro_auxiliar l,
	cuentas c,
	documentos d,
	documentos d2,
	datos_arqueo da,
	aq
WHERE
	l.id_cta=c.id_cta AND
	c.char_cta='110520' AND
	d.ndocumento=l.ndocumento AND
	d.ndocumento=da.ndocumento AND
	d.codigo_tipo NOT IN(SELECT codigo_tipo FROM documentos_sucursales ds, aq WHERE codigo_tipo = ('Q'::CHARACTER(1)||SUBSTRING(aq.tipo,2))::CHARACTER(2)) AND
	da.narqueo=d2.ndocumento AND
	d.estado AND
	d2.codigo_tipo = aq.tipo AND
	d2.numero=aq.numero
UNION
SELECT	
	'Abono Anterior',
	sum(l.debe),
	0
FROM
	libro_auxiliar l,
	cuentas c,
	documentos d,
	documentos d2,
	datos_arqueo da,
	aq
WHERE
	l.id_cta=c.id_cta AND
	(c.char_cta='238005') AND
	d.ndocumento=l.ndocumento AND
	d.ndocumento=da.ndocumento AND
	d.codigo_tipo NOT IN(SELECT codigo_tipo FROM documentos_sucursales WHERE codigo_tipo ILIKE 'Q%') AND
	d.estado AND
	da.narqueo=d2.ndocumento AND
	d2.codigo_tipo = aq.tipo AND
	d2.numero=aq.numero
HAVING
	sum(l.debe)!=0
UNION
SELECT	
	'Facturacion Credito',
	sum(l.debe),
	0
FROM
	libro_auxiliar l,
	cuentas c,
	documentos d,
	documentos d2,
	datos_arqueo da,
	aq
WHERE
	l.id_cta=c.id_cta AND
	c.char_cta='130505' AND
	d.ndocumento=l.ndocumento AND
	d.ndocumento=da.ndocumento AND
	d.codigo_tipo IN(SELECT codigo_tipo FROM documentos_sucursales WHERE codigo_tipo ILIKE 'F%' OR codigo_tipo ILIKE 'C%') AND
	--(d.codigo_tipo='FA' OR d.codigo_tipo='CA' OR d.codigo_tipo='FC') AND
	da.narqueo=d2.ndocumento AND
	d.estado AND
	d2.codigo_tipo = aq.tipo AND
	d2.numero=aq.numero
HAVING
	sum(l.debe)!=0
UNION
SELECT	
	tc.nombre,
	sum(t.valor),
	0
FROM
	tarjetas t,
	tcredito tc,
	documentos d,
	documentos d2,
	datos_arqueo da,
	aq
WHERE
	d.ndocumento=t.ndocumento AND
	t.id_tcredito=tc.id_tcredito AND
	d.ndocumento=da.ndocumento AND
	d.codigo_tipo IN
		(SELECT 
			codigo_tipo 
		FROM 
			documentos_sucursales 
		WHERE 
			codigo_tipo ILIKE 'F%' OR --FACTURACION
			codigo_tipo ILIKE 'C%' OR --CAMBIOS
			codigo_tipo ILIKE 'S%' OR --SEPARADOS
			codigo_tipo ILIKE 'CI' OR --COMP INGRESO
			codigo_tipo ILIKE 'A%') AND --ABONOS SEP
	--(d.codigo_tipo='FA' OR
	--d.codigo_tipo='SP' OR
-- 	d.codigo_tipo='CI' OR
-- 	d.codigo_tipo='AR' OR
-- 	d.codigo_tipo='CA' OR
-- 	d.codigo_tipo='FM') AND
	d.estado AND
	da.narqueo=d2.ndocumento AND
	d2.codigo_tipo = aq.tipo AND
	d2.numero=aq.numero 
GROUP BY
	tc.nombre
HAVING
	sum(t.valor)!=0
UNION
-- INGRESO POR TARJETA REGALO
SELECT	
	'Tarjetas Regalo Redimidas',
	sum(COALESCE(l.debe,0)-COALESCE(l.haber,0)),
	0
FROM
	libro_auxiliar l,
	cuentas c,
	documentos d,
	documentos d2,
	datos_arqueo da,
	aq
WHERE
	l.id_cta=c.id_cta AND
	c.char_cta='280520' AND
	d.ndocumento=l.ndocumento AND
	d.ndocumento=da.ndocumento AND
	d.codigo_tipo NOT IN(SELECT codigo_tipo FROM documentos_sucursales WHERE codigo_tipo ILIKE 'Q%') AND
	--d.codigo_tipo!='AQ' AND
	da.narqueo=d2.ndocumento AND
	d.estado AND
	d2.codigo_tipo = aq.tipo AND
	--d2.codigo_tipo='AQ' AND
	d2.numero=aq.numero;