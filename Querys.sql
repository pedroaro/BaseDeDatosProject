--QUERYS

--Pokémon de tipo agua
SELECT *
FROM Pokemon
WHERE id IN 
	(	SELECT id_pokemon
		FROM Pokemon_Tipo
		WHERE id_tipo1 IN
			(	SELECT id
				FROM tipo
				WHERE nombre = 'agua') OR
			id_tipo2 IN
			(	SELECT id
				FROM tipo
				WHERE nombre = 'agua'))
ORDER BY ataque DESC;

--Cadena Evolutiva
SELECT *
FROM Pokemon
WHERE metodo_evolucion = 'intercambio' OR id IN
	(	SELECT evoluciona_de
		FROM Pokemon
		WHERE metodo_evolucion = 'intercambio' OR id IN 
		(	SELECT evoluciona_de
			FROM Pokemon
			WHERE metodo_evolucion = 'intercambio'
		));

--10 ataques mas fuertes contra roca
SELECT B.nombre,B.efectividad, B.poder
FROM (
	SELECT A.nombre, T2.efectividad, CASE 	WHEN A.poder IS NULL THEN 0
											ELSE A.poder END PODER
	FROM Ataque A,
		(	SELECT t.id, t1.efectividad
			FROM Tipo t,(	SELECT id_tipo1, efectividad
							FROM Tipo_Efectivo_Tipo
							WHERE id_tipo2 IN 
								(	SELECT id
									FROM Tipo
									WHERE nombre = 'roca'
									)) t1
			WHERE t.id = t1.id_tipo1 AND efectividad IN (SELECT MAX(efectividad) FROM Tipo_Efectivo_Tipo )) T2
	WHERE T2.id = A.id_tipo
	ORDER BY PODER DESC) B
WHERE ROWNUM<= 10;
