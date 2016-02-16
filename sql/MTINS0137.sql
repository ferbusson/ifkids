DROP TABLE IF EXISTS aux_values_params;
CREATE TEMP TABLE aux_values_params;
SELECT
	'?'::INTEGER AS id_administracion_sucursal,
	'?'::INTEGER AS id;
	
DELETE FROM
	empleados_sucursal
USING
	aux_values_params a
WHERE
	empleados_sucursal.id_administracion_sucursales = a.id_administracion_sucursales;

	
INSERT INTO 
	empleados_sucursal
SELECT
	id_administracion_sucursal,
	id
FROM
	aux_values_params;