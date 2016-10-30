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
   	FROM Entrenador;

	IF (trainer_count = max_trainer) THEN
    	RAISE_APPLICATION_ERROR (-20000,'Trainers are limited to a max of 16');
	END IF;
	IF (:NEW.id_pokedex = NULL) THEN
		RAISE_APPLICATION_ERROR (-20010,'TRAINERS NEED A POKEDEX!!!');
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
   	FROM Entrenador;

  	IF (trainer_count < 16) THEN
  		RAISE_APPLICATION_ERROR(-20600, 'Before insert on Batalla, Entrenador need to have a min of 16 trainers');
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
	FROM Habilidad;

	IF (skills_count < 20) THEN
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
		RAISE_APPLICATION_ERROR(-20603,'The team of the trainer can not have repeated pokemons');
	END IF;
END;
/

--Parte E:
CREATE OR REPLACE TRIGGER unique_attack
	BEFORE INSERT ON Equipo_Entrenador
	FOR EACH ROW
BEGIN
	IF (:NEW.id_ataque1 = :NEW.id_ataque2 OR :NEW.id_ataque1 = :NEW.id_ataque3 OR :NEW.id_ataque1 = :NEW.id_ataque4 OR :NEW.id_ataque2 = :NEW.id_ataque3 OR :NEW.id_ataque2 = :NEW.id_ataque4 OR :NEW.id_ataque3 = :NEW.id_ataque4) THEN
		RAISE_APPLICATION_ERROR(-20602,'The ids of attack have to be diferents');
	END IF;
END;
/

--Actualizar Resumen_torneo:

CREATE OR REPLACE TRIGGER refresh_championship
	AFTER INSERT ON Batalla
	FOR EACH ROW
DECLARE
	contador NUMBER(3);
BEGIN
	SELECT COUNT(*) INTO contador
	FROM Resumen_Torneo;
	IF( :NEW.entrenador_ganador IS NOT NULL ) THEN
		IF (contador < 8) THEN
			INSERT INTO Resumen_Torneo
			VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, 'Octavos', TO_DATE('2016-11-11','YYYY-MM-DD'), :NEW.entrenador_ganador);
		ELSIF (contador < 12) THEN
				INSERT INTO Resumen_Torneo
				VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, 'Cuartos', TO_DATE('2016-11-12','YYYY-MM-DD'), :NEW.entrenador_ganador);
			ELSIF (contador < 14) THEN
					INSERT INTO Resumen_Torneo
					VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, 'Semifinal', TO_DATE('2016-11-13','YYYY-MM-DD'), :NEW.entrenador_ganador);
				ELSIF (contador = 14) THEN
						INSERT INTO Resumen_Torneo
						VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, 'Final', TO_DATE('2016-11-15','YYYY-MM-DD'), :NEW.entrenador_ganador);
		END IF;
	END IF;
END;
/
