﻿SELECT 
	foo.id_prod_serv,
	foo.nombre,
	foo.pventa,
	foo.iva,
	foo.fecha,
	fsaldo.saldo,
	foo.pventa1,
	foo.pventa2
FROM
	(SELECT 
		p.id_prod_serv,
		it.nombre||' '||t.talla AS nombre,
		pv.pventa,
		p.iva,
		current_timestamp as fecha,
		pventa1,
		pventa2
	FROM 
		prod_serv p,
		item i,
		items_tmp3 it,
		colores c,
		tallas t,
		pventa pv,
		(select id_prod_serv,pventa as pventa1 from pventa where id_catalogo=1) as p1,
		(select id_prod_serv,pventa as pventa2 from pventa where id_catalogo=2) as p2
			
	 WHERE 
		it.referencia=i.id_item AND
		pv.id_prod_serv=p.id_prod_serv AND
		p.id_color=c.id_color AND
		p.id_talla=t.id_talla AND
		p.id_item=i.id_item AND
		p.id_prod_serv=p1.id_prod_serv AND
		p.id_prod_serv=p2.id_prod_serv AND
		p.codigo='?' AND
		pv.id_catalogo='?'
) AS foo
LEFT OUTER JOIN 
	(SELECT
		id_prod_serv,
		SUM(COALESCE(entrada,0))-SUM(COALESCE(salida,0)) AS saldo
	FROM
		inventarios
	WHERE
		id_bodega = '?'
	GROUP BY
		id_prod_serv) AS fsaldo
ON
	foo.id_prod_serv = fsaldo.id_prod_serv
