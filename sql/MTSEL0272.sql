DROP TABLE IF EXISTS info_args;
CREATE TEMP TABLE info_args AS
SELECT
	'?'::CHARACTER VARYING AS nombre_suc,
	'?'::INTEGER AS id_bodega,
	LPAD('?',10,'0') AS numero;
	
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

-- Por Entrada a Almacen

select distinct
	p.codigo,
	dp.cant,
	substring(i.ref_proveedor,1,13),
	substring(it.nombre||' '||t.talla||' '||m.descripcion,1,30),
	substring(c.descripcion,1,14),
	t.talla,
	s.sdo_mt,
	s.sdo_sp,
	pv.pventa AS pventa1,
	pv.pventa AS pventa2,
	current_date AS fecha,
	p.id_prod_serv,
	0,
	0,
	0,
	m.descripcion,
	a.id_catalogo
from
	item i,
	prod_serv p,
	datos_prod dp,
	documentos d,
	marcas m,
	tallas t,
	pventa pv,
	items_tmp3 it,
	info_args ia,
	administracion_sucursales a,
	colores c,	
	sdo s
where
	s.id_prod_serv=p.id_prod_serv and
	pv.id_prod_serv=p.id_prod_serv and
	ia.nombre_suc = a.nombre AND
	a.id_catalogo = pv.id_catalogo AND
	c.id_color=p.id_color AND
	it.referencia=p.id_item and
	t.id_talla=p.id_talla and
	m.id_marca=i.id_marca and
	i.id_item=p.id_item and
	d.ndocumento=dp.ndocumento AND
	dp.id_prod_serv=p.id_prod_serv AND
	d.codigo_tipo='RC' AND
	d.numero=ia.numero; 