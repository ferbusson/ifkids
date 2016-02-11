SELECT 
	p.codigo,
	p.codigo||' - '||' '||i.ref_proveedor||' '||i3.nombre||' '||c.descripcion||' '||t.talla
FROM 
	prod_serv p,
	item i,
	items_tmp3 i3,
	marcas ma,
	colores c,
	tallas t
WHERE 
	p.id_color = c.id_color AND
	p.id_talla = t.id_talla AND
	ma.id_marca = i.id_marca AND
	p.id_item = i.id_item AND
	i.id_item = i3.referencia AND
	(i.ref_proveedor ILIKE '%?%' OR 
	i.ref_proveedor||i3.nombre||ma.descripcion||p.descripcion||p.codigo ILIKE '%?%') AND
	p.estado=true
ORDER BY
	ma.descripcion||' '||c.descripcion||' '||t.talla;