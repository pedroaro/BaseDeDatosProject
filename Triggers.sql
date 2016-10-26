--Triggers

CREATE OR REPLACE TRIGGER only_sixten_trainers
  BEFORE UPDATE OR INSERT ON Entrenador
  FOR EACH ROW
DECLARE
  trainer_count  INTEGER;      --# of depts for this employee
  max_trainer   INTEGER := 16; --max number of depts per trainer.
BEGIN
 	SELECT COUNT(*) INTO trainer_count
   	FROM Entrenador
  	WHERE id_pokedex != NULL;

	IF trainer_count >= max_trainer THEN
    		RAISE_APPLICATION_ERROR (-20000,'Trainers are limited to a max of 16');
	END IF;
END;
/
