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
		Efec:= Efectivo1(id_ataque,id_pokemon) * Efectivo2(id_ataque,id_pokemon);
		Pok:= Nom_Pok(id_pokemon);
		Ata:=Nom_At(id_ataque);
		IF (Efec = 4) THEN
			dbms_output.put_line(Pok||' recibió '|| Ata || ' ... tiene maxima Efectividad ');
		ELSIF (Efec = 2) THEN
			dbms_output.put_line(Pok||' recibió '|| Ata || ' ... fue super efectivo ');
		ELSIF (Efec = 1) THEN
			dbms_output.put_line(Pok||' recibió '|| Ata || ' ...  fue Normal ');
		ELSIF (Efec = 0.5) THEN
			dbms_output.put_line(Pok||' recibió '|| Ata || ' ... No fue muy efectivo ');
		ELSIF (Efec = 0.25) THEN
			dbms_output.put_line(Pok||' recibió '|| Ata || ' ... No fue efectivo ');
		ELSIF (Efec = 0) THEN
			dbms_output.put_line(Pok||' recibió '|| Ata || ' ... No tuvo ningun efecto ');
		END IF;
	END;
/
set serveroutput on;
