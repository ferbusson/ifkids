SELECT 
    ps.codigo,
    it3.nombre,
    cant,
    pventa,
    dp.iva,
    dp.descuento1,
    0.00 as sub_tot,
    0.00 as v_dcto,
    0.00 as vrtotal,
    0.00 as v_Iva,
    0.00 as gtotal,
    dp.id_prod_serv,
    CURRENT_TIMESTAMP AS tag,
    COALESCE(dd.trm,'0.0') AS trm,
    0.0 as totalus
FROM 
    datos_prod dp,
    documentos d,
    datos_documento dd,
    prod_serv ps,
     item it,
    marcas mar,
    tallas t,
    colores c,
    items_tmp3 it3
WHERE 
    d.ndocumento = dd.ndocumento AND
    it3.referencia=it.id_item AND
    dp.ndocumento=d.ndocumento AND
    ps.id_prod_serv=dp.id_prod_serv AND
    it.id_item=ps.id_item AND
    ps.id_color=c.id_color AND
    ps.id_talla=t.id_talla AND
    it.id_marca=mar.id_marca AND
    codigo_tipo='?' AND    
    d.numero=LPAD('?',10,'0');