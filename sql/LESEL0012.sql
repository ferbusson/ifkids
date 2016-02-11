DROP TABLE IF EXISTS aux_param_query;
CREATE TABLE aux_param_query AS
SELECT
	'?'::CHARACTER(15) AS codigo,
	'?'::INTEGER AS id_catalogo,
	'?'::INTEGER AS id_bodega;


SELECT DISTINCT
	p.id_prod_serv,
	nombre,
	coalesce(c.pinventario,0),
	p.iva,
	current_timestamp,
	fsaldo.saldo,
	p.pventa,
	0,
	coalesce(c.pinventario,0)
FROM
	(SELECT 
		p.id_prod_serv,
		substring(i.ref_proveedor||' '||m.descripcion||' '||t.talla,0,40) as nombre,
		pv.pventa,
		p.iva,
		p.pcosto
	FROM 
		aux_param_query a,
		marcas m,
		prod_serv p,
		item i,
		items_tmp3 it,
		colores c,
		tallas t,
		pventa pv
	 WHERE 
		m.id_marca=i.id_marca AND
		it.referencia=i.id_item AND
		pv.id_prod_serv=p.id_prod_serv AND
		pv.id_catalogo=a.id_catalogo AND
		p.id_color=c.id_color AND
		p.id_talla=t.id_talla AND
		p.id_item=i.id_item AND
		p.codigo=a.codigo) AS p
LEFT OUTER JOIN
	(SELECT
		i.id_prod_serv,
		pinventario
	FROM
		inventarios i,
		(SELECT
			i.id_prod_serv,
			max(orden)
		FROM
			inventarios i,
			(SELECT
				id_prod_serv,
				MAX(orden)
			FROM
				inventarios i,
				aux_param_query a
			WHERE
				i.id_bodega=a.id_bodega
			GROUP BY
				id_prod_serv) AS f
		WHERE
			f.id_prod_serv=i.id_prod_serv AND
			f.max=i.orden
		GROUP BY
			i.id_prod_serv) AS f
	WHERE
		f.max=i.orden) AS c
ON
	p.id_prod_serv=c.id_prod_serv
LEFT OUTER JOIN
	(SELECT
		id_prod_serv,
		SUM(COALESCE(entrada,0))-SUM(COALESCE(salida,0)) AS saldo
	FROM
		inventarios i,
		aux_param_query a
	WHERE
		i.id_bodega = a.id_bodega
	GROUP BY
		id_prod_serv) AS fsaldo
ON
	p.id_prod_serv = fsaldo.id_prod_serv;	
