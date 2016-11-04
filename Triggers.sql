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
			VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, 'Octavos', TO_DATE('2016-11-11','YYYY-MM-DD'),:NEW.id_batalla, :NEW.entrenador_ganador);
		ELSIF (contador < 12) THEN
				INSERT INTO Resumen_Torneo
				VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, 'Cuartos', TO_DATE('2016-11-12','YYYY-MM-DD'),:NEW.id_batalla, :NEW.entrenador_ganador);
			ELSIF (contador < 14) THEN
					INSERT INTO Resumen_Torneo
					VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, 'Semifinal', TO_DATE('2016-11-13','YYYY-MM-DD'),:NEW.id_batalla, :NEW.entrenador_ganador);
				ELSIF (contador = 14) THEN
						INSERT INTO Resumen_Torneo
						VALUES (:NEW.id_entrenador1, :NEW.id_entrenador2, 'Final', TO_DATE('2016-11-15','YYYY-MM-DD'),:NEW.id_batalla, :NEW.entrenador_ganador);
		END IF;
		UPDATE Entrenador SET dinero = dinero + :NEW.dinero_ganado WHERE id = :NEW.entrenador_ganador;
	END IF;
END;
/
