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

--Informacion de entrenadores con mas pokemones conseguidos
SELECT E.*
FROM Entrenador E,
(	SELECT id, cantidad_obtenidos as pokemones
		FROM pokedex 
		ORDER BY pokemones DESC) T1
WHERE E.id_pokedex = T1.id AND ROWNUM<= 5;

--Imprimir equipo que tenga mas dinero que el promedio
SELECT T1.NombreP, T1.NombreE, T1.dinero, DIN.dineroProm
FROM Equipo_Entrenador A, 
	(	SELECT P.id as Id, P.nombre as NombreP ,E.id as IdE, E.nombre as NombreE, E.dinero as dinero
		FROM Pokemon P, Entrenador E) T1,
	(	SELECT AVG(dinero) AS dineroProm
		FROM Entrenador) DIN
WHERE A.id_pokemon = T1.Id and A.id_entrenador = T1.IdE AND T1.dinero > DIN.dineroProm;


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
