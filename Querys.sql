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

