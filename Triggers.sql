--Triggers

--Parte A:
CREATE OR REPLACE TRIGGER only_sixten_trainers
  BEFORE INSERT ON Entrenador
  FOR EACH ROW
DECLARE
  trainer_count  INTEGER;      --# of depts for this employee
  max_trainer   INTEGER := 16; --max number of depts per trainer.
BEGIN
 	SELECT COUNT(*) INTO trainer_count
   	FROM Entrenador
  	WHERE id_pokedex != NULL;

	IF trainer_count = max_trainer THEN
    		RAISE_APPLICATION_ERROR (-20000,'Trainers are limited to a max of 16');
	END IF;
END;
/


--16 entrenadores antes de insertar una batalla

CREATE OR REPLACE TRIGGER sixteen_trainers
	BEFORE INSERT ON Batalla
	FOR EACH ROW
DECLARE
 	trainer_count NUMBER;
BEGIN
 	SELECT COUNT(*) INTO trainer_count
   	FROM Entrenador
  	WHERE id_pokedex != NULL;

  	IF (trainer_count < 16) THEN
  		RAISE_APPLICATION_ERROR(-20601, 'Before insert on Batalla, Entrenador have to have a min of 16 trainers');
	END IF;
END;
/


--Parte C:

CREATE OR REPLACE TRIGGER twenty_skills
	BEFORE INSERT ON Batalla
	FOR EACH ROW
DECLARE
	skills_count NUMBER;
BEGIN
	SELECT COUNT(*) INTO skills_count
	FROM Habilidad

	IF (abilities_count < 20) THEN
		RAISE_APPLICATION_ERROR(-20601, 'Before insert on Batalla, There must be a minimun of 20 skills');
	END IF;
END;
/


--Parte D:
CREATE OR REPLACE TRIGGER unique_pokemon
	BEFORE INSERT ON Equipo_Entrenador
	FOR EACH ROW
DECLARE
	pokemons_of_team NUMBER;
BEGIN
	SELECT COUNT(id_pokemon) INTO pokemons_of_team
	FROM Equipo_Entrenador
	WHERE :NEW.id_pokemon = :OLD.id_pokemon;

	IF (pokemons_of_team > 0) THEN
		RAISE_APPLICATION_ERROR(-20601,'The team of the trainer can not have repeated pokemons');
	END IF;
END;
/

--Parte E:
CREATE OR REPLACE TRIGGER unique_attack
	BEFORE INSERT ON Equipo_Entrenador
	FOR EACH ROW
BEGIN
	IF (:NEW.id_ataque1 = :NEW.id_ataque2 OR :NEW.id_ataque1 = :NEW.id_ataque3 OR :NEW.id_ataque1 = :NEW.id_ataque4 OR :NEW.id_ataque2 = :NEW.id_ataque3 OR :NEW.id_ataque2 = :NEW.id_ataque4 OR :NEW.id_ataque3 = :NEW.id_ataque4) THEN
		RAISE_APPLICATION_ERROR(-20601,'The ids of attack have to be diferents');
	END IF;
END;
/

--Actualizar Resumen_torneo:

CREATE OR REPLACE TRIGGER refresh_championship
	AFTER INSERT ON Batalla
	FOR EACH ROW
DECLARE
	octavos_count NUMBER;
	cuartos_count NUMBER;
	semifinal_count NUMBER;
	today DATE;
BEGIN
	SELECT COUNT(*) INTO octavos_count
	FROM Resumen_Torneo
	WHERE fase = 'Octavos';

	SELECT sysdate INTO today;
	FROM dual;

	IF (octavos_count < 16)
		INSERT INTO Resumen_Torneo
		VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, "Octavos", today, :NEW.entranador_ganador);
	ELSE
		SELECT COUNT (*) INTO cuartos_count
		FROM Resumen_Torneo
		WHERE fase = 'Cuartos';

		IF (cuartos_count < 8)
			INSERT INTO Resumen_Torneo
			VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, "Cuartos", today, :NEW.entranador_ganador);
		ELSE
			SELECT COUNT (*) INTO semifinal_count
			FROM Resumen_Torneo
			WHERE fase = 'Semifinal';

			IF (semifinal_count < 4)
				INSERT INTO Resumen_Torneo
				VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, "Semifinal", today, :NEW.entranador_ganador);
			ELSE
				INSERT INTO Resumen_Torneo
				VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, "Final", today, :NEW.entranador_ganador);
			END IF;
END;
/
