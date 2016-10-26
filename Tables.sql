CREATE TABLE pokemon(
	id int CHECK (id>=0) PRIMARY KEY,
	nombre varchar2(20) not null,
	hp int CHECK (hp>=0),
	ataque int CHECK (ataque>=0),
	ataque_especial int CHECK (ataque_especial>=0),
	defensa_especial int CHECK (defensa_especial>=0),
	velocidad int CHECK (velocidad>=0),
	evoluciona_de int CHECK (evoluciona_de>=0),
	metodo_evolucion varchar2(20)
);

ALTER TABLE pokemon ADD 
	CONSTRAINT B FOREIGN KEY(evoluciona_de)
	REFERENCES pokemon(id);

CREATE TABLE tipo(
	id int CHECK (id>=0) PRIMARY KEY,
	nombre varchar2(20) not null
);

CREATE TABLE Tipo_Efectivo_Tipo(
	id_tipo1 int CHECK (id_tipo1>=0),
	id_tipo2 int CHECK (id_tipo2>=0),
	PRIMARY KEY (id_tipo1,id_tipo2),
	efectividad number(4,2) CHECK (efectividad>=0),
	FOREIGN KEY (id_tipo1) REFERENCES tipo(id),
	FOREIGN KEY (id_tipo2) REFERENCES tipo(id)
);

CREATE TABLE Pokemon_Tipo(
	id_pokemon int CHECK (id_pokemon>=0),
	id_tipo1 int CHECK (id_tipo1>=0),
	id_tipo2 int CHECK (id_tipo2>=0),
	PRIMARY KEY (id_tipo1,id_pokemon),
	FOREIGN KEY (id_pokemon) REFERENCES pokemon(id),
	FOREIGN KEY (id_tipo1) REFERENCES tipo(id),
	FOREIGN KEY (id_tipo2) REFERENCES tipo(id)
);

CREATE TABLE Habilidad(
	id int CHECK (id>=0) PRIMARY KEY,
	nombre varchar2(20) not null,
	descripcion varchar2(100)
);

CREATE TABLE Entrenador(
	id int CHECK (id>=0) PRIMARY KEY,
	nombre varchar2(20) not null,
	pueblo_origen varchar2(20),
	dinero number(20,3) CHECK (dinero>=0),
	fecha_inicio date,
	id_pokedex int CHECK (id_pokedex>=0)
);

CREATE TABLE Ataque(
	id int CHECK (id>=0) PRIMARY KEY,
	nombre varchar2(20) not null,
	categoria varchar2(20),
	poder int CHECK (poder>=0),
	precision int CHECK (precision>=0),
	cantidad_veces int CHECK (cantidad_veces>=0),
	descripcion varchar2(100),
	id_tipo int CHECK (id_tipo>=0),
	FOREIGN KEY (id_tipo) REFERENCES tipo(id)
);

CREATE TABLE Pokedex(
	id int CHECK (id>=0) PRIMARY KEY,
	cantidad_vistos int CHECK (cantidad_vistos>=0),
	cantidad_obtenidos int CHECK (cantidad_obtenidos>=0)
);

ALTER TABLE Entrenador ADD 
	CONSTRAINT A FOREIGN KEY(id_pokedex)
	REFERENCES Pokedex(id);

CREATE TABLE Resumen_Torneo(
	id_entrenador1 int CHECK (id_entrenador1>=0),
	id_entrenador2 int CHECK (id_entrenador2>=0),
	fase varchar2(20),
	fecha_encuentro date,
	ganador int CHECK (ganador>=0),
	PRIMARY KEY (id_entrenador1,id_entrenador2),
	FOREIGN KEY (ganador) REFERENCES Entrenador(id)
	FOREIGN KEY (id_entrenador1) REFERENCES Entrenador(id),
	FOREIGN KEY (id_entrenador2) REFERENCES Entrenador(id)
);

CREATE TABLE Equipo_Entrenador(
	id_entrenador int CHECK (id_entrenador>=0),
	id_pokemon int CHECK (id_pokemon>=0),
	genero varchar2(20),
	nivel int CHECK (nivel>=0),
	exp_actual int CHECK (exp_actual>=0),
	exp_necesaria int CHECK (exp_necesaria>=0),
	id_ataque1 int CHECK (id_ataque1>=0),
	id_ataque2 int CHECK (id_ataque2>=0),
	id_ataque3 int CHECK (id_ataque3>=0),
	id_ataque4 int CHECK (id_ataque4>=0),
	id_habilidad int CHECK (id_habilidad>=0),
	PRIMARY KEY (id_entrenador,id_pokemon),
	FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id),
	FOREIGN KEY (id_pokemon) REFERENCES pokemon(id),
	FOREIGN KEY (id_ataque1) REFERENCES ataque(id),
	FOREIGN KEY (id_ataque2) REFERENCES ataque(id),
	FOREIGN KEY (id_ataque3) REFERENCES ataque(id),
	FOREIGN KEY (id_ataque4) REFERENCES ataque(id),
	FOREIGN KEY (id_habilidad) REFERENCES Habilidad(id)
);

CREATE TABLE Batalla(
	id_batalla int CHECK (id_batalla>=0) PRIMARY KEY,
	id_entrenador1 int CHECK (id_entrenador1>=0),
	id_pokemon1 int CHECK (id_pokemon1>=0),
	id_entrenador2 int CHECK (id_entrenador2>=0),
	id_pokemon2 int CHECK (id_pokemon2>=0),
	dinero_ganado int CHECK (dinero_ganado>=0),
	exp_ganada int CHECK (exp_ganada>=0),
	pokemon_ganador int CHECK (pokemon_ganador>=0),
	entrenador_ganador int CHECK (entrenador_ganador>=0),
	FOREIGN KEY (id_entrenador1) REFERENCES Entrenador(id),
	FOREIGN KEY (id_entrenador2) REFERENCES Entrenador(id),
	FOREIGN KEY (id_pokemon1) REFERENCES pokemon(id),
	FOREIGN KEY (id_pokemon2) REFERENCES pokemon(id),
	FOREIGN KEY (entrenador_ganador) REFERENCES Entrenador(id),
	FOREIGN KEY (pokemon_ganador) REFERENCES pokemon(id)
);
