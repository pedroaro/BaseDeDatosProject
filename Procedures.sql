--Procedures--

CREATE or replace procedure Efectividad
	(	id_ataque in Ataque.id%type,
		id_pokemon in Pokemon.id%type
	)
	IS
	Pok VARCHAR2(20);
	Ata VARCHAR2(20);
	Efec NUMBER(3,2);
	BEGIN 
		Efec:= Efectivo(id_ataque,id_pokemon);
		Pok:= Nom_Pok(id_pokemon);
		Ata:=Nom_At(id_ataque);
		IF (Efec = 2) THEN
			dbms_output.put_line(Pok||' recibió '|| Ata || ' ... fue super efectivo ');
		ELSIF (Efec = 0.5) THEN
			dbms_output.put_line(Pok||' recibió '|| Ata || ' ... No fue efectivo ');
		END IF;
	END;
/
set serveroutput on;
