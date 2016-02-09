BEGIN;
UPDATE 
	pventa
SET
	pventa = foo.pventa1
FROM
	(SELECT
		p.id_prod_serv,
		foo.pventa1
	FROM
		prod_serv p,
		(SELECT
			i.id_item,	
			foo.pventa1
		FROM
			item i,
			(SELECT
				m.id_marca,
				pm.referencia,
				pm.pventa1
			FROM
				prod_migrados pm,
				marcas m
			WHERE
				pm.marca = m.descripcion) AS foo
		WHERE
			i.ref_proveedor = foo.referencia AND
			i.id_marca = foo.id_marca) AS foo
	WHERE
		foo.id_item = p.id_item) AS foo
WHERE
	pventa.id_prod_serv = foo.id_prod_serv AND
	pventa.id_catalogo = 1;
COMMIT;