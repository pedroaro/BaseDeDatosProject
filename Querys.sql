--QUERYS

--A--Pokémon de tipo agua
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

--B--Informacion de entrenadores con mas pokemones conseguidos
SELECT E.*
FROM Entrenador E,
(	SELECT id, cantidad_obtenidos as pokemones
		FROM pokedex 
		ORDER BY pokemones DESC) T1
WHERE E.id_pokedex = T1.id AND ROWNUM<= 5;

--C--Pokemon Ganador Summary
SELECT P.*, A.nivel, at1.Ataque_1, at2.Ataque_2, at3.Ataque_3, at4.Ataque_4, T.nombre as Tipo1 , Ti.nombre as Tipo2
FROM Pokemon P, Equipo_Entrenador A, Pokemon_Tipo PT , Tipo T, Tipo Ti,
	(	SELECT id as ataque1, nombre as Ataque_1
		FROM Ataque) at1,
	(	SELECT id as ataque2, nombre as Ataque_2
		FROM Ataque) at2,
	(	SELECT id as ataque3, nombre as Ataque_3
		FROM Ataque) at3,
	(	SELECT id as ataque4, nombre as Ataque_4
		FROM Ataque) at4
WHERE P.id IN 
	(	SELECT pokemon_ganador
		FROM Batalla
		WHERE entrenador_ganador IS NOT NULL AND id_batalla IN 
			(	SELECT id_batalla
				FROM Resumen_Torneo
				WHERE fase = 'Final'
				)
		)
	AND A.id_pokemon = P.Id AND A.id_entrenador IN 
	(	SELECT Ganador
				FROM Resumen_Torneo
				WHERE fase = 'Final'
	)
	AND A.id_ataque1=at1.ataque1 AND A.id_ataque2=at2.ataque2 AND A.id_ataque3=at3.ataque3 AND A.id_ataque4=at4.ataque4
	AND PT.id_pokemon = P.id AND PT.id_tipo1 = T.id AND PT.id_tipo2 = Ti.id
	;

--D--Imprimir equipo que tenga mas dinero que el promedio
SELECT T1.NombreP, T1.NombreE, T1.dinero, DIN.dineroProm
FROM Equipo_Entrenador A, 
	(	SELECT P.id as Id, P.nombre as NombreP ,E.id as IdE, E.nombre as NombreE, E.dinero as dinero
		FROM Pokemon P, Entrenador E) T1,
	(	SELECT AVG(dinero) AS dineroProm
		FROM Entrenador) DIN
WHERE A.id_pokemon = T1.Id and A.id_entrenador = T1.IdE AND T1.dinero > DIN.dineroProm;

--F--Nivel Promedio
SELECT A.*, T1.entrenador, T1.NivelProm,prom.PromedioGeneral
FROM Resumen_Torneo A, 
(	SELECT id_entrenador as entrenador, AVG(nivel) as NivelProm
	FROM Equipo_Entrenador
	GROUP BY id_entrenador
) T1,
(	SELECT AVG(nivel) as PromedioGeneral
	FROM Equipo_Entrenador) prom
WHERE (A.id_entrenador1 = T1.entrenador OR A.id_entrenador2 = T1.entrenador) AND T1.NivelProm > prom.PromedioGeneral;

--G--Cadena Evolutiva
SELECT *
FROM Pokemon
WHERE UPPER(metodo_evolucion) = UPPER('iNtErcAMbio') OR id IN
	(	SELECT evoluciona_de
		FROM Pokemon
		WHERE UPPER(metodo_evolucion) = UPPER('iNtErcAMbio') OR id IN 
		(	SELECT evoluciona_de
			FROM Pokemon
			WHERE UPPER(metodo_evolucion) = UPPER('iNtErcAMbio')
		));

--H--10 ataques mas fuertes contra roca
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


--I-- información de las habilidades de los pokémon de los entrenadores de Valencia que iniciaron su viaje hace 4 años
SELECT *
FROM habilidad
WHERE id IN (SELECT DISTINCT id_habilidad
		FROM Equipo_Entrenador
		WHERE id_entrenador IN (SELECT id
			 		FROM Entrenador
			 		WHERE pueblo_origen = 'Valencia' AND fecha_inicio >= TO_DATE('01-01-2012','DD-MM-YYYY') AND fecha_inicio <= TO_DATE('31-12-2012','DD-MM-YYYY')));

--J-- ¿Cuál fue el pokémon que ganó más batallas con su entrenador? Mostrar experiencia ganada y a cuántos pokémon derrotó.
SELECT nombre AS Nombre_Pokemon, Entrenador, T1.Batallas_ganadas, T1.Experiencia_ganada 
FROM Pokemon P
JOIN(	SELECT Entrenador, Pokemon, Batallas_ganadas, Experiencia_ganada
	FROM(	SELECT Entrenador, Pokemon, SUM(cant_ganadas) AS Batallas_ganadas, SUM(exp_ganada) AS Experiencia_ganada
		FROM (  SELECT id_entrenador1 AS Entrenador, id_pokemon1 AS Pokemon, COUNT(*) AS cant_ganadas, SUM(exp_ganada) AS exp_ganada
			FROM Batalla
			WHERE id_pokemon1 = pokemon_ganador
			GROUP BY id_entrenador1, id_pokemon1
			UNION ALL
			SELECT id_entrenador2, id_pokemon2, COUNT(*) AS cant_ganadas, SUM(exp_ganada) AS exp_ganada
			FROM Batalla
			WHERE id_pokemon2 = pokemon_ganador
			GROUP BY id_entrenador2, id_pokemon2
			ORDER BY Entrenador)
		GROUP BY Entrenador, Pokemon
		ORDER BY Entrenador)
	 WHERE Batallas_ganadas=(SELECT MAX(cg)
				 FROM ( SELECT SUM(cant_ganadas) AS cg
				 	FROM(	SELECT id_entrenador1 AS Entrenador, id_pokemon1 AS Pokemon, COUNT(*) AS cant_ganadas
						FROM Batalla
						WHERE id_pokemon1 = pokemon_ganador
						GROUP BY id_entrenador1, id_pokemon1
						UNION ALL
						SELECT id_entrenador2, id_pokemon2, COUNT(*) AS cant_ganadas
						FROM Batalla
						WHERE id_pokemon2 = pokemon_ganador
						GROUP BY id_entrenador2, id_pokemon2)
					GROUP BY Entrenador, Pokemon)) AND ROWNUM = 1) T1
ON T1.Pokemon = P.id;


--K--Mayor cantidad de pokemones vistos
SELECT T1.NombrePokemon, T1.NombreEntrenador, T1.canti, VI.vistosprom, at1.Ataque_1, at2.Ataque_2, at3.Ataque_3, at4.Ataque_4 , Tipot.nombreT as Tipo_1
FROM Equipo_Entrenador A, Pokemon_Tipo PKT,
	(	SELECT P.id as Id, P.nombre as NombrePokemon ,E.id as IdE, E.nombre as NombreEntrenador, Po.cantidad_vistos as canti
		FROM Pokemon P, Entrenador E, Pokedex Po
		WHERE E.id_pokedex= Po.id) T1,
	(	SELECT AVG(cantidad_vistos) AS vistosprom
		FROM Pokedex) VI,
	(	SELECT id as ataque1, nombre as Ataque_1
		FROM Ataque) at1,
	(	SELECT id as ataque2, nombre as Ataque_2
		FROM Ataque) at2,
	(	SELECT id as ataque3, nombre as Ataque_3
		FROM Ataque) at3,
	(	SELECT id as ataque4, nombre as Ataque_4
		FROM Ataque) at4,
	(	SELECT id as top1, nombre as nombreT
		FROM Tipo) Tipot
WHERE A.id_pokemon = T1.Id AND A.id_entrenador = T1.IdE AND T1.canti > VI.vistosprom AND A.id_ataque1= at1.ataque1 AND A.id_ataque2= at2.ataque2
AND A.id_ataque3= at3.ataque3 AND A.id_ataque4= at4.ataque4 AND A.id_pokemon= PKT.id_pokemon AND PKT.id_tipo1= Tipot.top1
ORDER BY T1.NombreEntrenador ASC;

--L-- TIPO VICTORIOSO
SELECT TI.nombre, AUX.contador
FROM Tipo TI,
	(SELECT T.id as idtipo , COUNT(T.id) AS contador
	FROM Tipo T, Pokemon_Tipo PT, Batalla B
	WHERE (T.id = PT.id_tipo1 OR T.id = PT.id_tipo2) AND (B.id_pokemon1 = PT.id_pokemon OR B.id_pokemon2 = PT.id_pokemon)
	GROUP BY T.id
	ORDER BY contador DESC) AUX
WHERE TI.id = AUX.idtipo AND ROWNUM <= 1;
