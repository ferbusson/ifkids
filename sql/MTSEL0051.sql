DROP TABLE IF EXISTS info_args;
CREATE TEMP TABLE info_args AS
SELECT
	'?'::CHARACTER VARYING AS nombre_suc,
	'?'::INTEGER AS id_bodega,
	'?'::CHARACTER(13) AS codigo;
	
DROP TABLE IF EXISTS sdo;
CREATE TEMP TABLE sdo AS
SELECT
	p.id_prod_serv,
	p.sdo_mt,
	COALESCE(sp.sdo,0) AS sdo_sp
FROM
	(SELECT
		p.id_prod_serv,
		COALESCE(mt.sdo,0) AS sdo_mt
	FROM
		prod_serv p 
	LEFT OUTER JOIN
		(SELECT 
			id_prod_serv,
			COALESCE(SUM(entrada),0)-COALESCE(SUM(salida),0) AS sdo 
		FROM 
			inventarios i,
			info_args a
		WHERE
			i.id_bodega=a.id_bodega
		GROUP BY
			i.id_prod_serv) AS mt
	ON
		p.id_prod_serv=mt.id_prod_serv) AS p
LEFT OUTER JOIN
	(SELECT 
		id_prod_serv,
		COALESCE(SUM(entrada),0)-COALESCE(SUM(salida),0) AS sdo 
	FROM 
		inventarios i,
		info_args a
	WHERE
		i.id_bodega=a.id_bodega
	GROUP BY
		i.id_prod_serv) AS sp
ON
	p.id_prod_serv=sp.id_prod_serv;

-- Por Barra

SELECT
	substring(i.ref_proveedor,1,13),
	substring(it.nombre,1,30),
	substring(c.descripcion,1,14),
	t.talla,
	s.sdo_mt,
	pv.pventa AS pventa1,
	pv.pventa AS pventa2,
	1,
	current_date AS fecha,
	p.id_prod_serv,
	s.sdo_sp,
	a.id_catalogo
FROM
	item i,
	items_tmp3 it,
	prod_serv p,
	tallas t,
	colores c,
	sdo s,
	info_args ia,
	pventa pv,
	administracion_sucursales a
WHERE
	ia.nombre_suc = a.nombre AND
	pv.id_catalogo = a.id_catalogo AND
	s.id_prod_serv=p.id_prod_serv AND
	p.id_item=i.id_item AND
	it.referencia = i.id_item AND
	p.id_prod_serv=pv.id_prod_serv AND
	p.id_talla=t.id_talla AND
	p.id_color=c.id_color AND
	p.codigo=ia.codigo;