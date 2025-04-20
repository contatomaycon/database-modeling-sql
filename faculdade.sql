-- Criação do banco de dados (caso não exista)
CREATE DATABASE IF NOT EXISTS faculdade;
USE faculdade;

-- Tabela Curso
CREATE TABLE Curso (
    idCurso       INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso    VARCHAR(100) NOT NULL,
    tipo          VARCHAR(50) NOT NULL,         -- Ex: Bacharelado, Licenciatura, Tecnólogo
    duracao_semestres INT NOT NULL
) ENGINE=InnoDB;

-- Tabela Aluno
CREATE TABLE Aluno (
    idAluno       INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    cpf           CHAR(11) UNIQUE,
    endereco      VARCHAR(200),
    telefone      VARCHAR(15),
    idCurso       INT NOT NULL,
    FOREIGN KEY (idCurso) REFERENCES Curso(idCurso)
        ON DELETE RESTRICT    -- Impede deletar curso com alunos; ou CASCADE se desejado
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela Professor
CREATE TABLE Professor (
    idProfessor   INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    titulacao     VARCHAR(50),    -- Ex: Especialista, Mestre, Doutor
    cpf           CHAR(11) UNIQUE,
    email         VARCHAR(100),
    telefone      VARCHAR(15)
) ENGINE=InnoDB;

-- Tabela Disciplina
CREATE TABLE Disciplina (
    idDisciplina  INT AUTO_INCREMENT PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL,
    idCurso       INT NOT NULL,
    FOREIGN KEY (idCurso) REFERENCES Curso(idCurso)
        ON DELETE CASCADE      -- Se um curso for removido, remove suas disciplinas
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela Turma
CREATE TABLE Turma (
    idTurma       INT AUTO_INCREMENT PRIMARY KEY,
    idDisciplina  INT NOT NULL,
    idCurso       INT NOT NULL,
    idProfessor   INT NOT NULL,
    semestre      TINYINT NOT NULL,    -- 1 ou 2 (semestre letivo)
    ano           YEAR NOT NULL,       -- ano letivo, ex: 2025
    horario       VARCHAR(50),         -- ex: "2a 08:00-10:00"
    sala          VARCHAR(20),
    FOREIGN KEY (idDisciplina) REFERENCES Disciplina(idDisciplina)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (idCurso) REFERENCES Curso(idCurso)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (idProfessor) REFERENCES Professor(idProfessor)
        ON DELETE RESTRICT    -- Não permitir excluir professor se ele tem turmas
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabela Matricula (Aluno_Turma)
CREATE TABLE Matricula (
    idMatricula   INT AUTO_INCREMENT PRIMARY KEY,
    idAluno       INT NOT NULL,
    idTurma       INT NOT NULL,
    nota1         DECIMAL(5,2),
    nota2         DECIMAL(5,2),
    media         DECIMAL(5,2),
    situacao      VARCHAR(20),        -- Ex: "Aprovado", "Reprovado", "Em curso"
    FOREIGN KEY (idAluno) REFERENCES Aluno(idAluno)
        ON DELETE CASCADE     -- Se aluno for removido, removemos suas matrículas
        ON UPDATE CASCADE,
    FOREIGN KEY (idTurma) REFERENCES Turma(idTurma)
        ON DELETE CASCADE     -- Se turma for removida, removemos registros de matrícula
        ON UPDATE CASCADE,
    CONSTRAINT uc_AlunoTurma UNIQUE (idAluno, idTurma)  -- Assegura que um aluno não se matricule 2x na mesma turma
) ENGINE=InnoDB;
