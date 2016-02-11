DROP TABLE IF EXISTS info_args;
CREATE TEMP TABLE info_args AS
SELECT
	'?'::CHARACTER VARYING AS nombre_suc,
	'?'::INTEGER AS id_bodega,
	'?'::INTEGER AS id_marca;
	
SELECT DISTINCT
	foo.codigo,
	0,
	substring(foo.ref_prov,1,13),
	substring(foo.nombre||' '||foo.marca,1,30),
	substring(foo.descripcion,1,14),
	foo.talla,
	COALESCE(sdo.sdo,0),
	0,
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
		TRIM(i.ref_proveedor) AS ref_prov,
		it.nombre,
		m.descripcion as marca,
		c.descripcion,
		t.talla,
		pv.pventa AS pventa1,
		pv.pventa AS pventa2,
		p.id_prod_serv,
		a.id_catalogo
	FROM
		marcas m,
		item i,
		items_tmp3 it,
		prod_serv p,
		tallas t,
		colores c,
		pventa pv,
		info_args ia,
		administracion_sucursales a
	WHERE
		m.id_marca=i.id_marca AND
		it.referencia = i.id_item AND
		p.id_item=i.id_item AND
		p.id_prod_serv = pv.id_prod_serv AND
		ia.nombre_suc = a.nombre AND
		a.id_catalogo = pv.id_catalogo AND
		p.id_talla=t.id_talla AND
		p.id_color=c.id_color AND
		i.id_marca=ia.id_marca) AS foo
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
		i.id_prod_serv) AS sdo
ON
	sdo.id_prod_serv = foo.id_prod_serv
