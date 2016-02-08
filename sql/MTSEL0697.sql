SELECT
	ndocumento,
	numero
FROM
	(SELECT
		foo.numero,
		foo.ndocumento,
		saldo
	FROM
		(SELECT
			c.numero,
			c.nfactura,
			c.tfactura,
			c.tfactura+COALESCE(co.vcomprobante,0) AS saldo,
			c.char_cta,
			c.id_cta,
			c.ndocumento
		FROM
			(SELECT
				D.fecha,
				c.dcredito,
				d.codigo_tipo||d.numero AS numero,
				c.nfactura,
				SUM(c.neto_factura) AS vfactura,
				SUM(c.total_factura) AS tfactura,
				ac.char_cta,
				ac.id_cta,
				ndocumento
			FROM
				cartera c,
				documentos d,
				cuentas ac
			WHERE
				c.idtercero='?' AND
				ac.char_cta ilike '2%' AND
				d.ndocumento=c.nfactura AND				
				d.codigo_tipo='?' AND 
				--d.codigo_tipo <> 'RC' AND
				ac.id_cta=c.id_cta AND
				d.estado='true' AND
				c.total_factura>0
			GROUP BY
				d.fecha,
				c.nfactura,
				c.dcredito,	
				d.codigo_tipo,
				d.numero,
				c.nfactura,
				c.dcredito,
				ac.char_cta,
				ac.id_cta,
				ndocumento) AS c
		LEFT OUTER JOIN
			(SELECT
				c.nfactura,
				SUM(COALESCE(c.cargo_comprobante,0))-(SUM(COALESCE(c.abono_comprobante,0))+SUM(COALESCE(c.dcto_comprobante,0))) AS vcomprobante
			FROM
				cartera c,
				documentos d
			WHERE
				c.ncomprobante=d.ndocumento AND
				d.estado='true'
			GROUP BY
				c.nfactura) AS co
		ON
			co.nfactura=c.nfactura) AS foo
	LEFT OUTER JOIN
		info_documento if
	ON
		if.ndocumento=foo.ndocumento 
	ORDER BY
		numero) as foo
WHERE
	foo.saldo!=0;