SELECT 
	p.codigo,
	i3.nombre,
	100,
	dp.cant,
	dp.pventa,
	dp.iva,
	dp.descuento1,
	0,
	0,
	0,
	0,
	0,
	dp.id_prod_serv,
	nextval('tagdata')
FROM
	prod_serv p,
	datos_prod dp,
	item i,
	items_tmp3 i3,
	documentos d
WHERE
	p.id_item=i.id_item AND
	p.id_prod_serv=dp.id_prod_serv AND
	i3.referencia=i.id_item AND
	d.ndocumento=dp.ndocumento AND
	d.ndocumento = '?'
ORDER BY
	dp.orden