SELECT
	a.id_bodega_ppal,
	a.id_bodega_sep,
	d.codigo_tipo,
	a.id_centrocosto,
	a.nombre,
	a.direccion,
	a.telefono,
	a.email,
	a.ciudad
FROM
	administracion_sucursales a,
	documentos_sucursales d,
	asignacion_usuario_sucursal au,
	usuarios u
WHERE
	a.id_administracion_sucursales = d.id_administracion_sucursales AND
	au.id_administracion_sucursales = a.id_administracion_sucursales AND
	id_transaccion = '328' AND
	au.id = u.id_usuario AND
	u.login = 'emaku';