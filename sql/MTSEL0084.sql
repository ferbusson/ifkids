DROP TABLE IF EXISTS info_args;
CREATE TEMP TABLE info_args AS
SELECT
	'?'::CHARACTER VARYING AS nombre_suc,
	'?'::INTEGER AS id_bodega,
	CAST('?' AS character(20)) AS ref_proveedor;

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

	
SELECT DISTINCT
	foo.codigo,
	0,
	substring(foo.ref_prov,1,13),
	substring(foo.nombre,1,30),
	substring(foo.descripcion,1,14),
	foo.talla,
	sdo.sdo_mt,
	sdo.sdo_sp,
	foo.pventa1,
	foo.pventa2,
	current_date AS fecha,
	foo.id_prod_serv,
	0,
	0,
	0,
	foo.marca,
	foo.id_catalogo
FROM
	(SELECT
	       p.codigo,
	       p.codigo,
		TRIM(i.ref_proveedor) AS ref_prov,
		it.nombre||' '||ma.descripcion AS nombre,
		c.descripcion AS descripcion,
		t.talla,
		pv.pventa AS pventa1,
		pv.pventa AS pventa2,
		p.id_prod_serv,
		ma.descripcion AS marca,
		a.id_catalogo
	FROM
		item i,
		items_tmp3 it,
		prod_serv p,
		tallas t,
		colores c,
		marcas ma,
		info_args ig,
		pventa pv,
		administracion_sucursales a
	WHERE
		ig.nombre_suc = a.nombre AND		
		it.referencia = i.id_item AND
		i.id_marca = ma.id_marca AND
		p.id_item=i.id_item AND
		pv.id_prod_serv = p.id_prod_serv AND
		pv.id_catalogo = a.id_catalogo AND
		p.id_talla=t.id_talla AND
		p.id_color=c.id_color AND
		i.ref_proveedor=ig.ref_proveedor
		) AS foo
LEFT OUTER JOIN
	sdo
ON
	sdo.id_prod_serv = foo.id_prod_serv;