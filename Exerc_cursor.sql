CREATE DATABASE exerc_cursor
GO
USE exerc_cursor

CREATE TABLE Curso(
codigo  INT NOT NULL,
nome    VARCHAR(100) NOT NULL,
duracao INT 
PRIMARY KEY(codigo)
)

CREATE TABLE Disciplinas(
codigo        INT NOT NULL,
nome          VARCHAR(100) NOT NULL,
carga_horaria INT
PRIMARY KEY(codigo)
)

CREATE TABLE Disciplina_Curso(
codigo_disciplina INT,
codigo_curso INT
PRIMARY KEY(codigo_disciplina,codigo_curso)
FOREIGN KEY(codigo_disciplina) REFERENCES Disciplinas(codigo),
FOREIGN KEY(codigo_curso) REFERENCES Curso(codigo)
)

INSERT INTO Curso VALUES
(0,'Análisa e Desenvolvimento de Sistemas',2880),
(1,'Logistica',2880),
(2,'Polímeros',2880),
(3,'Comércio Exterior',2600),
(4,'Gestão Empresarial',2600)

INSERT INTO Disciplinas VALUES
(1,'Algoritmos', 80),
(2,'Administração', 80),
(3,'Laboratório de Hardware',40),
(4,'Pesquisa Operacional',80),
(5,'Física I',80),
(6,'Físico Química',80),
(7,'Comércio Exterior',80),
(8,'Fundamentos de Marketing',80),
(9,'Informática',40),
(10,'Sistemas de Informação',80)

INSERT INTO Disciplina_Curso VALUES
(1,0),(2,0),(2,1),(2,3),(2,4),(3,0),
(4,1),(5,2),(6,2),(7,1),(7,3),(8,1),
(8,4),(9,1),(9,3),(10,0),(10,4)


CREATE FUNCTION fn_disciplinasdoCurso(@cod_curso INT)
RETURNS @tabela TABLE(
Codigo_Disciplina        INT,
Nome_Disciplina          VARCHAR(100),
Carga_Horaria_Disciplina INT,
Nome_Curso               VARCHAR(100))
AS
BEGIN
	DECLARE @codigo_disciplina  INT,
            @nome_disciplina    VARCHAR(100),
			@carga_horaria      INT,
			@nome_curso			VARCHAR(100)

	SET @nome_curso = (SELECT nome FROM Curso WHERE codigo = @cod_curso)

    --CRIAR O CURSOR
    DECLARE cursor_busca        CURSOR FOR
        SELECT codigo_disciplina FROM Disciplina_Curso WHERE codigo_curso = @cod_curso  

    --ABRIR O CURSOR
    OPEN cursor_busca

    --POSICIONAR NO PRIMEIRO REGISTRO
    FETCH NEXT FROM cursor_busca INTO @codigo_disciplina

    --VERIFICAR SE HOUVE REGISTRO
	WHILE @@FETCH_STATUS = 0
    BEGIN

		SELECT @nome_disciplina = nome, @carga_horaria = carga_horaria
		FROM Disciplinas WHERE codigo = @codigo_disciplina
	

		INSERT INTO @tabela VALUES
			(@codigo_disciplina, @nome_disciplina, @carga_horaria,@nome_curso)
		
		--INCREMENTO(POSICIONAR NO PRÓXIMO REGISTRO)
        FETCH NEXT FROM cursor_busca INTO @codigo_disciplina
	END

	CLOSE cursor_busca
    DEALLOCATE cursor_busca
 
    RETURN
END

SELECT * FROM fn_disciplinasdoCurso(2)