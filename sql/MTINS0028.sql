DROP TABLE IF EXISTS aux_param_20150728;
CREATE TEMP TABLE aux_param_20150728 AS
SELECT
	'122'::INTEGER AS narqueo,
	'emaku'::CHARACTER(10) AS login;

DROP TABLE IF EXISTS aux_documento_usuario;
CREATE TEMP TABLE aux_documento_usuario AS
SELECT
	a.narqueo,
	u.id_usuario,
	ds.codigo_tipo
FROM
	aux_param_20150728 a,
	asignacion_usuario_sucursal asig,
	usuarios u,
	documentos_sucursales ds,
	tipo_documento td
WHERE
	u.login = a.login AND
	u.id_usuario = asig.id AND
	asig.id_administracion_sucursales = ds.id_administracion_sucursales AND
	td.codigo_tipo = ds.codigo_tipo AND
	td.descripcion ILIKE '%ARQUEO%';

INSERT INTO 
	datos_arqueo(
		narqueo,
		ndocumento,
		valor
		) 
SELECT
	a.narqueo,
        d.ndocumento,
        dd.valor
FROM
        documentos d, 
        aux_documento_usuario a,
        datos_documento dd, 
        info_documento i,
	(SELECT
		d.ndocumento
	FROM
		documentos d
	WHERE
		d.estado=TRUE
	EXCEPT
	SELECT
		da.ndocumento
	FROM
		datos_arqueo da,
		documentos d,
		aux_documento_usuario a
	WHERE
		d.codigo_tipo=a.codigo_tipo AND
		da.narqueo=d.ndocumento AND
		d.estado=TRUE) AS foo
WHERE
        d.ndocumento=dd.ndocumento AND
        d.ndocumento=i.ndocumento AND
        --d.estado=TRUE AND
	d.codigo_tipo !=a.codigo_tipo  AND
        i.id_usuario=a.id_usuario AND
        d.ndocumento=foo.ndocumento;