CREATE TABLE Pokemon(
	id NUMBER CHECK (id >= 0) PRIMARY KEY,
	nombre VARCHAR2(20) NOT NULL,
	hp NUMBER CHECK (hp >= 0),
	ataque NUMBER CHECK (ataque >= 0),
	defensa NUMBER CHECK (defensa >= 0),
	ataque_especial NUMBER CHECK (ataque_especial >= 0),
	defensa_especial NUMBER CHECK (defensa_especial >= 0),
	velocidad NUMBER CHECK (velocidad >= 0),
	evoluciona_de NUMBER CHECK (evoluciona_de >= 0),
	metodo_evolucion VARCHAR2(50) CHECK (metodo_evolucion = 'nivel' OR metodo_evolucion = 'item' OR metodo_evolucion = 'intercambio'),
	FOREIGN KEY (evoluciona_de) REFERENCES Pokemon (id)
);

CREATE TABLE Tipo(
	id NUMBER CHECK (id >= 0) PRIMARY KEY,
	nombre VARCHAR2(20) NOT NULL
);

CREATE TABLE Tipo_Efectivo_Tipo(
	id_tipo1 NUMBER CHECK (id_tipo1 >= 0),
	id_tipo2 NUMBER CHECK (id_tipo2 >= 0),
	efectividad NUMBER(3,2) CHECK (efectividad >= 0),
	PRIMARY KEY(id_tipo1, id_tipo2)
);

CREATE TABLE Pokemon_Tipo(
	id_pokemon NUMBER CHECK (id_pokemon >= 0),
	id_tipo1 NUMBER CHECK (id_tipo1 >= 0),
	id_tipo2 NUMBER CHECK (id_tipo2 >= 0),
	PRIMARY KEY(id_pokemon, id_tipo1),
	FOREIGN KEY (id_pokemon) REFERENCES Pokemon(id),
	FOREIGN KEY (id_tipo1) REFERENCES Tipo (id),
	FOREIGN KEY (id_tipo2) REFERENCES Tipo (id)
);

CREATE TABLE Habilidad(
	id NUMBER PRIMARY KEY CHECK (id >= 0),
	nombre VARCHAR2(20) NOT NULL,
	descripcion VARCHAR2(50)
);

CREATE TABLE Pokedex(
	id NUMBER CHECK (id >= 0) PRIMARY KEY ,
	cantidad_vistos NUMBER CHECK (cantidad_vistos >= 0),
	cantidad_obtenidos NUMBER CHECK (cantidad_obtenidos >= 0)
);

CREATE TABLE Entrenador(
	id NUMBER CHECK (id >= 0) PRIMARY KEY,
	nombre VARCHAR2(20) NOT NULL,
	pueblo_origen VARCHAR2(20),
	dinero NUMBER CHECK (dinero >= 0),
	fecha_inicio DATE,
	id_pokedex NUMBER CHECK (id_pokedex >= 0),
	FOREIGN KEY (id_pokedex) REFERENCES Pokedex(id)
);

CREATE TABLE Ataque(
	id NUMBER CHECK (id >= 0) PRIMARY KEY,
	nombre VARCHAR2(20) NOT NULL,
	categoria VARCHAR2(15) CHECK(categoria = 'Ataque especial' OR categoria = 'Ataque físico'),
	poder NUMBER CHECK (poder >= 0),
	presicion NUMBER CHECK (presicion >= 0),
	cantidad_veces NUMBER CHECK (cantidad_veces >= 0),
	descripcion VARCHAR2(200),
	id_tipo NUMBER CHECK (id_tipo >= 0),
	FOREIGN KEY (id_tipo) REFERENCES Tipo(id)
);

CREATE TABLE Resumen_Torneo(
	id_entrenador1 NUMBER CHECK (id_entrenador1 >= 0),
	id_entrenador2 NUMBER CHECK (id_entrenador2 >= 0),
	fase VARCHAR2(10) CHECK (fase = 'Octavos' OR fase = 'Cuartos' OR fase = 'Semifinal' OR fase = 'Final'),
	fecha_encuentro DATE,
	ganador NUMBER CHECK (ganador >= 0),
	PRIMARY KEY(id_entrenador1, id_entrenador2),
	FOREIGN KEY (id_entrenador1) REFERENCES Entrenador(id),
	FOREIGN KEY (id_entrenador2) REFERENCES Entrenador(id),
	FOREIGN KEY (ganador) REFERENCES Entrenador(id)
);

CREATE TABLE Equipo_Entrenador(
	id_entrenador NUMBER CHECK (id_entrenador >= 0),
	id_pokemon NUMBER CHECK (id_pokemon >= 0),
	genero VARCHAR2(4) CHECK (genero = 'M' OR genero = 'F' OR genero = 'N/A'),
	nivel NUMBER CHECK (nivel >= 1 AND nivel <= 100),
	exp_actual NUMBER CHECK (exp_actual >= 0),
	exp_necesaria NUMBER CHECK (exp_necesaria >= 0),
	id_ataque1 NUMBER CHECK (id_ataque1 >= 0),
	id_ataque2 NUMBER CHECK (id_ataque2 >= 0),
	id_ataque3 NUMBER CHECK (id_ataque3 >= 0),
	id_ataque4 NUMBER CHECK (id_ataque4 >= 0),
	id_habilidad NUMBER CHECK (id_habilidad >= 0),
	PRIMARY KEY (id_entrenador, id_pokemon),
	FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id),
	FOREIGN KEY (id_pokemon) REFERENCES Pokemon(id),
	FOREIGN KEY (id_ataque1) REFERENCES Ataque(id),
	FOREIGN KEY (id_ataque2) REFERENCES Ataque(id),
	FOREIGN KEY (id_ataque3) REFERENCES Ataque(id),
	FOREIGN KEY (id_ataque4) REFERENCES Ataque(id),
	FOREIGN KEY (id_habilidad) REFERENCES Habilidad(id)
);

CREATE TABLE Batalla(
	id_batalla NUMBER CHECK (id_batalla >= 0),
	id_entrenador1 NUMBER CHECK (id_entrenador1 >= 0),
	id_pokemon1 NUMBER CHECK (id_pokemon1 >= 0),
	id_entrenador2 NUMBER CHECK (id_entrenador2 >= 0),
	id_pokemon2 NUMBER CHECK (id_pokemon2 >= 0),
	dinero_gastado NUMBER CHECK (dinero_gastado >= 0),
	exp_ganada NUMBER CHECK (exp_ganada >= 0),
	pokemon_ganador NUMBER CHECK (pokemon_ganador >= 0),
	entrenador_ganador NUMBER CHECK (entrenador_ganador >= 0),
	PRIMARY KEY(id_batalla, id_entrenador1, id_pokemon1, id_entrenador2, id_pokemon2),
	FOREIGN KEY (id_entrenador1) REFERENCES Entrenador(id),
	FOREIGN KEY (id_entrenador2) REFERENCES Entrenador(id),
	FOREIGN KEY (id_pokemon1) REFERENCES Pokemon(id),
	FOREIGN KEY (id_pokemon2) REFERENCES Pokemon(id),
	FOREIGN KEY (pokemon_ganador) REFERENCES Pokemon(id),
	FOREIGN KEY (entrenador_ganador) REFERENCES Entrenador(id)
);

--DROP TABLE Pokemon CASCADE CONSTRAINTS;
--DROP TABLE Tipo CASCADE CONSTRAINTS;
--DROP TABLE Tipo_Efectivo_Tipo CASCADE CONSTRAINTS;
--DROP TABLE Pokemon_Tipo CASCADE CONSTRAINTS;
--DROP TABLE Habilidad CASCADE CONSTRAINTS;
--DROP TABLE Entrenador CASCADE CONSTRAINTS;
--DROP TABLE Ataque CASCADE CONSTRAINTS;
--DROP TABLE Pokedex CASCADE CONSTRAINTS; 
--DROP TABLE Resumen_Torneo;
--DROP TABLE Equipo_Entrenador;
--DROP TABLE Batalla;
