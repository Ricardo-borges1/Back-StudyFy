-- Criação do banco de dados
create DATABASE StudyFy;

USE StudyFy;


-- CRIAÇÃO DE TABELAS --

-- Tabela tbl_mentor
CREATE TABLE tbl_mentor (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    data_ingresso TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Tabela tbl_grupo_mentoria
CREATE TABLE tbl_grupo_mentoria (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(100) NOT NULL,
    capacidade INT NOT NULL,
    descricao TINYTEXT,
    foto_perfil VARCHAR(300),
    serie_min INT,
    serie_max INT,
    chat_aberto TINYINT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    mentor_id INT NOT NULL,
    FOREIGN KEY (mentor_id) REFERENCES tbl_mentor(id)
);

-- Tabela tbl_atividade_grupo_mentoria
CREATE TABLE tbl_atividade_grupo_mentoria (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TINYTEXT NOT NULL,
    grupo_mentoria_id INT NOT NULL,
    FOREIGN KEY (grupo_mentoria_id) REFERENCES tbl_grupo_mentoria(id)
);

-- Tabela tbl_tipo_questao
CREATE TABLE tbl_tipo_questao (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    tipo_questao VARCHAR(45) NOT NULL
);

-- Tabela tbl_questao
CREATE TABLE tbl_questao (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    enunciado VARCHAR(45) NOT NULL,
    tipo_questao_id INT NOT NULL,
    imagem VARCHAR(300),
    atividade_grupo_mentoria_id INT NOT NULL,
    FOREIGN KEY (atividade_grupo_mentoria_id) REFERENCES tbl_atividade_grupo_mentoria(id),
    FOREIGN KEY (tipo_questao_id) REFERENCES tbl_tipo_questao(id)
);

-- Tabela tbl_resposta_lacunas
CREATE TABLE tbl_resposta_lacunas (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    posicao_inicial INT NOT NULL,
    posicao_fim INT NOT NULL,
    questao_id INT NOT NULL,
    palavra VARCHAR(45),
    FOREIGN KEY (questao_id) REFERENCES tbl_questao(id)
);

-- Tabela tbl_resposta_verdadeiro_falso
CREATE TABLE tbl_resposta_verdadeiro_falso (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    autenticacao TINYINT NOT NULL,
    questao_id INT NOT NULL,
    conteudo VARCHAR(45),
    FOREIGN KEY (questao_id) REFERENCES tbl_questao(id)
);

-- Tabela tbl_resposta_correspondencia
CREATE TABLE tbl_resposta_correspondencia (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    palavra_correspondente VARCHAR(45) NOT NULL,
    resposta_correspondente VARCHAR(45) NOT NULL,
    questao_id INT NOT NULL,
    FOREIGN KEY (questao_id) REFERENCES tbl_questao(id)
);

-- Tabela tbl_resposta_multipla_escolha
CREATE TABLE tbl_resposta_multipla_escolha (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    conteudo TINYTEXT NOT NULL,
    autenticacao TINYINT NOT NULL,
    questao_id INT NOT NULL,
    FOREIGN KEY (questao_id) REFERENCES tbl_questao(id)
);

-- Tabela tbl_ordem_palavra
CREATE TABLE tbl_ordem_palavra (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    posicao INT NOT NULL,
    questao_id INT NOT NULL,
    conteudo VARCHAR(45) NOT NULL,
    FOREIGN KEY (questao_id) REFERENCES tbl_questao(id)
);

-- Tabela tbl_materias
CREATE TABLE tbl_materias (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome_materia VARCHAR(90) NOT NULL
);

-- Criação da tabela ranks
CREATE TABLE  tbl_ranks(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    nivel INT NOT NULL,
    num_salas INT NOT NULL
);



DELETE FROM tbl_professor_materias 
WHERE professor_id BETWEEN 21 AND 29;

DELETE FROM tbl_professor 
WHERE id BETWEEN 21 AND 29;





-- Criação da tabela tbl_temporadas
CREATE TABLE tbl_temporadas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_inicio DATE NOT NULL,  -- Data de início da temporada
    data_fim DATE NOT NULL      -- Data de término da temporada
);


-- Criação da tabela tbl_salas
CREATE TABLE tbl_salas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_rank INT,  -- Referência ao rank da sala
    numero INT,
    max_pessoas INT DEFAULT 25,
    pessoas_atual INT DEFAULT 0,
    temporada_id INT,  -- Chave estrangeira para a temporada
    FOREIGN KEY (id_rank) REFERENCES tbl_ranks(id),
    FOREIGN KEY (temporada_id) REFERENCES tbl_temporadas(id)  -- Chave estrangeira para a temporada atual
);


-- Tabela tbl_alunos
CREATE TABLE tbl_alunos (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(90),
    email VARCHAR(256),
    senha VARCHAR(25) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    serie VARCHAR(20) NOT NULL,
    pontos INT DEFAULT 0,
    id_rank INT DEFAULT 1,
    FOREIGN KEY (id_rank) REFERENCES tbl_ranks(id)
);

CREATE TABLE tbl_salas_alunos (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    aluno_id INT NOT NULL,
    sala_id INT NOT NULL,
    FOREIGN KEY (aluno_id) REFERENCES tbl_alunos(id),
    FOREIGN KEY (sala_id) REFERENCES tbl_salas(id),
    UNIQUE (aluno_id, sala_id)  -- Para garantir que um aluno não possa estar na mesma sala mais de uma vez
);

CREATE TABLE tbl_alunos_ranks (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    aluno_id INT NOT NULL,
    rank_id INT NOT NULL,
    pontos_rank INT DEFAULT 0,
    FOREIGN KEY (aluno_id) REFERENCES tbl_alunos(id),
    FOREIGN KEY (rank_id) REFERENCES tbl_ranks(id)
);


-- Tabela tbl_alunos_materiais
CREATE TABLE tbl_alunos_materias (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    aluno_id INT NOT NULL,
    materia_id INT NOT NULL,
    FOREIGN KEY (aluno_id) REFERENCES tbl_alunos(id),
    FOREIGN KEY (materia_id) REFERENCES tbl_materias(id)
);


-- Tabela tbl_professor
CREATE TABLE tbl_professor (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(90),
    email VARCHAR(256),
    senha VARCHAR(25) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

-- Tabela tbl_professor_materias
CREATE TABLE tbl_professor_materias (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    professor_id INT NOT NULL,
    materia_id INT NOT NULL,
    FOREIGN KEY (professor_id) REFERENCES tbl_professor(id),
    FOREIGN KEY (materia_id) REFERENCES tbl_materias(id)
);

-- Tabela tbl_membros
CREATE TABLE tbl_membros (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    aluno_id INT NOT NULL,
    grupo_mentoria_id INT NOT NULL,
    FOREIGN KEY (aluno_id) REFERENCES tbl_alunos(id),
    FOREIGN KEY (grupo_mentoria_id) REFERENCES tbl_grupo_mentoria(id)
);

-- Tabela tbl_duvida_compartilhada
CREATE TABLE tbl_duvida_compartilhada (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    conteudo TEXT,
    data_envio VARCHAR(45),
    membro_id INT NOT NULL,
    respondida boolean default false,
    FOREIGN KEY (membro_id) REFERENCES tbl_membros(id)
);


-- Tabela tbl_resposta_duvida
CREATE TABLE tbl_resposta_duvida (
    id_resposta_duvida INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    conteudo VARCHAR(45) NOT NULL,
    data_resposta VARCHAR(45),
    duvida_compartilhada_id INT NOT NULL,
    mentor_id INT NOT NULL,
    FOREIGN KEY (duvida_compartilhada_id) REFERENCES tbl_duvida_compartilhada(id),
    FOREIGN KEY (mentor_id) REFERENCES tbl_mentor(id)
);



-- Tabela tbl_professor_mentor
CREATE TABLE tbl_professor_mentor (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    professor_id INT NOT NULL,
    mentor_id INT NOT NULL,
    FOREIGN KEY (professor_id) REFERENCES tbl_professor(id),
    FOREIGN KEY (mentor_id) REFERENCES tbl_mentor(id)
);

-- Tabela tbl_aluno_mentor
CREATE TABLE tbl_aluno_mentor (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    aluno_id INT NOT NULL,
    mentor_id INT NOT NULL,
    FOREIGN KEY (aluno_id) REFERENCES tbl_alunos(id),
    FOREIGN KEY (mentor_id) REFERENCES tbl_mentor(id)
);



CREATE TABLE tbl_emblema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    icone VARCHAR(255) -- Caminho para o ícone do emblema
);

CREATE TABLE tbl_nivel_emblema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_emblema INT,
    nivel INT NOT NULL, -- Nível do emblema (ex: 1, 2, 3, etc.)
    meta VARCHAR(100) NOT NULL, -- Meta para atingir esse nível (ex: 100 atividades)
    FOREIGN KEY (id_emblema) REFERENCES tbl_emblema(id) ON DELETE CASCADE
);


CREATE TABLE tbl_aluno_emblema (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT,
    id_nivel_emblema INT,  -- Relaciona com o nível do emblema
    data_conquista DATE NOT NULL, -- Data em que o aluno alcançou o nível
    FOREIGN KEY (id_aluno) REFERENCES tbl_alunos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_nivel_emblema) REFERENCES tbl_nivel_emblema(id) ON DELETE CASCADE
);




-- INSERTS 


-- Inserir dados na tabela tbl_mentor
INSERT INTO tbl_mentor (data_ingresso) VALUES
(NOW());


-- Inserir dados na tabela tbl_grupo_mentoria
INSERT INTO tbl_grupo_mentoria (nome, capacidade, descricao, foto_perfil, serie_min, serie_max, chat_aberto, mentor_id) VALUES
('Grupo A', 10, 'Descrição do Grupo A', 'foto_grupo_a.jpg', 1, 3, 1, 1);

-- Inserir dados na tabela tbl_tipo_questao
INSERT INTO tbl_tipo_questao (tipo_questao) VALUES
('Múltipla Escolha'),
('Verdadeiro ou Falso'),
('Preenchimento de Lacunas');

-- Inserir dados na tabela tbl_atividade_grupo_mentoria
INSERT INTO tbl_atividade_grupo_mentoria (nome, descricao, grupo_mentoria_id) VALUES
('Atividade 1', 'Descrição da Atividade 1', 1);

-- Inserir dados na tabela tbl_questao
INSERT INTO tbl_questao (enunciado, tipo_questao_id, imagem, atividade_grupo_mentoria_id) VALUES
('Qual é a capital do Brasil?', 1, 'imagem1.jpg', 1),
('O céu é azul?', 2, NULL, 1);

-- Inserir dados na tabela tbl_resposta_lacunas
INSERT INTO tbl_resposta_lacunas (posicao_inicial, posicao_fim, questao_id, palavra) VALUES
(0, 5, 1, 'Brasília');

-- Inserir dados na tabela tbl_resposta_verdadeiro_falso
INSERT INTO tbl_resposta_verdadeiro_falso (autenticacao, questao_id, conteudo) VALUES
(1, 2, 'Sim');

-- Inserir dados na tabela tbl_resposta_correspondencia
INSERT INTO tbl_resposta_correspondencia (palavra_correspondente, resposta_correspondente, questao_id) VALUES
('Brasil', 'Brasília', 1);

-- Inserir dados na tabela tbl_resposta_multipla_escolha
INSERT INTO tbl_resposta_multipla_escolha (conteudo, autenticacao, questao_id) VALUES
('Brasília', 1, 1),
('Rio de Janeiro', 0, 1);

-- Inserir dados na tabela tbl_ordem_palavra
INSERT INTO tbl_ordem_palavra (posicao, questao_id, conteudo) VALUES
(1, 1, 'Brasília');

-- Inserir dados na tabela tbl_materias
INSERT INTO tbl_materias (nome_materia) VALUES
('Matemática'),
('Português'),
('História');

-- Inserir dados na tabela tbl_ranks
INSERT INTO tbl_ranks (nome, nivel, num_salas) VALUES
('Iniciante', 1, 5),
('Intermediário', 2, 10);

-- Inserir dados na tabela tbl_temporadas
INSERT INTO tbl_temporadas (data_inicio, data_fim) VALUES
('2024-01-01', '2024-06-30');

-- Inserir dados na tabela tbl_salas
INSERT INTO tbl_salas (id_rank, numero, max_pessoas, pessoas_atual, temporada_id) VALUES
(1, 101, 25, 5, 1),
(2, 102, 30, 10, 1);


INSERT INTO tbl_professor (nome, email, senha, data_nascimento, telefone) VALUES
('Professor 1', 'professor1@example.com', 'senha123', '1980-01-01', '1234567890'),
('Professor 2', 'professor2@example.com', 'senha123', '1981-02-02', '1234567891'),
('Professor 3', 'professor3@example.com', 'senha123', '1982-03-03', '1234567892'),
('Professor 4', 'professor4@example.com', 'senha123', '1983-04-04', '1234567893'),
('Professor 5', 'professor5@example.com', 'senha123', '1984-05-05', '1234567894'),
('Professor 6', 'professor6@example.com', 'senha123', '1985-06-06', '1234567895'),
('Professor 7', 'professor7@example.com', 'senha123', '1986-07-07', '1234567896'),
('Professor 8', 'professor8@example.com', 'senha123', '1987-08-08', '1234567897'),
('Professor 9', 'professor9@example.com', 'senha123', '1988-09-09', '1234567898'),
('Professor 10', 'professor10@example.com', 'senha123', '1989-10-10', '1234567899'),
('Professor 11', 'professor11@example.com', 'senha123', '1990-11-11', '1234567800'),
('Professor 12', 'professor12@example.com', 'senha123', '1991-12-12', '1234567801'),
('Professor 13', 'professor13@example.com', 'senha123', '1992-01-13', '1234567802'),
('Professor 14', 'professor14@example.com', 'senha123', '1993-02-14', '1234567803'),
('Professor 15', 'professor15@example.com', 'senha123', '1994-03-15', '1234567804'),
('Professor 16', 'professor16@example.com', 'senha123', '1995-04-16', '1234567805'),
('Professor 17', 'professor17@example.com', 'senha123', '1996-05-17', '1234567806'),
('Professor 18', 'professor18@example.com', 'senha123', '1997-06-18', '1234567807'),
('Professor 19', 'professor19@example.com', 'senha123', '1998-07-19', '1234567808'),
('Professor 20', 'professor20@example.com', 'senha123', '1999-08-20', '1234567809'),
('Professor 21', 'professor21@example.com', 'senha123', '2000-09-21', '1234567810'),
('Professor 22', 'professor22@example.com', 'senha123', '2001-10-22', '1234567811'),
('Professor 23', 'professor23@example.com', 'senha123', '2002-11-23', '1234567812'),
('Professor 24', 'professor24@example.com', 'senha123', '2003-12-24', '1234567813'),
('Professor 25', 'professor25@example.com', 'senha123', '2004-01-25', '1234567814'),
('Professor 26', 'professor26@example.com', 'senha123', '2005-02-26', '1234567815'),
('Professor 27', 'professor27@example.com', 'senha123', '2006-03-27', '1234567816'),
('Professor 28', 'professor28@example.com', 'senha123', '2007-04-28', '1234567817'),
('Professor 29', 'professor29@example.com', 'senha123', '2008-05-29', '1234567818'),
('Professor 30', 'professor30@example.com', 'senha123', '2009-06-30', '1234567819'),
('Professor 31', 'professor31@example.com', 'senha123', '2010-07-31', '1234567820'),
('Professor 32', 'professor32@example.com', 'senha123', '2011-08-01', '1234567821'),
('Professor 33', 'professor33@example.com', 'senha123', '2012-09-02', '1234567822'),
('Professor 34', 'professor34@example.com', 'senha123', '2013-10-03', '1234567823'),
('Professor 35', 'professor35@example.com', 'senha123', '2014-11-04', '1234567824'),
('Professor 36', 'professor36@example.com', 'senha123', '2015-12-05', '1234567825'),
('Professor 37', 'professor37@example.com', 'senha123', '2016-01-06', '1234567826'),
('Professor 38', 'professor38@example.com', 'senha123', '2017-02-07', '1234567827'),
('Professor 39', 'professor39@example.com', 'senha123', '2018-03-08', '1234567828'),
('Professor 40', 'professor40@example.com', 'senha123', '2019-04-09', '1234567829'),
('Professor 41', 'professor41@example.com', 'senha123', '2020-05-10', '1234567830'),
('Professor 42', 'professor42@example.com', 'senha123', '2021-06-11', '1234567831'),
('Professor 43', 'professor43@example.com', 'senha123', '2022-07-12', '1234567832'),
('Professor 44', 'professor44@example.com', 'senha123', '2023-08-13', '1234567833'),
('Professor 45', 'professor45@example.com', 'senha123', '2024-09-14', '1234567834'),
('Professor 46', 'professor46@example.com', 'senha123', '2025-10-15', '1234567835'),
('Professor 47', 'professor47@example.com', 'senha123', '2026-11-16', '1234567836'),
('Professor 48', 'professor48@example.com', 'senha123', '2027-12-17', '1234567837'),
('Professor 49', 'professor49@example.com', 'senha123', '2028-01-18', '1234567838'),
('Professor 50', 'professor50@example.com', 'senha123', '2029-02-19', '1234567839');


DELETE FROM tbl_professor 
WHERE id BETWEEN 51 AND 69;






-- Inserir dados na tabela tbl_alunos
INSERT INTO tbl_alunos (nome, email, senha, data_nascimento, telefone, serie, pontos, id_rank) VALUES
('Aluno 1', 'aluno1@example.com', 'senha123', '2005-01-01', '123456789', '1ª série', 0, 1),
('Aluno 2', 'aluno2@example.com', 'senha456', '2005-02-01', '987654321', '2ª série', 0, 1);

UPDATE tbl_alunos 
SET senha = 'novaSenha' 
WHERE id = 1;

select * from tbl_alunos;

-- Inserir dados na tabela tbl_salas_alunos
INSERT INTO tbl_salas_alunos (aluno_id, sala_id) VALUES
(1, 1),
(2, 1);

-- Inserir dados na tabela tbl_alunos_ranks
INSERT INTO tbl_alunos_ranks (aluno_id, rank_id, pontos_rank) VALUES
(1, 1, 10),
(2, 1, 20);

-- Inserir dados na tabela tbl_alunos_materias
INSERT INTO tbl_alunos_materias (aluno_id, materia_id) VALUES
(1, 1),
(1, 2),
(2, 3);

-- Inserir dados na tabela tbl_professor
INSERT INTO tbl_professor (nome, email, senha, data_nascimento, telefone) VALUES
('Professor A', 'professor_a@example.com', 'senha123', '1980-01-01', '123456789'),
('Professor B', 'professor_b@example.com', 'senha456', '1985-02-01', '987654321');

-- Inserir dados na tabela tbl_professor_materias
INSERT INTO tbl_professor_materias (professor_id, materia_id) VALUES
(1, 1),
(2, 2);

-- Inserir dados na tabela tbl_membros
INSERT INTO tbl_membros (aluno_id, grupo_mentoria_id) VALUES
(1, 1),
(2, 1);

-- Inserir dados na tabela tbl_duvida_compartilhada
INSERT INTO tbl_duvida_compartilhada (conteudo, data_envio, membro_id, respondida) VALUES
('Qual é a dúvida?', '2024-01-10', 1, false);

-- Inserir dados na tabela tbl_resposta_duvida
INSERT INTO tbl_resposta_duvida (conteudo, data_resposta, duvida_compartilhada_id, mentor_id) VALUES
('Aqui está a resposta', '2024-01-11', 1, 1);

-- Inserir dados na tabela tbl_professor_mentor
INSERT INTO tbl_professor_mentor (professor_id, mentor_id) VALUES
(1, 1);

-- Inserir dados na tabela tbl_aluno_mentor
INSERT INTO tbl_aluno_mentor (aluno_id, mentor_id) VALUES
(1, 1);

-- Inserir dados na tabela tbl_emblema
INSERT INTO tbl_emblema (nome, descricao, icone) VALUES
('Emblema de Ouro', 'Descrição do emblema de ouro', 'icone_ouro.png'),
('Emblema de Prata', 'Descrição do emblema de prata', 'icone_prata.png');

-- Inserir dados na tabela tbl_nivel_emblema
INSERT INTO tbl_nivel_emblema (id_emblema, nivel, meta) VALUES
(1, 1, 'Concluir 5 atividades'),
(1, 2, 'Concluir 10 atividades'),
(2, 1, 'Concluir 15 atividades');


-- Inserir dados na tabela tbl_aluno_emblema
INSERT INTO tbl_aluno_emblema (id_aluno, id_nivel_emblema, data_conquista) VALUES
(1, 1, '2024-01-15'),
(1, 2, '2024-02-10'),
(2, 1, '2024-01-20');


INSERT INTO tbl_temporadas (data_inicio, data_fim)
    VALUES (
        DATE_ADD((SELECT MAX(t.data_fim) FROM (SELECT data_fim FROM tbl_temporadas) t), INTERVAL 2 DAY),
        DATE_ADD((SELECT MAX(t.data_fim) FROM (SELECT data_fim FROM tbl_temporadas) t), INTERVAL 22 DAY)
    );





-- SELECTS, DELETES E UPDATES -- 

-- Seleciona os alunos e a sala em que estão
SELECT 
    tbl_alunos.id AS id_aluno,           -- ID do aluno
    tbl_alunos.nome AS nome_aluno,       -- Nome do aluno
    tbl_salas.id AS id_sala,             -- ID da sala
    tbl_salas.numero AS numero_sala       -- Número da sala
FROM 
    tbl_alunos
JOIN 
    tbl_salas_alunos ON tbl_alunos.id = tbl_salas_alunos.aluno_id  -- Junta alunos com salas que frequentam
JOIN 
    tbl_salas ON tbl_salas_alunos.sala_id = tbl_salas.id           -- Junta com a tabela de salas
WHERE 
    tbl_salas.id = 1;  -- Substitua 1 pelo ID da sala desejada para filtrar os alunos dessa sala
    
    
    
/*mostra todos os emblemas que um aluno tem, com base no nivel atual*/

SELECT 
    emblema.id AS emblema_id,
    emblema.nome AS emblema_nome,
    nivel_atual.nivel AS nivel_atual,
    nivel_atual.meta AS meta_atual,
    proximo_nivel.nivel AS proximo_nivel,
    proximo_nivel.meta AS meta_proxima
FROM 
    tbl_emblema AS emblema
JOIN 
    tbl_nivel_emblema AS nivel_atual ON emblema.id = nivel_atual.id_emblema
LEFT JOIN 
    tbl_nivel_emblema AS proximo_nivel ON emblema.id = proximo_nivel.id_emblema AND proximo_nivel.nivel = nivel_atual.nivel + 1
WHERE 
    nivel_atual.id IN (
        SELECT id_nivel_emblema 
        FROM tbl_aluno_emblema 
        WHERE id_aluno = 1  -- Substitua 1 pelo ID do aluno
    )
AND 
    nivel_atual.nivel = (
        SELECT MAX(nivel) 
        FROM tbl_nivel_emblema 
        WHERE id_emblema = emblema.id AND 
              id IN (
                  SELECT id_nivel_emblema 
                  FROM tbl_aluno_emblema 
                  WHERE id_aluno = 1  -- Substitua 1 pelo ID do aluno
              )
    );



    


/*mostra os emblemas que o aluno ainda não tem*/

SELECT 
    n.id AS nivel_emblema_id,
    n.nivel,
    e.id AS emblema_id,
    e.nome AS emblema_nome,
    n.meta
FROM 
    tbl_nivel_emblema n
JOIN 
    tbl_emblema e ON n.id_emblema = e.id
WHERE 
    n.nivel = 1 
    AND n.id NOT IN (
        SELECT id_nivel_emblema 
        FROM tbl_aluno_emblema 
        WHERE id_aluno = 1  -- Substitua ? pelo ID do aluno
    );


-- Seleciona alunos e seus pontos de ranking em uma sala específica
SELECT 
    tbl_alunos.id AS id_aluno,                            -- ID do aluno
    tbl_alunos.nome AS nome_aluno,                        -- Nome do aluno
    tbl_alunos_ranks.pontos_rank AS pontos_aluno,       -- Pontos do aluno no ranking
    ROW_NUMBER() OVER (ORDER BY tbl_alunos_ranks.pontos_rank DESC) AS posicao  -- Calcula a posição no ranking
FROM 
    tbl_alunos 
JOIN 
    tbl_salas_alunos ON tbl_alunos.id = tbl_salas_alunos.aluno_id  -- Junta alunos com salas que frequentam
JOIN 
    tbl_salas ON tbl_salas_alunos.sala_id = tbl_salas.id           -- Junta com a tabela de salas
JOIN 
    tbl_alunos_ranks ON tbl_alunos.id = tbl_alunos_ranks.aluno_id  -- Junta com a tabela de ranking dos alunos
WHERE 
    tbl_salas.id = 2  -- Filtra para incluir apenas alunos na sala cujo ID é 2
    AND tbl_alunos_ranks.rank_id = tbl_salas.id_rank  -- Garante que o rank_id da sala corresponda ao do aluno
ORDER BY 
    tbl_alunos_ranks.pontos_rank DESC;  -- Ordena os resultados por pontos de forma decrescente



-- Seleciona alunos e seus pontos de ranking na sala 1, permitindo alunos sem ranking
SELECT 
   tbl_alunos.id AS id_aluno,                               -- ID do aluno
   tbl_alunos.nome AS nome_aluno,                           -- Nome do aluno
   tbl_alunos_ranks.pontos_rank AS pontos_aluno,          -- Pontos do aluno no ranking
   ROW_NUMBER() OVER (ORDER BY tbl_alunos_ranks.pontos_rank DESC) AS posicao  -- Calcula a posição no ranking
FROM 
   tbl_alunos 
JOIN 
   tbl_salas_alunos ON tbl_alunos.id = tbl_salas_alunos.aluno_id  -- Junta alunos com salas que frequentam
JOIN 
   tbl_salas ON tbl_salas_alunos.sala_id = tbl_salas.id           -- Junta com a tabela de salas
LEFT JOIN 
   tbl_alunos_ranks ON tbl_alunos.id = tbl_alunos_ranks.aluno_id  -- Junta com a tabela de ranking, permitindo alunos sem ranking
WHERE 
   tbl_salas.id = 1  -- Filtra para incluir apenas alunos na sala cujo ID é 1
ORDER BY 
   tbl_alunos_ranks.pontos_rank DESC;  -- Ordena os resultados por pontos de forma decrescente



    -- Verificar se há alunos e pontos rank inseridos
SELECT * FROM tbl_alunos_ranks;

-- Verificar se há alunos nas salas
SELECT * FROM tbl_salas_alunos;

-- Verificar se há salas criadas
SELECT * FROM tbl_salas;




-- Seleciona informações dos alunos e seus pontos de ranking
SELECT 
    tbl_alunos.id AS id_aluno,                            -- ID do aluno
    tbl_alunos.nome AS nome_aluno,                        -- Nome do aluno
    tbl_alunos_ranks.rank_id AS id_rank,                 -- ID do ranking do aluno
    tbl_alunos_ranks.pontos_rank AS pontos_aluno         -- Pontos do aluno no ranking
FROM 
    tbl_alunos_ranks                                        -- Tabela que contém os ranks dos alunos
JOIN 
    tbl_alunos ON tbl_alunos.id = tbl_alunos_ranks.aluno_id;  -- Junta a tabela de alunos com a tabela de ranks usando o ID do aluno




-- Seleciona todos os registros da tabela tbl_aluno_mentor onde o ID do mentor é 2
select * from tbl_aluno_mentor where mentor_id = 2;

-- Seleciona todos os registros da tabela tbl_professor
select * from tbl_professor;

-- Seleciona todos os registros da tabela tbl_tipo_questao
select * from tbl_tipo_questao;



-- Seleciona informações sobre alunos e mentores para um mentor específico (ID = 3)
SELECT 
    alunos.id AS aluno_id,                            -- ID do aluno
    alunos.nome AS aluno_nome,                        -- Nome do aluno
    mentores.id AS mentor_id,                        -- ID do mentor
    mentores.data_ingresso AS mentor_data_ingresso   -- Data de ingresso do mentor
FROM 
    tbl_aluno_mentor AS aluno_mentor                  -- Tabela que associa alunos e mentores
JOIN 
    tbl_alunos AS alunos ON aluno_mentor.aluno_id = alunos.id  -- Junta a tabela de alunos
JOIN 
    tbl_mentor AS mentores ON aluno_mentor.mentor_id = 3; -- Junta a tabela de mentores para o mentor específico




UPDATE tbl_alunos
            SET
                nome = 'Vitória Fabinho',
                email = 'vitoria@dev.com',
                senha = 'amo o fabinho',
                telefone = '11973473571',
                data_nascimento = '2006-12-04',
                serie = '9° EF'
            WHERE id = 4;
            
            
            
            


-- Verifica se há registros duplicados na tabela tbl_alunos
SELECT id, COUNT(*) FROM tbl_alunos GROUP BY id HAVING COUNT(*) > 1;  -- Conta e agrupa por ID, mostrando apenas IDs com mais de uma ocorrência




-- Verifica se há registros duplicados na tabela tbl_mentor
SELECT id, COUNT(*) FROM tbl_mentor GROUP BY id HAVING COUNT(*) > 1;  -- Conta e agrupa por ID, mostrando apenas IDs com mais de uma ocorrência




-- Conta quantos alunos estão associados a um mentor específico (ID = 3)
SELECT aluno_id, COUNT(*) FROM tbl_aluno_mentor WHERE mentor_id = 3 GROUP BY aluno_id;  -- Agrupa por aluno_id




-- Conta quantas associações um mentor específico (ID = 2) tem com os alunos
SELECT aluno_id, COUNT(*) AS num_associacoes
FROM tbl_aluno_mentor
WHERE mentor_id = 2
GROUP BY aluno_id;  -- Agrupa por aluno_id




-- Seleciona informações sobre membros, alunos e grupos de mentoria para um grupo específico (ID = 1)
SELECT 
    m.id AS membro_id,                             -- ID do membro
    a.id AS aluno_id,                              -- ID do aluno
    a.nome AS aluno_nome,                          -- Nome do aluno
    a.email AS aluno_email,                        -- Email do aluno
    a.telefone AS aluno_telefone,                  -- Telefone do aluno
    a.data_nascimento AS aluno_data_nascimento,    -- Data de nascimento do aluno
    a.serie AS aluno_serie,                        -- Série do aluno
    g.id AS grupo_mentoria_id,                     -- ID do grupo de mentoria
    g.nome AS grupo_mentoria_nome                  -- Nome do grupo de mentoria
FROM 
    tbl_membros m                                  -- Tabela de membros
INNER JOIN 
    tbl_alunos a ON m.aluno_id = a.id             -- Junta a tabela de alunos
INNER JOIN 
    tbl_grupo_mentoria g ON m.grupo_mentoria_id = g.id  -- Junta a tabela de grupos de mentoria
WHERE 
    g.id = 1;                                      -- Filtra pelo ID do grupo de mentoria




-- Seleciona o ID do mentor e a data de ingresso do mentor na tabela tbl_professor_mentor
SELECT
  pm.mentor_id,                            -- ID do mentor associado
  m.data_ingresso                          -- Data de ingresso do mentor
FROM 
  tbl_professor_mentor pm                   -- Tabela que associa professores e mentores
INNER JOIN 
  tbl_mentor m ON pm.mentor_id = m.id     -- Junta com a tabela de mentores com base no mentor_id
LIMIT 0, 1000;                             -- Limita o resultado a 1000 registros





-- Atualiza todos os registros da tabela tbl_professor_mentor, definindo mentor_id como NULL
UPDATE tbl_professor_mentor
SET mentor_id = NULL;                      -- Remove a associação do mentor para todos os registros







-- Seleciona a ID e o nome da matéria associada a um aluno específico (ID = 1)
SELECT 
    m.id AS id,                            -- ID da matéria
    m.nome_materia AS materia              -- Nome da matéria
FROM 
    tbl_alunos a                           -- Tabela de alunos
JOIN 
    tbl_alunos_materias am ON a.id = am.aluno_id  -- Junta com a tabela que associa alunos a matérias
JOIN 
    tbl_materias m ON am.materia_id = m.id -- Junta com a tabela de matérias
WHERE 
    a.id = 1;                               -- Filtra pelo ID do aluno
    
    
    
    
    
    

-- Seleciona todos os registros da tabela tbl_professor_mentor
select * from tbl_professor_mentor;         -- Exibe todos os mentores associados aos professores






-- Seleciona todos os mentores e suas informações, identificando o tipo de mentor
SELECT
  m.id AS mentor_id,                        -- ID do mentor
  m.data_ingresso,                          -- Data de ingresso do mentor
  CASE
    WHEN NOT EXISTS (SELECT 1 FROM tbl_aluno_mentor am WHERE am.mentor_id = m.id)
         AND EXISTS (SELECT 1 FROM tbl_professor_mentor pm WHERE pm.mentor_id = m.id) THEN 'Professor'
    WHEN EXISTS (SELECT 1 FROM tbl_aluno_mentor am WHERE am.mentor_id = m.id) THEN 'Aluno'
    ELSE 'Outro'                            -- Classifica como 'Outro' se não for nem aluno nem professor
  END AS tipo_mentor,
  COALESCE(
    (SELECT a.nome FROM tbl_alunos a WHERE am.aluno_id = a.id),
    (SELECT p.nome FROM tbl_professor p WHERE pm.professor_id = p.id)
  ) AS nome_associado                       -- Obtém o nome do aluno ou professor associado ao mentor
FROM
  tbl_mentor m                              -- Tabela de mentores
LEFT JOIN tbl_professor_mentor pm ON m.id = pm.mentor_id  -- Junta com a tabela de professores mentores
LEFT JOIN tbl_aluno_mentor am ON m.id = am.mentor_id;     -- Junta com a tabela de alunos mentores




-- Seleciona a ID e o nome da matéria associada a um professor específico (ID = 1)
SELECT 
    m.id AS id,                             -- ID da matéria
    m.nome_materia AS materia               -- Nome da matéria
FROM 
    tbl_professor a                        -- Tabela de professores
JOIN 
    tbl_professor_materias am ON a.id = am.professor_id  -- Junta com a tabela que associa professores a matérias
JOIN 
    tbl_materias m ON am.materia_id = m.id -- Junta com a tabela de matérias
WHERE 
    a.id = 1;                              -- Filtra pelo ID do professor





-- Seleciona as dúvidas compartilhadas pelos alunos, mostrando nome, conteúdo e status
SELECT 
    alunos.nome AS Nome_do_Aluno,          -- Nome do aluno que fez a dúvida
    duvidas.conteudo AS Conteudo_da_Dúvida, -- Conteúdo da dúvida enviada
    duvidas.data_envio AS Data_de_Envio,   -- Data em que a dúvida foi enviada
    CASE WHEN duvidas.respondida = 1 THEN 'Respondida' ELSE 'Não respondida' END AS Status_da_Dúvida  -- Status da dúvida
FROM 
    tbl_duvida_compartilhada duvidas        -- Tabela de dúvidas compartilhadas
INNER JOIN 
    tbl_membros membros ON duvidas.membro_id = membros.id -- Junta com a tabela de membros (associados às dúvidas)
INNER JOIN 
    tbl_alunos alunos ON membros.aluno_id = alunos.id;  -- Junta com a tabela de alunos para obter o nome
    
    
    
    
    -- Seleciona as dúvidas de um membro específico (ID = 2)
SELECT 
    d.id,                                     -- ID da dúvida
    d.conteudo,                               -- Conteúdo da dúvida
    d.data_envio,                             -- Data em que a dúvida foi enviada
    d.membro_id,                              -- ID do membro que fez a dúvida
    d.respondida                               -- Indica se a dúvida foi respondida (1 para sim, 0 para não)
FROM 
    tbl_duvida_compartilhada d                -- Tabela de dúvidas compartilhadas
WHERE 
    d.membro_id = 2                           -- Filtra pelo ID do membro
ORDER BY 
    d.data_envio DESC;                        -- Ordena as dúvidas pela data de envio em ordem decrescente




-- Seleciona todas as informações de uma questão e a atividade de grupo de mentoria associada
SELECT 
    q.id AS questao_id,                      -- ID da questão
    q.enunciado,                              -- Enunciado da questão
    q.tipo_questao_id,                       -- ID do tipo da questão
    q.imagem,                                 -- Imagem associada à questão (se houver)
    q.atividade_grupo_mentoria_id,           -- ID da atividade de grupo de mentoria associada
    agm.id AS atividade_id,                   -- ID da atividade de grupo de mentoria
    agm.nome AS atividade_nome,               -- Nome da atividade
    agm.descricao AS atividade_descricao      -- Descrição da atividade
FROM 
    tbl_questao q                            -- Tabela de questões
JOIN 
    tbl_atividade_grupo_mentoria agm ON q.atividade_grupo_mentoria_id = agm.id; -- Junta com a tabela de atividades




-- Seleciona as dúvidas respondidas junto com o nome dos alunos
SELECT 
    alunos.nome AS Nome_do_Aluno,            -- Nome do aluno que fez a dúvida
    duvidas.conteudo AS Conteudo_da_Dúvida,  -- Conteúdo da dúvida
    duvidas.data_envio AS Data_de_Envio       -- Data em que a dúvida foi enviada
FROM 
    tbl_duvida_compartilhada duvidas          -- Tabela de dúvidas compartilhadas
INNER JOIN 
    tbl_membros membros ON duvidas.membro_id = membros.id -- Junta com a tabela de membros para obter informações
INNER JOIN 
    tbl_alunos alunos ON membros.aluno_id = alunos.id -- Junta com a tabela de alunos para obter o nome
WHERE 
    duvidas.respondida = 1;                   -- Filtra apenas as dúvidas que foram respondidas



-- Seleciona todas as informações de um membro específico (ID = 3)
SELECT * 
FROM 
    tbl_membros 
WHERE 
    id = 3;                                   -- Filtra pelo ID do membro




-- SELECT que traz todos os mentores alunos
SELECT 
    alunos.id AS aluno_id,                     -- ID do aluno
    alunos.nome AS aluno_nome,                 -- Nome do aluno
    mentores.id AS mentor_id,                  -- ID do mentor
    mentores.data_ingresso AS mentor_data_ingresso -- Data de ingresso do mentor
FROM 
    tbl_aluno_mentor AS aluno_mentor           -- Tabela que relaciona alunos e mentores
JOIN 
    tbl_alunos AS alunos ON aluno_mentor.aluno_id = alunos.id  -- Junta com a tabela de alunos
JOIN 
    tbl_mentor AS mentores ON aluno_mentor.mentor_id = mentores.id; -- Junta com a tabela de mentores




-- SELECT que traz os mentores alunos por ID
SELECT 
    COUNT(*) AS is_mentor                       -- Conta quantos mentores estão associados ao aluno
FROM 
    tbl_aluno_mentor AS aluno_mentor            -- Tabela que relaciona alunos e mentores
JOIN 
    tbl_alunos AS alunos ON aluno_mentor.aluno_id = alunos.id  -- Junta com a tabela de alunos
JOIN 
    tbl_mentor AS mentores ON aluno_mentor.mentor_id = mentores.id  -- Junta com a tabela de mentores
WHERE 
    alunos.id = 1;                              -- Filtra pelo ID do aluno





-- Seleciona novamente todos os mentores alunos (duplicado do primeiro SELECT)
SELECT 
    alunos.id AS aluno_id,                     -- ID do aluno
    alunos.nome AS aluno_nome,                 -- Nome do aluno
    mentores.id AS mentor_id,                  -- ID do mentor
    mentores.data_ingresso AS mentor_data_ingresso -- Data de ingresso do mentor
FROM 
    tbl_aluno_mentor AS aluno_mentor           -- Tabela que relaciona alunos e mentores
JOIN 
    tbl_alunos AS alunos ON aluno_mentor.aluno_id = alunos.id  -- Junta com a tabela de alunos
JOIN 
    tbl_mentor AS mentores ON aluno_mentor.mentor_id = mentores.id;





-- Seleciona todos os professores e seus mentores associados
SELECT 
    professores.id AS professor_id,            -- ID do professor
    professores.nome AS professor_nome,        -- Nome do professor
    mentores.id AS mentor_id,                  -- ID do mentor
    mentores.data_ingresso AS mentor_data_ingresso -- Data de ingresso do mentor
FROM 
    tbl_professor_mentor AS professor_mentor   -- Tabela que relaciona professores e mentores
JOIN 
    tbl_professor AS professores ON professor_mentor.professor_id = professores.id  -- Junta com a tabela de professores
JOIN 
    tbl_mentor AS mentores ON professor_mentor.mentor_id = mentores.id; -- Junta com a tabela de mentores






-- Seleciona todos os mentores
SELECT * 
FROM 
    tbl_mentor;                                 -- Seleciona todas as colunas da tabela de mentores


-- Seleciona novamente todos os mentores (duplicado do anterior)
SELECT * 
FROM 
    tbl_mentor;                                 -- Seleciona todas as colunas da tabela de mentores


-- Deleta um aluno específico com ID 5
DELETE FROM 
    tbl_alunos 
WHERE 
    id = 5;                                      -- Condição que especifica qual aluno deletar


-- Seleciona todos os grupos de mentoria
SELECT * 
FROM 
    tbl_grupo_mentoria;                        -- Seleciona todas as colunas da tabela de grupos de mentoria


-- Seleciona todas as ordens de palavra
SELECT * 
FROM 
    tbl_ordem_palavra;                        -- Seleciona todas as colunas da tabela de ordem de palavra
    
    
    
    
    
    -------------------------------------------------------------------------------------

DELIMITER ;

-- deletar a relação
DELETE FROM tbl_alunos WHERE id IN (2);

SELECT * FROM tbl_alunos WHERE id > 0;
SELECT CAST(LAST_INSERT_ID() AS DECIMAL) AS id FROM tbl_materias LIMIT 1;

DELIMITER //

CREATE TRIGGER apagar_aluno_materias
BEFORE DELETE ON tbl_alunos
FOR EACH ROW
BEGIN
    -- Apagar as matérias relacionadas ao aluno na tabela de relacionamento
    DELETE FROM tbl_alunos_materias WHERE aluno_id = OLD.id;
END //

DELIMITER //

CREATE TRIGGER apagar_professor_materias
BEFORE DELETE ON tbl_professor
FOR EACH ROW
BEGIN
    -- Apagar as matérias relacionadas ao professor na tabela de relacionamento
    DELETE FROM tbl_professor_materias WHERE professor_id = OLD.id;
END //

DELIMITER ;

SELECT * FROM tbl_materias WHERE id IN (1, 2);



   -------------------------------------------------------------------------------------

-- VIEWS 



-- VIEWS 1 
SELECT 
   tbl_alunos.id AS id_aluno,                               -- ID do aluno
   tbl_alunos.nome AS nome_aluno,                           -- Nome do aluno
   tbl_alunos_ranks.pontos_rank AS pontos_aluno,          -- Pontos do aluno no ranking
   ROW_NUMBER() OVER (ORDER BY tbl_alunos_ranks.pontos_rank DESC) AS posicao  -- Calcula a posição no ranking
FROM 
   tbl_alunos 
JOIN 
   tbl_salas_alunos ON tbl_alunos.id = tbl_salas_alunos.aluno_id  -- Junta alunos com salas que frequentam
JOIN 
   tbl_salas ON tbl_salas_alunos.sala_id = tbl_salas.id           -- Junta com a tabela de salas
LEFT JOIN 
   tbl_alunos_ranks ON tbl_alunos.id = tbl_alunos_ranks.aluno_id  -- Junta com a tabela de ranking, permitindo alunos sem ranking
WHERE 
   tbl_salas.id = 1  -- Filtra para incluir apenas alunos na sala cujo ID é 1
ORDER BY 
   tbl_alunos_ranks.pontos_rank DESC;  -- Ordena os resultados por pontos de forma decrescente




CREATE VIEW vw_alunos_ranking_sala AS
SELECT 
    tbl_alunos.id AS id_aluno,
    tbl_alunos.nome AS nome_aluno,
    tbl_alunos_ranks.pontos_rank AS pontos_aluno,
    ROW_NUMBER() OVER (ORDER BY tbl_alunos_ranks.pontos_rank DESC) AS posicao,
    tbl_salas.id AS sala_id,
    tbl_alunos_ranks.rank_id
FROM 
    tbl_alunos
JOIN 
    tbl_salas_alunos ON tbl_alunos.id = tbl_salas_alunos.aluno_id
JOIN 
    tbl_salas ON tbl_salas_alunos.sala_id = tbl_salas.id
JOIN 
    tbl_alunos_ranks ON tbl_alunos.id = tbl_alunos_ranks.aluno_id;


SELECT * 
FROM vw_alunos_ranking_sala
WHERE sala_id = 1
ORDER BY pontos_aluno DESC;


---------------------------------------------------------------------------------------------------------

