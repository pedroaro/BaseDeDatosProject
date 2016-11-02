--Funciones--
CREATE OR REPLACE FUNCTION  Tipo1_Pokemon(idpokemon in Pokemon.id%type)
	RETURN NUMBER
	IS
		Tip NUMBER;
	BEGIN
			SELECT id_tipo1 INTO Tip
			FROM Pokemon_Tipo
			WHERE id_pokemon = idpokemon;
		RETURN (Tip);
	END;
/

CREATE OR REPLACE FUNCTION  Tipo2_Pokemon(idpokemon in Pokemon.id%type)
	RETURN NUMBER
	IS
		Tip NUMBER;
	BEGIN
		SELECT id_tipo2 INTO Tip
		FROM Pokemon_Tipo
		WHERE id_pokemon = idpokemon;

		IF (Tip is NULL) THEN
			Tip :=-1;
		END IF;

		RETURN (Tip);
	END;
/

CREATE OR REPLACE FUNCTION  Tipo_Ataque(id_ataque in Ataque.id%type)
	RETURN NUMBER
	IS
		Tip NUMBER;
	BEGIN
		SELECT id_tipo INTO Tip
		FROM Ataque
		WHERE id = id_ataque;
		RETURN (Tip);
	END;
/

CREATE OR REPLACE FUNCTION  Efectivo(id_ataque in Ataque.id%type, id_pokemon in Pokemon.id%type)
	RETURN NUMBER
	IS
		ef NUMBER;
	BEGIN
		SELECT efectividad INTO ef
		FROM Tipo_Efectivo_Tipo
		WHERE id_tipo1 = Tipo_Ataque(id_ataque) AND id_tipo2 = Tipo1_Pokemon(id_pokemon);
		RETURN (ef);
	END;
/

CREATE OR REPLACE FUNCTION  Nom_At(id_ataque in Ataque.id%type)
	RETURN VARCHAR2
	IS
		Ata VARCHAR2(20);
	BEGIN
		SELECT nombre INTO Ata
		FROM Ataque
		WHERE id = id_ataque;
		RETURN (Ata);
	END;
/

CREATE OR REPLACE FUNCTION  Nom_Pok(id_pokemon in Pokemon.id%type)
	RETURN VARCHAR2
	IS
		pok VARCHAR2(20);
	BEGIN
		SELECT nombre INTO pok
		FROM Pokemon
		WHERE id = id_pokemon;
		RETURN (pok);
	END;
/