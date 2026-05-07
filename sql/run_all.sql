-- SCRIPT DE RESET 

DROP DATABASE IF EXISTS projeto_bd;

CREATE DATABASE projeto_bd;
USE projeto_bd; 

/* Fase 1: Preparação do Ambiente e DDL */

/* MÓDULO FINANCEIRO */

-- tabela principal das escolas
CREATE TABLE escola (
  cnpj CHAR(14) PRIMARY KEY, -- identificador único da escola
  nome VARCHAR(100) NOT NULL, -- nome da escola
  endereco VARCHAR(255) NOT NULL, -- endereço completo
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- data de criação do registro
);

-- telefones vinculados às escolas
CREATE TABLE escola_telefone (
  cnpj_escola CHAR(14), -- chave da escola
  telefone VARCHAR(20) NOT NULL, -- número de telefone
  PRIMARY KEY (cnpj_escola, telefone),
  FOREIGN KEY (cnpj_escola) REFERENCES escola(cnpj)
);

-- e-mails vinculados às escolas
CREATE TABLE escola_email (
  cnpj_escola CHAR(14), -- chave da escola
  email VARCHAR(100) NOT NULL, -- endereço de e-mail
  PRIMARY KEY (cnpj_escola, email),
  FOREIGN KEY (cnpj_escola) REFERENCES escola(cnpj)
);

-- registro de verbas recebidas pela escola
CREATE TABLE verba (
  codigo_verba VARCHAR(50) PRIMARY KEY, -- identificador da verba
  tipo VARCHAR(50) NOT NULL, -- tipo da verba 
  origem VARCHAR(50) NOT NULL, -- origem do recurso
  valor DECIMAL(12,2) NOT NULL, -- valor recebido
  data_recebimento DATE NOT NULL, -- data do recebimento
  status_verba ENUM('ativa', 'encerrada', 'pendente') NOT NULL, -- status da verba
  cnpj_escola CHAR(14) NOT NULL, -- vínculo com a escola
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cnpj_escola) REFERENCES escola(cnpj)
);

-- categorias de despesas
CREATE TABLE categoria_despesa (
  nome VARCHAR(50) PRIMARY KEY, -- nome da categoria
  descricao VARCHAR(255) -- descrição detalhada
);

-- fornecedores de serviços
CREATE TABLE fornecedor (
  cnpj CHAR(14) PRIMARY KEY, -- identificador único do fornecedor
  nome VARCHAR(100) NOT NULL, -- nome do fornecedor
  contato VARCHAR(100), -- pessoa de contato
  tipo_servico VARCHAR(100), -- tipo de serviço prestado
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- despesas registradas
CREATE TABLE despesa (
  numero_nota_fiscal VARCHAR(50) PRIMARY KEY, -- nota fiscal da despesa
  descricao VARCHAR(255), -- descrição da despesa
  valor DECIMAL(12,2) NOT NULL, -- valor da despesa
  data DATE NOT NULL, -- data da despesa
  nome_categoria VARCHAR(50) NOT NULL, -- categoria vinculada
  codigo_verba VARCHAR(50), -- verba utilizada
  cnpj_escola CHAR(14) NOT NULL, -- escola vinculada
  cnpj_fornecedor CHAR(14), -- fornecedor vinculado
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (nome_categoria) REFERENCES categoria_despesa(nome),
  FOREIGN KEY (codigo_verba) REFERENCES verba(codigo_verba),
  FOREIGN KEY (cnpj_escola) REFERENCES escola(cnpj),
  FOREIGN KEY (cnpj_fornecedor) REFERENCES fornecedor(cnpj)
);

-- itens detalhados da despesa
CREATE TABLE item_despesa (
  numero_nota_fiscal VARCHAR(50), -- nota fiscal da despesa
  descricao VARCHAR(255), -- descrição do item
  quantidade INT NOT NULL, -- quantidade adquirida
  valor_unitario DECIMAL(10,2) NOT NULL, -- valor unitário
  PRIMARY KEY (numero_nota_fiscal, descricao, valor_unitario),
  FOREIGN KEY (numero_nota_fiscal) REFERENCES despesa(numero_nota_fiscal)
);

-- pagamentos realizados aos fornecedores
CREATE TABLE pagamento_fornecedor (
  numero_comprovante VARCHAR(50) PRIMARY KEY, -- comprovante do pagamento
  data_pagamento DATE NOT NULL, -- data do pagamento
  valor_pago DECIMAL(12,2) NOT NULL, -- valor pago
  forma_pagamento VARCHAR(30) NOT NULL, -- forma de pagamento
  status_pagamento ENUM('pago', 'nao_pago') DEFAULT 'nao_pago' NOT NULL, -- status do pagamento
  numero_nota_fiscal VARCHAR(50), -- nota fiscal vinculada
  cnpj_fornecedor CHAR(14) NOT NULL, -- fornecedor vinculado
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (numero_nota_fiscal) REFERENCES despesa(numero_nota_fiscal),
  FOREIGN KEY (cnpj_fornecedor) REFERENCES fornecedor(cnpj)
);

-- empenhos vinculados às verbas
CREATE TABLE empenho (
  numero_empenho VARCHAR(50) PRIMARY KEY, -- número do empenho
  data_empenho DATE NOT NULL, -- data do empenho
  valor_empenhado DECIMAL(12,2) NOT NULL, -- valor empenhado
  codigo_verba VARCHAR(50), -- verba vinculada
  descricao VARCHAR(255), -- descrição do empenho
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (codigo_verba) REFERENCES verba(codigo_verba)
);

-- prestação de contas das escolas
CREATE TABLE prestacao_contas (
  protocolo_envio VARCHAR(50) PRIMARY KEY, -- protocolo da prestação
  data_envio DATE NOT NULL, -- data do envio
  periodo_referencia DATE NOT NULL, -- período de referência
  status_prestacao ENUM('enviado', 'aprovado', 'rejeitado', 'pendente') NOT NULL, -- status da prestação
  cnpj_escola CHAR(14) NOT NULL, -- escola vinculada
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cnpj_escola) REFERENCES escola(cnpj)
);

-- vinculação entre prestação de contas e verbas
CREATE TABLE prestacao_verba (
  protocolo_envio VARCHAR(50), -- protocolo da prestação
  codigo_verba VARCHAR(50), -- verba vinculada
  PRIMARY KEY (protocolo_envio, codigo_verba),
  FOREIGN KEY (protocolo_envio) REFERENCES prestacao_contas(protocolo_envio),
  FOREIGN KEY (codigo_verba) REFERENCES verba(codigo_verba)
);

/* MÓDULO ACADÊMICO */

-- dados das pessoas cadastradas no sistema
CREATE TABLE pessoas(
cpf char(11) PRIMARY KEY NOT NULL, -- cpf da pessoa
sobrenome varchar(20) NOT NULL, -- sobrenome
primeiro_nome varchar(50) NOT NULL, -- primeiro nome
dt_nasc date NOT NULL, -- data de nascimento
sexo ENUM('Feminino', 'Masculino', 'Outro') DEFAULT 'Outro', -- sexo
cor ENUM('Amarela', 'Branca', 'Indigena', 'Negra', 'Parda', 'Outro') DEFAULT 'Outro' -- cor
);

-- tabela de endereços por cep
CREATE TABLE logradouro_cep(
cep char(8) PRIMARY KEY NOT NULL, -- cep
logradouro varchar(100) NOT NULL, -- rua ou avenida
bairro varchar(50) NOT NULL, -- bairro
cidade varchar(50) NOT NULL, -- cidade
estado ENUM(
    'AC','AL','AP','AM','BA','CE','DF','ES','GO',
    'MA','MT','MS','MG','PA','PB','PR','PE','PI',
    'RJ','RN','RS','RO','RR','SC','SP','SE','TO') NOT NULL -- estado
);

-- endereço vinculado à pessoa
CREATE TABLE endereco(
pk_endereco int PRIMARY KEY, -- código do endereço
cpf_pessoa char(11) NOT NULL, -- cpf da pessoa
cep char(8), -- cep do endereço
numero char(10), -- número da residência

FOREIGN KEY (cpf_pessoa) REFERENCES pessoas(cpf),
FOREIGN KEY (cep) REFERENCES logradouro_cep(cep)
);

-- dados dos alunos
CREATE TABLE aluno(
    ra varchar(20) PRIMARY KEY NOT NULL, -- registro do aluno
    cpf char(11), -- cpf do aluno
    FOREIGN KEY (cpf) REFERENCES pessoas(cpf)
);

-- dados dos professores
CREATE TABLE professor(
cpf char(11) PRIMARY KEY NOT NULL, -- cpf do professor

FOREIGN KEY (cpf) REFERENCES pessoas(cpf)
);

-- disciplinas da escola
CREATE TABLE disciplina (
codigo_disciplina varchar(20) PRIMARY KEY, -- código da disciplina
nome_disciplina varchar(100) NOT NULL, -- nome da disciplina
carga_horaria int NOT NULL -- carga horária
);

-- relação entre professor e disciplina
CREATE TABLE professor_disciplina(
pk_prof_disc int PRIMARY KEY, -- código da relação
cpf char(11) NOT NULL, -- cpf do professor
codigo_disciplina varchar(20) NOT NULL, -- código da disciplina

FOREIGN KEY (cpf) REFERENCES professor(cpf),
FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo_disciplina)
);

-- matrícula do aluno na disciplina
CREATE TABLE matricula(
    codigo_matricula varchar(20) PRIMARY KEY, -- código da matrícula
    codigo_disciplina varchar(20) NOT NULL, -- disciplina matriculada
    ra varchar(20) NOT NULL, -- aluno matriculado
    turma varchar(50) NOT NULL, -- turma do aluno
    ano_letivo int NOT NULL, -- ano letivo
    turno ENUM ('Manhã', 'Tarde', 'Noite') DEFAULT 'Manhã', -- turno
    data_matricula date NOT NULL, -- data da matrícula
    status_matricula ENUM ('Ativo', 'Inativo', 'Trancado', 'Desistente') DEFAULT 'Ativo', -- situação da matrícula

    FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo_disciplina),
    FOREIGN KEY (ra) REFERENCES aluno(ra)
);

-- notas dos alunos
CREATE TABLE nota(
codigo_nota varchar(20) PRIMARY KEY NOT NULL, -- código da nota
ra varchar(20) NOT NULL, -- aluno da nota
codigo_disciplina varchar(20) NOT NULL, -- disciplina da nota
bimestre int NOT NULL, -- bimestre
nota decimal(4,2) NOT NULL, -- valor da nota
data_lancamento timestamp, -- data do lançamento

FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo_disciplina),
FOREIGN KEY (ra) REFERENCES aluno(ra)
);

-- frequência dos alunos
CREATE TABLE frequencia(
pk_frequencia int PRIMARY KEY, -- código da frequência
ra_aluno varchar(20) NOT NULL, -- aluno da frequência
codigo_disciplina varchar(20) NOT NULL, -- disciplina da aula
data_aula date NOT NULL, -- data da aula
status_presenca ENUM ('Presente', 'Ausente', 'Justificada') DEFAULT 'Ausente', -- presença do aluno

FOREIGN KEY (codigo_disciplina) REFERENCES disciplina(codigo_disciplina),
FOREIGN KEY (ra_aluno) REFERENCES aluno(ra)
);

-- responsáveis cadastrados
CREATE TABLE responsavel(
cpf char(11) PRIMARY KEY NOT NULL, -- cpf do responsável

FOREIGN KEY (cpf) REFERENCES pessoas(cpf)
);

-- telefones dos responsáveis
CREATE TABLE telefone_responsavel(
telefone varchar(20) PRIMARY KEY, -- telefone do responsável
cpf_responsavel char(11) NOT NULL, -- cpf do responsável

FOREIGN KEY (cpf_responsavel) REFERENCES responsavel(cpf)
);

-- e-mails dos responsáveis
CREATE TABLE email_responsavel(
email varchar(255) PRIMARY KEY, -- e-mail do responsável
cpf_responsavel char(11) NOT NULL, -- cpf do responsável

FOREIGN KEY (cpf_responsavel) REFERENCES responsavel(cpf)
);

-- relação entre responsável e aluno
CREATE TABLE responsavel_aluno(
pk_responsavel_aluno int PRIMARY KEY NOT NULL, -- código da relação
ra_aluno varchar(20) NOT NULL, -- aluno vinculado
cpf_responsavel char(11) NOT NULL, -- responsável vinculado
parentesco varchar(50), -- parentesco

FOREIGN KEY (ra_aluno) REFERENCES aluno(ra),
FOREIGN KEY (cpf_responsavel) REFERENCES responsavel(cpf)
);

-- notificações enviadas aos responsáveis
CREATE TABLE notificacoes(
pk_notificacoes int PRIMARY KEY NOT NULL, -- código da notificação
cpf_responsavel char(11) NOT NULL, -- cpf do responsável do aluno
aluno varchar(20) NOT NULL, -- aluno relacionado
frequencia int NOT NULL, -- frequência relacionada
mensagem text NOT NULL, -- mensagem enviada
data_envio timestamp, -- data do envio
status_envio ENUM('Pendente', 'Enviado','Falha') DEFAULT 'Pendente', -- status do envio

FOREIGN KEY (cpf_responsavel) REFERENCES responsavel(cpf),
FOREIGN KEY (aluno) REFERENCES aluno(ra),
FOREIGN KEY (frequencia) REFERENCES frequencia(pk_frequencia)
);

DESC notificacoes;

/*MÓDULO RECURSOS HUMANOS */

-- departamentos da escola
CREATE TABLE departamento(
pk_departamento int PRIMARY KEY, -- código do departamento
nome_departamento varchar(255) -- nome do departamento
);

-- níveis hierárquicos dos cargos
CREATE TABLE niveis_hierarquicos(
pk_nivel int PRIMARY KEY, -- código do nível
nome_nivel varchar(50) -- nome do nível
);

-- cargos e funções dos funcionários
CREATE TABLE cargos_e_funcoes(
pk_cargo int PRIMARY KEY, -- código do cargo
nome_cargo varchar(255) NOT NULL, -- nome do cargo
fk_departamento int NOT NULL, -- departamento do cargo
fk_nivel int, -- nível hierárquico do cargo
descricao_atividades varchar(255) NOT NULL, -- atividades do cargo
piso_salarial decimal(12,2) NOT NULL, -- salário mínimo do cargo
teto_salarial decimal(12,2) NOT NULL, -- salário máximo do cargo

FOREIGN KEY (fk_departamento) REFERENCES departamento(pk_departamento),
FOREIGN KEY (fk_nivel) REFERENCES niveis_hierarquicos(pk_nivel)
);

-- dados dos funcionários
CREATE TABLE funcionario(
pk_funcionario int PRIMARY KEY, -- código do funcionário
nome_funcionario varchar (100) NOT NULL, -- nome do funcionário
sobrenome varchar(100) NOT NULL, -- sobrenome do funcionário
cpf char(11) UNIQUE NOT NULL, -- cpf do funcionário
data_de_nascimento date NOT NULL, -- data de nascimento
sexo ENUM('feminino', 'masculino', 'outro') 
DEFAULT 'feminino', 
email varchar(100) UNIQUE NOT NULL, -- e-mail do funcionário
telefone varchar(20) UNIQUE NOT NULL, -- telefone do funcionário
cep char(8) NOT NULL, -- cep do endereço
numero int, -- número do endereço
complemento varchar(50), -- complemento do endereço
status_funcionario ENUM
('ativo','desligado','atestado','licen_maternidade', 'ferias')
);



-- relação entre funcionários e cargos
CREATE TABLE funcionario_cargos(
pk_funcionario  int NOT NULL, -- funcionário vinculado
pk_cargo int NOT NULL, -- cargo vinculado

PRIMARY KEY (pk_funcionario, pk_cargo),

FOREIGN KEY (pk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (pk_cargo) REFERENCES cargos_e_funcoes(pk_cargo)
);

-- benefícios dos funcionários
CREATE TABLE beneficios(
pk_beneficio int PRIMARY KEY, -- código do benefício
pk_funcionario int NOT NULL, -- funcionário vinculado
tipo_beneficio varchar (50) NOT NULL, -- tipo de benefício
valor_desconto decimal(12,2) NOT NULL, -- valor do desconto
data_adesao date NOT NULL, -- data de adesão

FOREIGN KEY (pk_funcionario) REFERENCES funcionario(pk_funcionario)
);

-- relação entre funcionários e benefícios
CREATE TABLE funcionario_beneficios(
pk_funcionario int NOT NULL, -- funcionário vinculado
pk_beneficios int NOT NULL, -- benefício vinculado

PRIMARY KEY (pk_funcionario, pk_beneficios),

FOREIGN KEY (pk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (pk_beneficios) REFERENCES beneficios(pk_beneficio)
);

-- qualificações dos funcionários
CREATE TABLE qualificacoes(
pk_qualificacoes int PRIMARY KEY, -- código da qualificação
fk_funcionario int NOT NULL, -- funcionário vinculado
tipo_formacao varchar(100) NOT NULL, -- tipo de formação
instituicao varchar(100) NOT NULL, -- instituição de ensino
ano_conclusao date NOT NULL, -- ano de conclusão

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario)
);

-- relação entre funcionários e qualificações
CREATE TABLE funcionario_qualificacoes(
pk_funcionarios int NOT NULL, -- funcionário vinculado
pk_qualificacoes int NOT NULL, -- qualificação vinculada

PRIMARY KEY (pk_funcionarios, pk_qualificacoes),

FOREIGN KEY (pk_funcionarios) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (pk_qualificacoes) REFERENCES qualificacoes(pk_qualificacoes)
);

-- alocação do funcionário no cargo e departamento
CREATE TABLE alocacao(
  pk_alocacao int PRIMARY KEY, -- código da alocação
  fk_funcionario  int NOT NULL, -- funcionário alocado
  fk_cargo int NOT NULL, -- cargo da alocação
  fk_departamento int NOT NULL, -- departamento da alocação
  data_inicio date NOT NULL, -- data de início
  data_fim date, -- data de fim
  horas_semanais  decimal(5,2) NOT NULL, -- horas semanais
  status_cargo ENUM ('ativo', 'encerrado_na_funcao') DEFAULT 'ativo', -- status da função
  
  FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario),
  FOREIGN KEY (fk_cargo) REFERENCES cargos_e_funcoes(pk_cargo),
  FOREIGN KEY (fk_departamento) REFERENCES departamento(pk_departamento)
);

-- contratos dos funcionários
CREATE TABLE contratos(
pk_contrato int PRIMARY KEY, -- código do contrato
fk_funcionario int NOT NULL, -- funcionário do contrato
fk_cargo int NOT NULL, -- cargo do contrato
fk_nivel int NOT NULL, -- nível do contrato
data_admissao date NOT NULL, -- data de admissão
salario_base   decimal(12,2) NOT NULL, -- salário base
status_contratos ENUM('ativo','inativo')
DEFAULT 'ativo', /*ARRUMAR DER E DICIONÁRIO DE DADOS DESSE CAMPO*/

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (fk_cargo) REFERENCES cargos_e_funcoes(pk_cargo),
FOREIGN KEY (fk_nivel) REFERENCES niveis_hierarquicos(pk_nivel)
);

-- histórico de alterações do funcionário
CREATE TABLE historico_funcionario (
pk_historico int PRIMARY KEY, -- código do histórico
fk_funcionario int NOT NULL, -- funcionário vinculado
fk_contrato int NOT NULL, -- contrato vinculado
fk_nivel int, -- nível vinculado
nome_cargo_anterior varchar(255) NOT NULL, -- cargo anterior
nome_cargo_novo varchar(255) NOT NULL, -- cargo novo
salario_anterior decimal(12,2) NOT NULL, -- salário anterior
salario_novo decimal(12,2) NOT NULL, -- salário novo
data_alteracao date, -- data da alteração
motivo varchar(255) NOT NULL, -- motivo da alteração

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (fk_contrato) REFERENCES contratos(pk_contrato),
FOREIGN KEY (fk_nivel) REFERENCES niveis_hierarquicos(pk_nivel)
);

-- dependentes dos funcionários
CREATE TABLE dependentes(
pk_dependentes int PRIMARY KEY, -- código do dependente
fk_funcionario int NOT NULL, -- funcionário responsável
nome_dependentes varchar(255) NOT NULL, -- nome do dependente
nivel_parentesco ENUM('filho','cônjuge','pai','mãe') DEFAULT 'filho', -- parentesco
data_nascimento  date NOT NULL, -- data de nascimento
cpf char(11) NOT NULL, -- cpf do dependente
email varchar(100), -- e-mail do dependente
telefone varchar(20), -- telefone do dependente

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario)
);

-- licenças dos funcionários
CREATE TABLE licencas (
pk_licenca int PRIMARY KEY, -- código da licença
fk_funcionario int NOT NULL, -- funcionário vinculado
fk_cargo int NOT NULL, -- cargo vinculado
tipo_licenca varchar(100) NOT NULL, -- tipo de licença
data_inicio date NOT NULL, -- data de início
data_fim date NOT NULL, -- data de fim
motivo_da_licenca varchar(255) NOT NULL, -- motivo da licença

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario),
FOREIGN KEY (fk_cargo) REFERENCES cargos_e_funcoes(pk_cargo)
);

-- lançamentos financeiros dos funcionários
CREATE TABLE notas_financeiro (
pk_lancamento int PRIMARY KEY, -- código do lançamento
fk_funcionario int NOT NULL, -- funcionário vinculado
tipo_de_evento varchar(50) NOT NULL, -- tipo do evento
data_pagamento date NOT NULL, -- data do pagamento
valor_monetario decimal(12,2) NOT NULL, -- valor monetário
descontos decimal(12,2) NOT NULL, -- valor dos descontos
quantidade decimal(5,2), -- quantidade
motivo varchar(255) NOT NULL, -- motivo do lançamento
status_pag ENUM('pago','cancelado','pendente') DEFAULT 'pendente', -- status do pagamento

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario)
);


/* FASE 2 - CARGA DE DADOS (OLTP)*/


/*INSERÇÃO DE DADOS - ACADÊMICO */

INSERT IGNORE INTO pessoas 
(cpf, sobrenome, primeiro_nome, dt_nasc, sexo, cor)
VALUES 
('10000000001', 'Alderson', 'Elliot', '1990-09-17', 'Masculino', 'Branca'),
('10000000002', 'Moss', 'Angela', '1991-02-27', 'Feminino', 'Branca'),
('10000000003', 'Wellick', 'Tyrell', '1982-11-03', 'Masculino', 'Branca'),
('10000000004', 'Price', 'Phillip', '1960-05-12', 'Masculino', 'Branca'),
('10000000005', 'Alderson', 'Darlene', '1992-07-01', 'Feminino', 'Branca');

SELECT COUNT(*) FROM pessoas;


INSERT IGNORE INTO aluno (ra, cpf)
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
(codigo_nota, ra, codigo_disciplina, bimestre, nota, data_lancamento)
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

/* TESTES - SELECT */

SELECT COUNT(*) FROM pessoas;
SELECT COUNT(*) FROM professor;
SELECT COUNT(*) FROM disciplina;
SELECT COUNT(*) FROM matricula;
SELECT COUNT(*) FROM nota;
SELECT COUNT(*) FROM frequencia;
SELECT COUNT(*) FROM responsavel;

SELECT *  FROM pessoas; 

/*INSERÇÃO DE DADOS - FINANCEIRO */

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

/* TESTES - SELECT */

SELECT COUNT(*) FROM ESCOLA;
SELECT COUNT(*) FROM VERBA;
SELECT COUNT(*) FROM FORNECEDOR;
SELECT COUNT(*) FROM DESPESA;
SELECT COUNT(*) FROM PAGAMENTO_FORNECEDOR;

/* INSERÇÃO DE DADOS - RH */
INSERT INTO DEPARTAMENTO 
(pk_departamento, nome_departamento)
VALUES(1, 'Tecnologia'),(2, 'Recursos Humanos')
ON DUPLICATE KEY UPDATE nome_departamento = VALUES(nome_departamento);

INSERT INTO NIVEIS_HIERARQUICOS 
(pk_nivel, nome_nivel)
VALUES(1, 'Júnior'),(2, 'Pleno'),
 (3, 'Sênior')
ON DUPLICATE KEY UPDATE nome_nivel = VALUES(nome_nivel);

INSERT INTO CARGOS_E_FUNCOES 
(pk_cargo, nome_cargo, fk_departamento, fk_nivel, descricao_atividades, piso_salarial, teto_salarial)
VALUES(1, 'Desenvolvedor', 1, 2, 'Desenvolvimento de sistemas', 3000, 8000),(2, 'Analista RH', 2, 2, 'Gestão de pessoas', 2500, 6000)
ON DUPLICATE KEY UPDATE piso_salarial = VALUES(piso_salarial);

INSERT INTO FUNCIONARIO 
(pk_funcionario, nome_funcionario, sobrenome, cpf, data_de_nascimento, email, telefone, cep, data_criacao)
VALUES(1, 'Carlos', 'Silva', '12345678901', '1990-05-10', 'carlos@email.com', '11999999999', '01001000', CURRENT_TIMESTAMP),
    (2, 'Ana', 'Souza', '98765432100', '1992-08-15', 'ana@email.com', '11988888888', '02002000', CURRENT_TIMESTAMP)
ON DUPLICATE KEY UPDATE nome_funcionario = VALUES(nome_funcionario);

INSERT INTO CONTRATOS 
(pk_contrato, fk_funcionario, fk_cargo, fk_nivel, data_admissao, salario_base)
VALUES(1, 1, 1, 2, '2023-01-10', 5000), (2, 2, 2, 2, '2023-03-15', 4000)
ON DUPLICATE KEY UPDATE salario_base = VALUES(salario_base);

/* TESTES - SELECT */
SELECT COUNT(*) FROM FUNCIONARIO;
SELECT COUNT(*) FROM DEPARTAMENTO;
SELECT COUNT(*) FROM CARGOS_E_FUNCOES;
SELECT COUNT(*) FROM CONTRATOS;

/* FASE 3 - OPERAÇÕES OLTP */

/* SUBSELECT COM AGREGAÇÃO - ACADEMICO */
SELECT ra
FROM aluno
WHERE ra IN (
    SELECT ra
    FROM nota
    GROUP BY ra
    HAVING AVG(nota) >= 9
);

/* ///////////// TRANSAÇÃO COM ROLLBACK /////////////////// */

START TRANSACTION;
INSERT INTO nota (codigo_nota, ra, codigo_disciplina, bimestre, nota, data_lancamento)
VALUES ('N997', 'RA001', 'HACK01', 1, 7.0, NOW());
ROLLBACK;
SELECT * FROM nota WHERE codigo_nota = 'N997';

/* ////////////// TRANSAÇÃO COM COMMIT //////////////// */

START TRANSACTION;
INSERT INTO nota (codigo_nota, ra, codigo_disciplina, bimestre, nota, data_lancamento)
VALUES ('N1004', 'RA001', 'HACK01', 1, 9.5, NOW());
COMMIT;
SELECT * FROM nota WHERE codigo_nota = 'N1004';

/*SELECT SIMPLES - FINANCEIRO */

SELECT nome, CNPJ FROM ESCOLA;
SELECT codigo_verba, valor FROM VERBA;
SELECT nome FROM FORNECEDOR;
SELECT numero_nota_fiscal, valor FROM DESPESA;
SELECT numero_comprovante, valor_pago FROM PAGAMENTO_FORNECEDOR;

/*SUBSELECT COM AGREGAÇÃO - FINANCEIRO */

SELECT codigo_verba
FROM VERBA
WHERE codigo_verba IN (
    SELECT codigo_verba
    FROM DESPESA
    GROUP BY codigo_verba
    HAVING SUM(valor) > 10000
);

/*TRANSAÇÕES ROLLBACK - FINANCEIRO */

START TRANSACTION;
INSERT INTO PAGAMENTO_FORNECEDOR VALUES ('PG_TESTE', '2024-04-01', 1000.00, 'PIX', 'PAGO', 'NF101', '22334455000166', CURRENT_TIMESTAMP);
ROLLBACK;

/*TRANSAÇÕES COMMIT - FINANCEIRO */

START TRANSACTION;
INSERT INTO PAGAMENTO_FORNECEDOR VALUES ('PG_OK_FINAL', '2024-04-01', 1000.00, 'PIX', 'PAGO', 'NF101', '22334455000166', CURRENT_TIMESTAMP);
COMMIT;

/*SELECT SIMPLES - RH */
SELECT nome_funcionario, sobrenome FROM FUNCIONARIO;
SELECT nome_departamento FROM DEPARTAMENTO;
SELECT nome_cargo FROM CARGOS_E_FUNCOES;

/* SUBSELECT COM AGREGAÇÃO - RH */
SELECT nome_funcionario
FROM FUNCIONARIO
WHERE pk_funcionario IN (
    SELECT fk_funcionario
    FROM NOTAS_FINANCEIRO
    GROUP BY fk_funcionario
    HAVING SUM(valor_monetario) > 4000
);

/* TRANSAÇÕES RH  */
-- ROLLBACK
START TRANSACTION;
INSERT INTO NOTAS_FINANCEIRO (pk_lancamento, fk_funcionario, descricao, data_lancamento, valor_monetario) 
VALUES (10, 1, 'Bônus', '2024-03-10', 1000);
ROLLBACK;

-- COMMIT
START TRANSACTION;
INSERT INTO NOTAS_FINANCEIRO (pk_lancamento, fk_funcionario, descricao, data_lancamento, valor_monetario) 
VALUES (11, 1, 'Bônus', '2024-03-10', 1000);
COMMIT;


/* FASE 4 - MODELO OLAP (ESTRELA)*/

/*CRIAÇÃO - ACADÊMICO */

/* GRANULARIDADE: 1 linha representa uma presença de 
1 aluno em uma data de aula. */

CREATE TABLE dim_aluno (
    sk_aluno INT AUTO_INCREMENT PRIMARY KEY,
    ra VARCHAR(20) NOT NULL UNIQUE,
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

/*CRIAÇÃO - FINANCEIRO */

/* GRANULARIDADE: 1 linha na tabela fato representa 
1 pagamento por fornecedor por data. */

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

/* CRIAÇÃO - RH */

/* GRANULARIDADE: 1 linha na tabela fato representa 
1 pagamento de salário por funcionário por data de referência.*/

-- Tabela Fato:
CREATE TABLE FATO_FOLHA_PAGAMENTO (
    sk_fato INT AUTO_INCREMENT PRIMARY KEY,
    sk_tempo INT,
    sk_funcionario INT,
    sk_departamento INT,
    valor_total DECIMAL(12,2)
);

-- Dimensão Tempo:
CREATE TABLE DIM_TEMPO_RH (
    sk_tempo INT AUTO_INCREMENT PRIMARY KEY,
    data DATE,
    ano INT,
    mes INT,
    nome_mes VARCHAR(20)
);

-- Dimensão Funcionário:
CREATE TABLE DIM_FUNCIONARIO (
    sk_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    pk_funcionario INT,
    nome_completo VARCHAR(200),
    cpf VARCHAR(11)
);

-- Dimensão Departamento:
CREATE TABLE DIM_DEPARTAMENTO (
    sk_departamento INT AUTO_INCREMENT PRIMARY KEY,
    pk_departamento INT,
    nome_departamento VARCHAR(100)
);


/* ETL (CARGA DAS DIMENSÕES E FATO)*/

/* CARGA - ACADÊMICO */

INSERT INTO dim_aluno (
    ra,
    cpf,
    primeiro_nome,
    sobrenome,
    data_nascimento
)
SELECT 
    a.ra,
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
JOIN dim_aluno da ON da.ra = f.ra_aluno
JOIN dim_disciplina dd ON dd.codigo_disciplina = f.codigo_disciplina
JOIN dim_turma dtur 
    ON dtur.nome_turma = (
        SELECT turma 
        FROM matricula m 
        WHERE m.ra = f.ra_aluno 
        LIMIT 1
    )
JOIN dim_tempo dt 
    ON dt.data_completa = f.data_aula;

/* CARGA - FINANCEIRO */

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

/* CARGA - RH */
-- Carga dimensão tempo
INSERT INTO DIM_TEMPO_RH (data, ano, mes, nome_mes)
SELECT DISTINCT data_admissao, YEAR(data_admissao), MONTH(data_admissao), MONTHNAME(data_admissao)
FROM CONTRATOS;

-- Carga dimensão funcionário
INSERT INTO DIM_FUNCIONARIO (pk_funcionario, nome_completo, cpf)
SELECT pk_funcionario, CONCAT(nome_funcionario, ' ', sobrenome), cpf 
FROM FUNCIONARIO;

-- Carga dimensão departamento
INSERT INTO DIM_DEPARTAMENTO (pk_departamento, nome_departamento)
SELECT pk_departamento, nome_departamento 
FROM DEPARTAMENTO;

-- Carga fato
INSERT INTO FATO_FOLHA_PAGAMENTO (sk_tempo, sk_funcionario, sk_departamento, valor_total)
SELECT dt.sk_tempo, df.sk_funcionario, dd.sk_departamento, c.salario_base
FROM CONTRATOS c
JOIN DIM_TEMPO_RH dt ON dt.data = c.data_admissao
JOIN DIM_FUNCIONARIO df ON df.pk_funcionario = c.fk_funcionario
JOIN CARGOS_E_FUNCOES cf ON c.fk_cargo = cf.pk_cargo
JOIN DIM_DEPARTAMENTO dd ON cf.fk_departamento = dd.pk_departamento;


/*  EXTRAÇÃO (OLTP) */
SELECT 
    f.ra_aluno,
    f.codigo_disciplina,
    f.data_aula,
    f.status_presenca
FROM frequencia f;

/* LOOKUP PARA CARGA DA FATO (OLAP) */

    SELECT 
    da.sk_aluno,
    dd.sk_disciplina,
    dt.sk_tempo,
    dtur.sk_turma,
    f.status_presenca
FROM frequencia f
JOIN dim_aluno da 
    ON f.ra_aluno = da.ra

JOIN dim_disciplina dd 
    ON f.codigo_disciplina = dd.codigo_disciplina

JOIN matricula m 
    ON f.RA_aluno = m.ra 
    AND f.codigo_disciplina = m.codigo_disciplina

JOIN dim_turma dtur 
    ON m.turma = dtur.nome_turma 
    AND m.ano_letivo = dtur.ano_letivo

JOIN dim_tempo dt 
    ON dt.dia = DAY(f.data_aula)
    AND dt.mes = MONTH(f.data_aula)
    AND dt.ano = YEAR(f.data_aula);
    
/* VALIDAÇÃO DO DW */

/*VALIDAÇÃO ETL ACADÊMICO */

-- consistência OLTP vs OLAP 
SELECT COUNT(*) FROM frequencia;
SELECT COUNT(*) FROM fato_frequencia;

-- validação de métricas 
SELECT SUM(qtd_presenca + qtd_falta + qtd_falta_justificada)
FROM fato_frequencia;

/*VALIDAÇÃO ETL - FINANCEIRO */
SELECT SUM(valor_pago) FROM PAGAMENTO_FORNECEDOR;
SELECT SUM(valor_total) FROM FATO_FINANCEIRO;

/*VALIDAÇÃO ETL - RH */
SELECT SUM(salario_base) FROM CONTRATOS;
SELECT SUM(valor_total) FROM FATO_FOLHA_PAGAMENTO;

SELECT d.nome_mes, SUM(f.valor_total) AS total_folha
FROM FATO_FOLHA_PAGAMENTO f
JOIN DIM_TEMPO d ON f.sk_tempo = d.sk_tempo
GROUP BY d.nome_mes
ORDER BY total_folha DESC;


/* FASE 5 - ÍNDICES E OTIMIZAÇÃO */

/*ACADÊMICO */

CREATE INDEX idx_fato_frequencia_aluno 
ON fato_frequencia(sk_aluno);

CREATE INDEX idx_fato_frequencia_disciplina 
ON fato_frequencia(sk_disciplina);


CREATE INDEX idx_fato_frequencia_turma 
ON fato_frequencia(sk_turma);

CREATE INDEX idx_fato_frequencia_tempo 
ON fato_frequencia(sk_tempo);

-- VALIDAÇÃO COM EXPLAIN 

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
    
/* FINANCEIRO */

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

-- VALIDAÇÃO COM EXPLAIN

EXPLAIN SELECT d.numero_nota_fiscal, f.nome
FROM despesa d
JOIN fornecedor f ON d.cnpj_fornecedor = f.cnpj;

/* RH */

CREATE INDEX idx_cargos_fk_departamento ON cargos_e_funcoes(fk_departamento);
CREATE INDEX idx_cargos_fk_nivel ON cargos_e_funcoes(fk_nivel);
CREATE INDEX idx_contratos_fk_funcionario ON contratos(fk_funcionario);
CREATE INDEX idx_contratos_fk_cargo ON contratos(fk_cargo);
CREATE INDEX idx_alocacao_fk_funcionario ON alocacao(fk_funcionario);
CREATE INDEX idx_alocacao_fk_cargo ON alocacao(fk_cargo);
CREATE INDEX idx_beneficios_pk_funcionario ON beneficios(pk_funcionario);
CREATE INDEX idx_notas_financeiro_fk_funcionario ON notas_financeiro(fk_funcionario);
CREATE INDEX idx_historico_fk_funcionario ON historico_funcionario(fk_funcionario);
CREATE INDEX idx_dependentes_fk_funcionario ON dependentes(fk_funcionario);

-- VALIDAÇÃO COM EXPLAIN
EXPLAIN SELECT 
    f.nome_funcionario, 
    c.salario_base, 
    n.valor_monetario 
FROM funcionario f
JOIN contratos c ON f.pk_funcionario = c.fk_funcionario
JOIN notas_financeiro n ON f.pk_funcionario = n.fk_funcionario
WHERE f.cpf = '12345678901';