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
