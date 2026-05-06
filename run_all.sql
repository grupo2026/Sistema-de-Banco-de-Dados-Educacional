-- SCRIPT DE RESET 

DROP DATABASE IF EXISTS projeto_dados;
CREATE DATABASE projeto_dados;
USE projeto_dados; 
USE projeto_dados; 

/*///////////////// Fase 1: Preparação do Ambiente e DDL ///////////*/

/*////////////// MÓDULO FINANCEIRO ////////////////////////////*/

CREATE TABLE ESCOLA ( 

  CNPJ CHAR(14) PRIMARY KEY, 
  nome VARCHAR(100) NOT NULL, 
  endereco VARCHAR(255) NOT NULL, 
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
); 

CREATE TABLE ESCOLA_TELEFONE ( 
  CNPJ_escola CHAR(14), 
  telefone VARCHAR(20) NOT NULL, 

  PRIMARY KEY (CNPJ_escola, telefone), 
  FOREIGN KEY (CNPJ_escola) REFERENCES ESCOLA(CNPJ) 
); 

CREATE TABLE ESCOLA_EMAIL ( 
  CNPJ_escola CHAR(14), 
  email VARCHAR(100) NOT NULL, 
  
  PRIMARY KEY (CNPJ_escola, email), 
  FOREIGN KEY (CNPJ_escola) REFERENCES ESCOLA(CNPJ) 
); 

  

CREATE TABLE VERBA ( 
  codigo_verba VARCHAR(50) PRIMARY KEY, 
  tipo VARCHAR(50) NOT NULL, 
  origem VARCHAR(50) NOT NULL, 
  valor DECIMAL(12,2) NOT NULL, 
  data_recebimento DATE NOT NULL, 
  status_verba ENUM('ATIVA', 'ENCERRADA', 'PENDENTE') NOT NULL, 
  CNPJ_escola CHAR(14) NOT NULL, 
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
  
  FOREIGN KEY (CNPJ_escola) REFERENCES ESCOLA(CNPJ) 
); 

CREATE TABLE CATEGORIA_DESPESA ( 
  nome VARCHAR(50) PRIMARY KEY, 
  descricao VARCHAR(255) 
);

  

CREATE TABLE FORNECEDOR ( 
  CNPJ CHAR(14) PRIMARY KEY, 
  nome VARCHAR(100) NOT NULL, 
  contato VARCHAR(100), 
  tipo_servico VARCHAR(100), 
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
); 

  

CREATE TABLE DESPESA ( 
  numero_nota_fiscal VARCHAR(50) PRIMARY KEY, 
  descricao VARCHAR(255), 
  valor DECIMAL(12,2) NOT NULL, 
  data_ DATE NOT NULL, 
  nome_categoria VARCHAR(50) NOT NULL, 
  codigo_verba VARCHAR(50), 
  CNPJ_escola CHAR(14) NOT NULL, 
  CNPJ_fornecedor CHAR(14), 
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 

  FOREIGN KEY (nome_categoria) REFERENCES CATEGORIA_DESPESA(nome), 
  FOREIGN KEY (codigo_verba) REFERENCES VERBA(codigo_verba), 
  FOREIGN KEY (CNPJ_escola) REFERENCES ESCOLA(CNPJ), 
  FOREIGN KEY (CNPJ_fornecedor) REFERENCES FORNECEDOR(CNPJ) 
); 

  

CREATE TABLE ITEM_DESPESA ( 
  numero_nota_fiscal VARCHAR(50), 
  descricao VARCHAR(255), 
  quantidade INT NOT NULL, 
  valor_unitario DECIMAL(10,2) NOT NULL, 

  PRIMARY KEY (numero_nota_fiscal, descricao, valor_unitario), 
  FOREIGN KEY (numero_nota_fiscal) REFERENCES DESPESA(numero_nota_fiscal) 
); 

  

CREATE TABLE PAGAMENTO_FORNECEDOR ( 
  numero_comprovante VARCHAR(50) PRIMARY KEY, 
  data_pagamento DATE NOT NULL, 
  valor_pago DECIMAL(12,2) NOT NULL, 
  forma_pagamento VARCHAR(30) NOT NULL, 
  status_pagto ENUM ('PAGO', 'NAO_PAGO') DEFAULT 'NAO_PAGO' NOT NULL,
  numero_nota_fiscal VARCHAR(50), 
  CNPJ_fornecedor CHAR(14) NOT NULL, 
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 

  FOREIGN KEY (numero_nota_fiscal) REFERENCES DESPESA(numero_nota_fiscal), 
  FOREIGN KEY (CNPJ_fornecedor) REFERENCES FORNECEDOR(CNPJ) 
); 
  
CREATE TABLE EMPENHO ( 
  numero_empenho VARCHAR(50) PRIMARY KEY, 
  data_empenho DATE NOT NULL, 
  valor_empenhado DECIMAL(12,2) NOT NULL, 
  codigo_verba VARCHAR(50), 
  descricao VARCHAR(255), 
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 

  FOREIGN KEY (codigo_verba) REFERENCES VERBA(codigo_verba) 
);

  

CREATE TABLE PRESTACAO_CONTAS ( 
  protocolo_envio VARCHAR(50) PRIMARY KEY, 
  data_envio DATE NOT NULL, 
  periodo_referencia DATE NOT NULL, 
  status_prestacao ENUM ('ENVIADO', 'APROVADO', 'REJEITADO', 'PENDENTE') NOT NULL, 
  CNPJ_escola CHAR(14) NOT NULL, 
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 

  FOREIGN KEY (CNPJ_escola) REFERENCES ESCOLA(CNPJ) 
); 

CREATE TABLE PRESTACAO_VERBA ( 
  protocolo_envio VARCHAR(50), 
  codigo_verba VARCHAR(50), 

  PRIMARY KEY (protocolo_envio, codigo_verba), 
  FOREIGN KEY (protocolo_envio) REFERENCES PRESTACAO_CONTAS(protocolo_envio), 
  FOREIGN KEY (codigo_verba) REFERENCES VERBA(codigo_verba) 
); 

/*/////////////// MÓDULO ACADÊMICO ///////////////////////*/

CREATE TABLE pessoas(
cpf char(11) PRIMARY KEY NOT NULL,
sobrenome varchar(20) NOT NULL,
primeiro_nome varchar(50) NOT NULL,
dt_nasc date NOT NULL,
sexo ENUM('Feminino', 'Masculino', 'Outro') DEFAULT 'Outro',
cor ENUM('Amarela', 'Branca', 'Indigena', 'Negra', 'Parda', 'Outro') DEFAULT 'Outro'
);

CREATE TABLE logradouro_cep(
cep char(8) PRIMARY KEY NOT NULL,
logradouro varchar(100) NOT NULL,
bairro varchar(50) NOT NULL,
cidade varchar(50) NOT NULL,
estado ENUM(
    'AC','AL','AP','AM','BA','CE','DF','ES','GO',
    'MA','MT','MS','MG','PA','PB','PR','PE','PI',
    'RJ','RN','RS','RO','RR','SC','SP','SE','TO') NOT NULL
);

CREATE TABLE endereco(
pk_endereco int PRIMARY KEY,
cpf_pessoa char(11) NOT NULL,
cep char(8),
numero char(10),

FOREIGN KEY (cpf_pessoa) REFERENCES pessoas(cpf),
FOREIGN KEY (cep) REFERENCES logradouro_cep(cep)
);

CREATE TABLE aluno(
    RA varchar(20) PRIMARY KEY NOT NULL,
    cpf char(11),
    FOREIGN KEY (cpf) REFERENCES pessoas(cpf)
);

CREATE TABLE professor(
cpf char(11) PRIMARY KEY NOT NULL,

FOREIGN KEY (cpf) REFERENCES pessoas(cpf)
);

CREATE TABLE disciplina (
codigo_disciplina varchar(20) PRIMARY KEY,
nome_disciplina varchar(100) NOT NULL,
carga_horaria int NOT NULL
);

CREATE TABLE professor_disciplina(
pk_prof_disc int PRIMARY KEY,
cpf char(11) NOT NULL,
codigo_disciplina varchar(20) NOT NULL,

FOREIGN KEY (cpf) REFERENCES professor(cpf),
FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo_disciplina)
);

CREATE TABLE matricula(
    codigo_matricula varchar(20) PRIMARY KEY,
    codigo_disciplina varchar(20) NOT NULL,
    RA varchar(20) NOT NULL,
    turma varchar(50) NOT NULL,
    ano_letivo int NOT NULL,
    turno ENUM ('Manhã', 'Tarde', 'Noite') DEFAULT 'Manhã',
    data_matricula date NOT NULL,
    status_matricula ENUM ('Ativo', 'Inativo', 'Trancado', 'Desistente') DEFAULT 'Ativo',

    FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo_disciplina),
    FOREIGN KEY (RA) REFERENCES aluno(RA)
);

CREATE TABLE nota(
codigo_nota varchar(20) PRIMARY KEY NOT NULL,
RA varchar(20) NOT NULL,
codigo_disciplina varchar(20) NOT NULL,
bimestre int NOT NULL,
nota decimal(4,2) NOT NULL,
data_lancamento timestamp,

FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo_disciplina),
FOREIGN KEY (RA) REFERENCES aluno(RA)
);

CREATE TABLE frequencia(
pk_frequencia int PRIMARY KEY,
RA_aluno varchar(20) NOT NULL,
codigo_disciplina varchar(20) NOT NULL,
data_aula date NOT NULL,
status_presenca ENUM ('Presente', 'Ausente', 'Justificada') DEFAULT 'Ausente',

FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo_disciplina),
FOREIGN KEY (RA_aluno) REFERENCES aluno(RA)
);

CREATE TABLE responsavel(
cpf char(11) PRIMARY KEY NOT NULL,

FOREIGN KEY (cpf) REFERENCES pessoas(cpf)
);

CREATE TABLE telefone_responsavel(
telefone varchar(20) PRIMARY KEY,
cpf_responsavel char(11) NOT NULL,

FOREIGN KEY (cpf_responsavel) REFERENCES responsavel(cpf)
);

CREATE TABLE email_responsavel(
email varchar(255) PRIMARY KEY,
cpf_responsavel char(11) NOT NULL,

FOREIGN KEY (cpf_responsavel) REFERENCES responsavel(cpf)
);

CREATE TABLE responsavel_aluno(
pk_responsavel_aluno int PRIMARY KEY NOT NULL,
RA_aluno varchar(20) NOT NULL,
cpf_responsavel char(11) NOT NULL,
parentesco varchar(50),

FOREIGN KEY (RA_aluno) REFERENCES aluno(RA),
FOREIGN KEY (cpf_responsavel) REFERENCES responsavel(cpf)
);

CREATE TABLE notificacoes(
pk_notificacoes int PRIMARY KEY NOT NULL,
cpf_responsavel char(11) NOT NULL, /*ARRUMAR AQUI, NO DIAGRAMA E DICIONARIO ESTA SÓ RESPONSAVEL E É CPF_RESPONSAVEL)*/
aluno varchar(20) NOT NULL,
frequencia int NOT NULL,
mensagem text NOT NULL,
data_envio timestamp,
status_envio ENUM('Pendente', 'Enviado','Falha') DEFAULT 'Pendente',

FOREIGN KEY (cpf_responsavel) REFERENCES responsavel(cpf),
FOREIGN KEY (aluno) REFERENCES aluno(RA),
FOREIGN KEY (frequencia) REFERENCES frequencia(pk_frequencia)
);

DESC notificacoes;

/*//////////// MÓDULO RECURSOS HUMANOS /////////////////////////*/

CREATE TABLE departamento(
pk_departamento int PRIMARY KEY,
nome_departamento varchar(255)
);


CREATE TABLE niveis_hierarquicos(
pk_nivel int PRIMARY KEY,
nome_nivel varchar(50)
);

CREATE TABLE cargos_e_funcoes(
pk_cargo int PRIMARY KEY,
nome_cargo varchar(255) NOT NULL,
fk_departamento int NOT NULL,
fk_nivel int,
descricao_atividades varchar(255) NOT NULL,
piso_salarial decimal(12,2) NOT NULL,
teto_salarial decimal(12,2) NOT NULL,

FOREIGN KEY (fk_departamento) REFERENCES departamento(pk_departamento),
FOREIGN KEY (fk_nivel) REFERENCES niveis_hierarquicos(pk_nivel)
);

CREATE TABLE funcionario(
pk_funcionario int PRIMARY KEY,
nome_funcionario varchar (100) NOT NULL,
sobrenome varchar(100) NOT NULL,
cpf char(11) UNIQUE NOT NULL,
data_de_nascimento date NOT NULL,
sexo ENUM('feminino', 'masculino', 'outro') 
DEFAULT 'feminino', /*ARRUMAR DER E DICIONÁRIO DE DADOS DESSE CAMPO*/
email varchar(100) UNIQUE NOT NULL,
telefone varchar(20) UNIQUE NOT NULL,
cep char(8) NOT NULL,
numero int,
complemento varchar(50),
status_funcionario ENUM
('ativo','desligado','atestado','licen_maternidade', 'ferias')
DEFAULT 'ativo' /*ARRUMAR DER E DICIONÁRIO DE DADOS DESSE CAMPO*/
);

CREATE TABLE funcionario_cargos(
pk_funcionario  int NOT NULL,
pk_cargo int NOT NULL,

PRIMARY KEY (pk_funcionario, pk_cargo),

FOREIGN KEY (pk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (pk_cargo) REFERENCES cargos_e_funcoes(pk_cargo)
);

CREATE TABLE beneficios(
pk_beneficio int PRIMARY KEY,
pk_funcionario int NOT NULL,
tipo_beneficio varchar (50) NOT NULL, 
valor_desconto decimal(12,2) NOT NULL,
data_adesao date NOT NULL,

FOREIGN KEY (pk_funcionario) REFERENCES funcionario(pk_funcionario)
);

CREATE TABLE funcionario_beneficios(
pk_funcionario int NOT NULL,
pk_beneficios int NOT NULL,

PRIMARY KEY (pk_funcionario, pk_beneficios),

FOREIGN KEY (pk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (pk_beneficios) REFERENCES beneficios(pk_beneficio)
);

CREATE TABLE qualificacoes(
pk_qualificacoes int PRIMARY KEY,
fk_funcionario int NOT NULL,
tipo_formacao varchar(100) NOT NULL,
instituicao varchar(100) NOT NULL,
ano_conclusao date NOT NULL,

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario)
);

CREATE TABLE funcionario_qualificacoes(
pk_funcionarios int NOT NULL,
pk_qualificacoes int NOT NULL,

PRIMARY KEY (pk_funcionarios, pk_qualificacoes),

FOREIGN KEY (pk_funcionarios) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (pk_qualificacoes) REFERENCES qualificacoes(pk_qualificacoes)
);

CREATE TABLE alocacao(
  pk_alocacao int PRIMARY KEY,
  fk_funcionario  int NOT NULL,
  fk_cargo int NOT NULL,
  fk_departamento int NOT NULL, 
  data_inicio date NOT NULL,
  data_fim date,
  horas_semanais  decimal(5,2) NOT NULL,
  status_cargo ENUM ('ativo', 'encerrado_na_funcao') DEFAULT 'ativo',
  
  FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario),
  FOREIGN KEY (fk_cargo) REFERENCES cargos_e_funcoes(pk_cargo),
  FOREIGN KEY (fk_departamento) REFERENCES departamento(pk_departamento)
);

CREATE TABLE contratos(
pk_contrato int PRIMARY KEY,
fk_funcionario int NOT NULL,
fk_cargo int NOT NULL,
fk_nivel int NOT NULL, 
data_admissao date NOT NULL,
salario_base   decimal(12,2) NOT NULL,
status_contratos ENUM('ativo','inativo')
DEFAULT 'ativo', /*ARRUMAR DER E DICIONÁRIO DE DADOS DESSE CAMPO*/

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (fk_cargo) REFERENCES cargos_e_funcoes(pk_cargo),
FOREIGN KEY (fk_nivel) REFERENCES niveis_hierarquicos(pk_nivel)
);

CREATE TABLE historico_funcionario (
pk_historico int PRIMARY KEY,
fk_funcionario int NOT NULL, 
fk_contrato int NOT NULL,
fk_nivel int,
nome_cargo_anterior varchar(255) NOT NULL,
nome_cargo_novo varchar(255) NOT NULL,
salario_anterior decimal(12,2) NOT NULL,
salario_novo decimal(12,2) NOT NULL,
data_alteracao date,
motivo varchar(255) NOT NULL,

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (fk_contrato) REFERENCES contratos(pk_contrato),
FOREIGN KEY (fk_nivel) REFERENCES niveis_hierarquicos(pk_nivel)
);

CREATE TABLE dependentes(
pk_dependentes int PRIMARY KEY,
fk_funcionario int NOT NULL,
nome_dependentes varchar(255) NOT NULL,
nivel_parentesco ENUM('filho','cônjuge','pai','mãe') DEFAULT 'filho',
data_nascimento  date NOT NULL,
cpf char(11) NOT NULL,
email varchar(100),
telefone varchar(20),

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario)
);

CREATE TABLE licencas (
pk_licenca int PRIMARY KEY,
fk_funcionario int NOT NULL,
fk_cargo int NOT NULL,
tipo_licenca varchar(100) NOT NULL,
data_inicio date NOT NULL,
data_fim date NOT NULL,
motivo_da_licenca varchar(255) NOT NULL,

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (fk_cargo) REFERENCES cargos_e_funcoes(pk_cargo)
);

CREATE TABLE notas_financeiro (
pk_lancamento int PRIMARY KEY,
fk_funcionario int NOT NULL,
tipo_de_evento varchar(50) NOT NULL,
data_pagamento date NOT NULL,
valor_monetario decimal(12,2) NOT NULL,
descontos decimal(12,2) NOT NULL,
quantidade decimal(5,2),
motivo varchar(255) NOT NULL,
status_pag ENUM('pago','cancelado','pendente') DEFAULT 'pendente',

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario)
);

/* //////////////////////////////////////////////////////////
   FASE 2 - CARGA DE DADOS (OLTP)
///////////////////////////////////////////////////////////// */


/*/////////INSERÇÃO DE DADOS - ACADÊMICO /////////////////*/

INSERT IGNORE INTO pessoas 
(cpf, sobrenome, primeiro_nome, dt_nasc, sexo, cor)
VALUES 
('10000000001', 'Alderson', 'Elliot', '1990-09-17', 'Masculino', 'Branca'),
('10000000002', 'Moss', 'Angela', '1991-02-27', 'Feminino', 'Branca'),
('10000000003', 'Wellick', 'Tyrell', '1982-11-03', 'Masculino', 'Branca'),
('10000000004', 'Price', 'Phillip', '1960-05-12', 'Masculino', 'Branca'),
('10000000005', 'Alderson', 'Darlene', '1992-07-01', 'Feminino', 'Branca');

SELECT COUNT(*) FROM pessoas;


INSERT IGNORE INTO aluno (RA, cpf)
VALUES
('RA001', '10000000001'), -- Elliot
('RA002', '10000000002'), -- Angela
('RA003', '10000000005'); -- Darlene

SELECT COUNT(*) FROM aluno;


INSERT IGNORE INTO professor (cpf)
VALUES
('10000000003'), -- Tyrell
('10000000004'); -- Price


SELECT COUNT(*) FROM professor;

INSERT IGNORE INTO disciplina 
(codigo_disciplina, nome_disciplina, carga_horaria)
VALUES
('HACK01', 'Cybersecurity', 80),
('HACK02', 'Engenharia Social', 60);

SELECT COUNT(*) FROM disciplina;


INSERT IGNORE INTO matricula
(codigo_matricula, codigo_disciplina, RA, turma, ano_letivo, turno, data_matricula, status_matricula)
VALUES
('MAT001', 'HACK01', 'RA001', 'FSociety', 2025, 'Manhã', '2025-02-01', 'Ativo'),
('MAT002', 'HACK02', 'RA002', 'FSociety', 2025, 'Manhã', '2025-02-01', 'Ativo'),
('MAT003', 'HACK01', 'RA003', 'DarkArmy', 2025, 'Noite', '2025-02-01', 'Ativo');


SELECT COUNT(*) FROM matricula;


INSERT IGNORE INTO nota
(codigo_nota, RA, codigo_disciplina, bimestre, nota, data_lancamento)
VALUES
('N001', 'RA001', 'HACK01', 1, 9.8, NOW()), -- Elliot hacker nível Deus
('N002', 'RA002', 'HACK02', 1, 8.5, NOW()),
('N003', 'RA003', 'HACK01', 1, 9.0, NOW());


SELECT COUNT(*) FROM nota;

INSERT IGNORE INTO frequencia
(pk_frequencia, RA_aluno, codigo_disciplina, data_aula, status_presenca)
VALUES
(1, 'RA001', 'HACK01', '2025-03-01', 'Presente'),
(2, 'RA002', 'HACK02', '2025-03-01', 'Ausente'),
(3, 'RA003', 'HACK01', '2025-03-01', 'Presente');

SELECT COUNT(*) FROM frequencia;


INSERT IGNORE INTO responsavel (cpf)
VALUES 
('10000000002'), -- Angela
('10000000004'); -- Phillip

SELECT COUNT(*) FROM responsavel;

INSERT IGNORE INTO notificacoes 
(pk_notificacoes, cpf_responsavel, aluno, frequencia, mensagem, data_envio, status_envio)
VALUES
(1, '10000000002', 'RA001', 1, 'Elliot faltou na aula de segurança da informação', NOW(), 'Enviado'),

(2, '10000000004', 'RA001', 2, 'Elliot compareceu à aula', NOW(), 'Enviado');

SELECT * FROM notificacoes;

SELECT COUNT(*) FROM notificacoes;

/*////////////////////// TESTES - SELECT ////////////////////////*/

SELECT COUNT(*) FROM pessoas;
SELECT COUNT(*) FROM professor;
SELECT COUNT(*) FROM disciplina;
SELECT COUNT(*) FROM matricula;
SELECT COUNT(*) FROM nota;
SELECT COUNT(*) FROM frequencia;
SELECT COUNT(*) FROM responsavel;

SELECT *  FROM pessoas; 

/*/////////INSERÇÃO DE DADOS - FINANCEIRO /////////////////*/

INSERT INTO ESCOLA (CNPJ, nome, endereco)
VALUES ('99887766000155', 'E.E. Dona Amélia de Araújo', 'Rua das Acácias, 210')
ON DUPLICATE KEY UPDATE nome = VALUES(nome), endereco = VALUES(endereco);

INSERT INTO ESCOLA_TELEFONE VALUES ('99887766000155', '11977778888')
ON DUPLICATE KEY UPDATE telefone = VALUES(telefone);

INSERT INTO ESCOLA_EMAIL VALUES ('99887766000155', 'contato@novageracao.edu')
ON DUPLICATE KEY UPDATE email = VALUES(email);

INSERT INTO VERBA VALUES 
('VB101', 'Federal', 'FNDE', 40000.00, '2024-01-15', 'ATIVA', '99887766000155', CURRENT_TIMESTAMP),
('VB102', 'Estadual', 'SEDUC', 25000.00, '2024-02-10', 'ATIVA', '99887766000155', CURRENT_TIMESTAMP),
('VB103', 'Municipal', 'Prefeitura', 15000.00, '2024-03-05', 'PENDENTE', '99887766000155', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE valor = VALUES(valor);

INSERT INTO CATEGORIA_DESPESA VALUES 
('Tecnologia', 'Equipamentos e softwares'),
('Manutenção', 'Serviços gerais')
ON DUPLICATE KEY UPDATE descricao = VALUES(descricao);

INSERT INTO FORNECEDOR VALUES 
('22334455000166', 'Tech Solutions Ltda', 'tech@solutions.com', 'Tecnologia', CURRENT_TIMESTAMP),
('33445566000177', 'Serviços Gerais Beta', 'beta@servicos.com', 'Manutenção', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

INSERT INTO DESPESA VALUES 
('NF101', 'Compra de computadores', 12000.00, '2024-02-20', 'Tecnologia', 'VB101', '99887766000155', '22334455000166', CURRENT_TIMESTAMP),
('NF102', 'Manutenção elétrica', 5000.00, '2024-02-25', 'Manutenção', 'VB102', '99887766000155', '33445566000177', CURRENT_TIMESTAMP),
('NF103', 'Compra de projetores', 8000.00, '2024-03-10', 'Tecnologia', 'VB101', '99887766000155', '22334455000166', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE valor = VALUES(valor);

INSERT INTO ITEM_DESPESA VALUES 
('NF101', 'Computador', 10, 1200.00),
('NF102', 'Serviço elétrico', 1, 5000.00),
('NF103', 'Projetor', 4, 2000.00)
ON DUPLICATE KEY UPDATE quantidade = VALUES(quantidade);

INSERT INTO PAGAMENTO_FORNECEDOR VALUES 
('PG101', '2024-02-28', 12000.00, 'PIX', 'PAGO', 'NF101', '22334455000166', CURRENT_TIMESTAMP),
('PG102', '2024-03-05', 5000.00, 'Boleto', 'PAGO', 'NF102', '33445566000177', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE valor_pago = VALUES(valor_pago);

/*////////////////////// TESTES - SELECT ////////////////////////*/

SELECT COUNT(*) FROM ESCOLA;
SELECT COUNT(*) FROM VERBA;
SELECT COUNT(*) FROM FORNECEDOR;
SELECT COUNT(*) FROM DESPESA;
SELECT COUNT(*) FROM PAGAMENTO_FORNECEDOR;

/* //////////////////////////////////////////////////////
   FASE 3 - OPERAÇÕES OLTP
////////////////////////////////////////////////////// */


/* //////////// SUBSELECT COM AGREGAÇÃO - ACEDEMICO ////////////////*/
SELECT RA
FROM aluno
WHERE RA IN (
    SELECT RA
    FROM nota
    GROUP BY RA
    HAVING AVG(nota) >= 9
);

/* ///////////// TRANSAÇÃO COM ROLLBACK /////////////////// */

START TRANSACTION;
INSERT INTO nota (codigo_nota, RA, codigo_disciplina, bimestre, nota, data_lancamento)
VALUES ('N997', 'RA001', 'HACK01', 1, 7.0, NOW());
ROLLBACK;
SELECT * FROM nota WHERE codigo_nota = 'N997';

/* ////////////// TRANSAÇÃO COM COMMIT //////////////// */

START TRANSACTION;
INSERT INTO nota (codigo_nota, RA, codigo_disciplina, bimestre, nota, data_lancamento)
VALUES ('N1004', 'RA001', 'HACK01', 1, 9.5, NOW());
COMMIT;
SELECT * FROM nota WHERE codigo_nota = 'N1004';

/*/////////SELECT SIMPLES - FINANCEIRO //////////////*/

SELECT nome, CNPJ FROM ESCOLA;
SELECT codigo_verba, valor FROM VERBA;
SELECT nome FROM FORNECEDOR;
SELECT numero_nota_fiscal, valor FROM DESPESA;
SELECT numero_comprovante, valor_pago FROM PAGAMENTO_FORNECEDOR;

/*/////// SUBSELECT COM AGREGAÇÃO - FINANCEIRO //////////////*/

SELECT codigo_verba
FROM VERBA
WHERE codigo_verba IN (
    SELECT codigo_verba
    FROM DESPESA
    GROUP BY codigo_verba
    HAVING SUM(valor) > 10000
);

/*/////// TRANSAÇÕES ROLLBACK - FINANCEIRO ////////*/

START TRANSACTION;
INSERT INTO PAGAMENTO_FORNECEDOR VALUES ('PG_TESTE', '2024-04-01', 1000.00, 'PIX', 'PAGO', 'NF101', '22334455000166', CURRENT_TIMESTAMP);
ROLLBACK;

/*/////// TRANSAÇÕES ROLLBACK - FINANCEIRO ////////*/

START TRANSACTION;
INSERT INTO PAGAMENTO_FORNECEDOR VALUES ('PG_OK_FINAL', '2024-04-01', 1000.00, 'PIX', 'PAGO', 'NF101', '22334455000166', CURRENT_TIMESTAMP);
COMMIT;

/* ////////////////////////////////////////////////////////
   FASE 4 - MODELO OLAP (ESTRELA)
////////////////////////////////////////////////////////// */

/*////////CRIAÇÃO - ACADÊMICO ////////////*/

-- GRANULARIDADE: 

CREATE TABLE dim_aluno (
    sk_aluno INT AUTO_INCREMENT PRIMARY KEY,
    RA VARCHAR(20) NOT NULL UNIQUE,
    cpf CHAR(11),
    primeiro_nome VARCHAR(50),
    sobrenome VARCHAR(20),
    data_nascimento DATE
);

CREATE TABLE dim_disciplina (
    sk_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    codigo_disciplina VARCHAR(20) UNIQUE,
    nome_disciplina VARCHAR(100),
    carga_horaria INT
);



CREATE TABLE dim_tempo (
    sk_tempo INT AUTO_INCREMENT PRIMARY KEY,
    data_completa DATE UNIQUE,
    dia INT,
    mes INT,
    ano INT,
    bimestre INT,
    nome_mes VARCHAR(20)
);

CREATE TABLE dim_turma (
    sk_turma INT AUTO_INCREMENT PRIMARY KEY,
    nome_turma VARCHAR(100),
    turno ENUM('Manhã','Tarde','Noite'),
    ano_letivo INT
);

CREATE TABLE fato_frequencia (
sk_fato_frequencia INT AUTO_INCREMENT PRIMARY KEY,

sk_aluno INT NOT NULL,
sk_disciplina INT NOT NULL,
sk_turma INT NOT NULL,
sk_tempo INT NOT NULL,

status_presenca VARCHAR(20),

qtd_presenca INT,
qtd_falta INT,
qtd_falta_justificada INT,

FOREIGN KEY (sk_aluno) REFERENCES dim_aluno(sk_aluno),
FOREIGN KEY (sk_disciplina) REFERENCES dim_disciplina(sk_disciplina),
FOREIGN KEY (sk_turma) REFERENCES dim_turma(sk_turma),
FOREIGN KEY (sk_tempo) REFERENCES dim_tempo(sk_tempo)
);

/*/////// CRIAÇÃO - FINANCEIRO /////////*/

-- GRANULARIDADE: 1 linha na tabela fato representa 
--                1 pagamento por fornecedor por data.

-- Tabela Fato:
CREATE TABLE FATO_FINANCEIRO (
    sk_fato INT AUTO_INCREMENT PRIMARY KEY,
    sk_tempo INT,
    sk_fornecedor INT,
    sk_verba INT,
    valor_total DECIMAL(12,2)
);

-- Dimensão Tempo:
CREATE TABLE DIM_TEMPO_FINANC ( -- MUDAR TABELA DELES 
    sk_tempo INT AUTO_INCREMENT PRIMARY KEY,
    data DATE,
    ano INT,
    mes INT,
    nome_mes VARCHAR(20)
);

-- Dimensão Fornecedor:
CREATE TABLE DIM_FORNECEDOR (
    sk_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    CNPJ VARCHAR(14),
    nome VARCHAR(100),
    tipo_servico VARCHAR(100)
);

-- Dimensão Verba:
CREATE TABLE DIM_VERBA (
    sk_verba INT AUTO_INCREMENT PRIMARY KEY,
    codigo_verba VARCHAR(50),
    tipo VARCHAR(50),
    origem VARCHAR(50)
);



/* ////////////////////////////////////////////////////
   ETL (CARGA DAS DIMENSÕES E FATO)
////////////////////////////////////////////////////// */

/*/////// CARGA - ACADÊMICO /////////////*/

INSERT INTO dim_aluno (
    RA,
    cpf,
    primeiro_nome,
    sobrenome,
    data_nascimento
)
SELECT 
    a.RA,
    p.cpf,
    UPPER(p.primeiro_nome),
    UPPER(p.sobrenome),
    p.dt_nasc
FROM aluno a
JOIN pessoas p ON p.cpf = a.cpf;


INSERT IGNORE INTO dim_disciplina (
    codigo_disciplina,
    nome_disciplina,
    carga_horaria
)
SELECT 
    codigo_disciplina,
    nome_disciplina,
    carga_horaria
FROM disciplina;


INSERT IGNORE INTO dim_tempo (
    data_completa,
    dia,
    mes,
    ano,
    bimestre,
    nome_mes
)
SELECT 
    data_aula,
    DAY(data_aula),
    MONTH(data_aula),
    YEAR(data_aula),
    CEIL(MONTH(data_aula)/2),
    MONTHNAME(data_aula)
FROM frequencia;



INSERT INTO dim_turma (nome_turma, turno, ano_letivo)
VALUES 
('FSociety', 'Manhã', 2025),
('DarkArmy', 'Noite', 2025);

INSERT INTO fato_frequencia (
    sk_aluno,
    sk_disciplina,
    sk_turma,
    sk_tempo,
    status_presenca,
    qtd_presenca,
    qtd_falta,
    qtd_falta_justificada
)
SELECT 
    da.sk_aluno,
    dd.sk_disciplina,
    dtur.sk_turma,
    dt.sk_tempo,
    UPPER(f.status_presenca),

    CASE WHEN f.status_presenca = 'Presente' THEN 1 ELSE 0 END,
    CASE WHEN f.status_presenca = 'Ausente' THEN 1 ELSE 0 END,
    CASE WHEN f.status_presenca = 'Justificada' THEN 1 ELSE 0 END

FROM frequencia f
JOIN dim_aluno da ON da.RA = f.RA_aluno
JOIN dim_disciplina dd ON dd.codigo_disciplina = f.codigo_disciplina
JOIN dim_turma dtur 
    ON dtur.nome_turma = (
        SELECT turma 
        FROM matricula m 
        WHERE m.RA = f.RA_aluno 
        LIMIT 1
    )
JOIN dim_tempo dt 
    ON dt.data_completa = f.data_aula;

/*/////// CARGA - FINANCEIRO ////////////////////*/

-- Carga dimensão tempo
INSERT INTO DIM_TEMPO_FINANC (data, ano, mes, nome_mes)
SELECT DISTINCT data_pagamento, YEAR(data_pagamento), MONTH(data_pagamento), MONTHNAME(data_pagamento)
FROM PAGAMENTO_FORNECEDOR;

-- Carga dimensão fornecedor
INSERT INTO DIM_FORNECEDOR (CNPJ, nome, tipo_servico)
SELECT DISTINCT CNPJ, nome, tipo_servico FROM FORNECEDOR;

-- Carga dimensão verba
INSERT INTO DIM_VERBA (codigo_verba, tipo, origem)
SELECT DISTINCT codigo_verba, tipo, origem FROM VERBA;

-- Carga fato
INSERT INTO FATO_FINANCEIRO (sk_tempo, sk_fornecedor, sk_verba, valor_total)
SELECT dt.sk_tempo, df.sk_fornecedor, dv.sk_verba, p.valor_pago
FROM PAGAMENTO_FORNECEDOR p
JOIN DESPESA d ON p.numero_nota_fiscal = d.numero_nota_fiscal
JOIN DIM_TEMPO_FINANC dt ON dt.data = p.data_pagamento
JOIN DIM_FORNECEDOR df ON df.CNPJ = p.CNPJ_fornecedor
JOIN DIM_VERBA dv ON dv.codigo_verba = d.codigo_verba;

/* ////////// EXTRAÇÃO (OLTP) ////////////*/
SELECT 
    f.RA_aluno,
    f.codigo_disciplina,
    f.data_aula,
    f.status_presenca
FROM frequencia f;

/*////////// LOOKUP PARA CARGA DA FATO (OLAP) /////////*/

    SELECT 
    da.sk_aluno,
    dd.sk_disciplina,
    dt.sk_tempo,
    dtur.sk_turma,
    f.status_presenca
FROM frequencia f
JOIN dim_aluno da 
    ON f.RA_aluno = da.RA

JOIN dim_disciplina dd 
    ON f.codigo_disciplina = dd.codigo_disciplina

JOIN matricula m 
    ON f.RA_aluno = m.RA 
    AND f.codigo_disciplina = m.codigo_disciplina

JOIN dim_turma dtur 
    ON m.turma = dtur.nome_turma 
    AND m.ano_letivo = dtur.ano_letivo

JOIN dim_tempo dt 
    ON dt.dia = DAY(f.data_aula)
    AND dt.mes = MONTH(f.data_aula)
    AND dt.ano = YEAR(f.data_aula);
    
/* /////////////////////////////////////////////////////////
   VALIDAÇÃO DO DW
//////////////////////////////////////////////////////////// */

/*//////////VALIDAÇÃO ACADÊMICO //////////////*/

-- consistência OLTP vs OLAP 
SELECT COUNT(*) FROM frequencia;
SELECT COUNT(*) FROM fato_frequencia;

-- validação de métricas 
SELECT SUM(qtd_presenca + qtd_falta + qtd_falta_justificada)
FROM fato_frequencia;

/*//////////// VALIDAÇÃO - FINANCEIRO /////////////////////*/
SELECT SUM(valor_pago) FROM PAGAMENTO_FORNECEDOR;
SELECT SUM(valor_total) FROM FATO_FINANCEIRO;


/*///////////// FASE 5 - ÍNDICES E OTIMIZAÇÃO ///////////////////*/

/*///////////ACADÊMICO //////////////*/

CREATE INDEX idx_fato_frequencia_aluno 
ON fato_frequencia(sk_aluno);

CREATE INDEX idx_fato_frequencia_disciplina 
ON fato_frequencia(sk_disciplina);

CREATE INDEX idx_fato_frequencia_turma 
ON fato_frequencia(sk_turma);

CREATE INDEX idx_fato_frequencia_tempo 
ON fato_frequencia(sk_tempo);

/* VALIDAÇÃO COM EXPLAIN */

EXPLAIN
SELECT 
    dim_aluno.ra,
    dim_aluno.primeiro_nome,
    dim_aluno.sobrenome,
    SUM(fato_frequencia.qtd_falta) AS total_faltas
FROM fato_frequencia
JOIN dim_aluno 
    ON dim_aluno.sk_aluno = fato_frequencia.sk_aluno
GROUP BY 
    dim_aluno.ra,
    dim_aluno.primeiro_nome,
    dim_aluno.sobrenome;
    
/*//////// FINANCEIRO /////////////////*/

CREATE INDEX idx_escola_telefone_cnpj_escola ON escola_telefone(cnpj_escola);
CREATE INDEX idx_escola_email_cnpj_escola ON escola_email(cnpj_escola);
CREATE INDEX idx_verba_cnpj_escola ON verba(cnpj_escola);
CREATE INDEX idx_despesa_nome_categoria ON despesa(nome_categoria);
CREATE INDEX idx_despesa_codigo_verba ON despesa(codigo_verba);
CREATE INDEX idx_despesa_cnpj_escola ON despesa(cnpj_escola);
CREATE INDEX idx_despesa_cnpj_fornecedor ON despesa(cnpj_fornecedor);
CREATE INDEX idx_item_despesa_numero_nota ON item_despesa(numero_nota_fiscal);
CREATE INDEX idx_pagamento_fornecedor_numero_nota ON pagamento_fornecedor(numero_nota_fiscal);
CREATE INDEX idx_pagamento_fornecedor_cnpj ON pagamento_fornecedor(cnpj_fornecedor);
CREATE INDEX idx_empenho_codigo_verba ON empenho(codigo_verba);
CREATE INDEX idx_prestacao_contas_cnpj_escola ON prestacao_contas(cnpj_escola);
CREATE INDEX idx_prestacao_verba_protocolo ON prestacao_verba(protocolo_envio);
CREATE INDEX idx_prestacao_verba_codigo_verba ON prestacao_verba(codigo_verba);

-- VALIDAÇÃO

EXPLAIN SELECT d.numero_nota_fiscal, f.nome
FROM despesa d
JOIN fornecedor f ON d.cnpj_fornecedor = f.cnpj;