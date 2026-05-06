

Tabela Acadêmico : 

Table pessoas { 

  cpf char (11) [pk, not null] 

  sobrenome varchar(20) [not null] 

  primeiro_nome varchar(50) [not null] 

  dt_nasc date [not null] 

  sexo enum_sexo [default: 'Outro'] 

  cor enum_cor [default: 'Outro'] 

  

} 

  Enum enum_sexo{ 

Feminino 

Masculino 

Outro 

}  

  

Enum enum_cor { 

Amarela 

Branca 

Indigena 

Negra 

Parda 

Outro 

} 

  

  

Table logradouro_cep { 

  cep char(8) [pk, not null] 

  logradouro varchar(100) [not null] 

  bairro varchar(50) [not null] 

  cidade varchar(50) [not null] 

  estado enum_estado [not null] 

} 

Enum enum_estado { 

  AC 

  AL 

  AP 

  AM 

  BA 

  CE 

  DF 

  ES 

  GO 

  MA 

  MT 

  MS 

  MG 

  PA 

  PB 

  PR 

  PE 

  PI 

  RJ 

  RN 

  RS 

  RO 

  RR 

  SC 

  SP 

  SE 

  TO 

  } 

  

Table endereco { 

  pk_endereco int [pk] 

  cpf_pessoa char(11) [not null, ref: > pessoas.cpf] 

  cep char(8) [not null, ref: > logradouro_cep.cep] 

  numero char (10) 

  complemento varchar(50) 

} 

  

Table aluno { 

  RA varchar(20) [pk, not null] 

  cpf char(11) [not null, unique, ref: > pessoas.cpf] 

}  

  

 Table professor { 

  cpf char(11) [pk, not null, ref: > pessoas.cpf] 

} 

  

Table disciplina { 

  codigo_disciplina varchar(20) [pk] 

  nome_disciplina varchar(100) [not null] 

  carga_horaria int [not null] 

} 

  

Table professor_disciplina { 

  pk_prof_disc int [pk] 

  cpf char(11) [not null, ref: > professor.cpf] 

  codigo_disciplina varchar(20) [not null, ref: > disciplina.codigo_disciplina] 

} 

  

Table matricula { 

  codigo_matricula varchar(20) [pk, not null] 

  codigo_disciplina varchar(20) [not null, ref: > disciplina.codigo_disciplina] 

  RA varchar(20) [not null, ref: > aluno.RA] 

  turma varchar(50) [not null] 

  ano_letivo int [not null] 

  turno enum_turno [default: 'Manhã'] 

  data_matricula date [not null] 

  status_matricula enum_status_matricula [default: 'Ativo']} 

   

  Enum enum_turno { 

Manhã 

Tarde 

Noite 

} 

  

Enum enum_status_matricula { 

  Ativo 

  Inativo 

  Trancado 

  Desistente 

} 

Table nota { 

  codigo_nota varchar(20) [pk, not null] 

  RA varchar(20) [not null, ref: > aluno.RA] 

  codigo_disciplina varchar(20) [not null, ref: > disciplina.codigo_disciplina] 

  bimestre int [not null] 

  nota decimal(4,2) [not null] 

  data_lancamento timestamp 

} 

  

Table frequencia { 

  pk_frequencia int [pk] 

  RA_aluno varchar(20) [not null, ref: > aluno.RA] 

  codigo_disciplina varchar(20) [not null, ref: > disciplina.codigo_disciplina] 

  data_aula date [not null] 

  status_presenca enum_presenca [default: 'Ausente'] 

} 

Enum enum_presenca { 

  Presente 

  Ausente 

  Justificada 

} 

  

Table notificacoes { 

  pk_notificacao int [not null, pk] 

  responsavel char(11) [not null, ref: > responsavel.cpf] 

  aluno varchar(20) [not null, ref: > aluno.RA] 

  frequencia int [not null, ref: > frequencia.pk_frequencia] // Ligação com o evento da aula 

  mensagem text [not null] 

  data_envio timestamp 

  status_envio enum_status_envio [default: 'Pendente'] 

} 

  

Enum enum_status_envio { 

  Pendente 

  Enviado 

  Falha 

} 

  

Table responsavel { 

  cpf char(11) [pk, not null, ref: > pessoas.cpf] 

} 

  

Table telefone_responsavel { 

  telefone varchar(20) [pk] 

  cpf_responsavel char(11) [not null, ref: > responsavel.cpf] 

} 

  

 

 

Table email_responsavel { 

  email varchar(255) [pk] 

  cpf_responsavel char(11) [not null, ref: > responsavel.cpf] 

} 

  

Table responsavel_aluno { 

  pk_responsavel_aluno int [pk, not null] 

  RA_aluno varchar(20) [not null, ref: > aluno.RA] 

  cpf_responsavel char(11) [not null, ref: > responsavel.cpf] 

  parentesco varchar(50) 

  } 

 

Tabela Financeiro: 

CREATE TABLE ESCOLA ( 

  CNPJ CHAR(14) PRIMARY KEY, 

  nome VARCHAR(100) NOT NULL, 

  endereco VARCHAR(255) NOT NULL, 

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 

); 

  

-- Telefones da escola (1:N) 

CREATE TABLE ESCOLA_TELEFONE ( 

  CNPJ_escola CHAR(14), 

  telefone VARCHAR(20) NOT NULL, 

  

  PRIMARY KEY (CNPJ_escola, telefone), 

  FOREIGN KEY (CNPJ_escola) REFERENCES ESCOLA(CNPJ) 

); 

  

-- Emails da escola (1:N) 

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

  status_verba VARCHAR(20) NOT NULL CHECK (status IN ('ATIVA', 'ENCERRADA', 'PENDENTE')), 

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

  data DATE NOT NULL, 

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

  status_pagto VARCHAR(20) NOT NULL DEFAULT 'NAO_PAGO' 

    CHECK (status_pagto IN ('PAGO', 'NAO_PAGO')), 

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

  status_prestacao VARCHAR(20) NOT NULL CHECK (status IN ('ENVIADO', 'APROVADO', 'REJEITADO', 'PENDENTE')), 

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

 

Tabela RH: 

-- TABELA DEPARTAMENTO 

CREATE TABLE departamento ( 

pk_departamento INT PRIMARY KEY, 

nome_departamento VARCHAR(255) 

); 

 

-- TABELA NIVEIS HIERARQUICOS 

CREATE TABLE niveis_hierarquicos ( 

pk_nivel INT PRIMARY KEY, 

nome_nivel VARCHAR(50) 

); 

 

-- TABELA CARGOS E FUNCOES 

CREATE TABLE cargos_e_funcoes ( 

pk_cargo INT PRIMARY KEY, 

nome_cargo VARCHAR(255) NOT NULL, 

fk_departamento INT NOT NULL, 

fk_nivel INT, 

descricao_atividades VARCHAR(255) NOT NULL, 

piso_salarial DECIMAL(12,2) NOT NULL, 

teto_salarial DECIMAL(12,2) NOT NULL, 

FOREIGN KEY (fk_departamento) REFERENCES departamento(pk_departamento), 

FOREIGN KEY (fk_nivel) REFERENCES niveis_hierarquicos(pk_nivel) 

); 

 

-- TABELA FUNCIONARIO 

CREATE TABLE funcionario ( 

pk_funcionario INT PRIMARY KEY, 

nome_funcionario VARCHAR(100) NOT NULL, 

sobrenome VARCHAR(100) NOT NULL, 

cpf CHAR(11) UNIQUE NOT NULL, 

data_de_nascimento DATE NOT NULL, 

sexo ENUM('feminino','masculino','outro') DEFAULT 'feminino', 

email VARCHAR(100) UNIQUE NOT NULL, 

telefone VARCHAR(20) UNIQUE NOT NULL, 

cep CHAR(8) NOT NULL, 

numero INT, 

complemento VARCHAR(50), 

status ENUM('ativo','desligado','atestado','licen maternidade','férias') DEFAULT 'ativo' 

); 

 

-- TABELA CONTRATOS 

CREATE TABLE contratos ( 

pk_contrato INT PRIMARY KEY, 

fk_funcionario INT NOT NULL, 

fk_cargo INT NOT NULL, 

fk_nivel INT NOT NULL, 

data_admissao DATE NOT NULL, 

salario_base DECIMAL(12,2) NOT NULL, 

status ENUM('ativo', 'inativo') DEFAULT 'ativo', 

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario), 

FOREIGN KEY (fk_cargo) REFERENCES cargos_e_funcoes(pk_cargo), 

FOREIGN KEY (fk_nivel) REFERENCES niveis_hierarquicos(pk_nivel) 

); 

 

-- TABELA ALOCACAO 

CREATE TABLE alocacao ( 

pk_alocacao INT PRIMARY KEY, 

fk_funcionario INT NOT NULL, 

fk_cargo INT NOT NULL, 

fk_departamento INT NOT NULL, 

data_inicio DATE NOT NULL, 

data_fim DATE, 

horas_semanais DECIMAL(5,2) NOT NULL, 

status_cargo ENUM('ativo','encerrado_na_funcao') DEFAULT 'ativo', 

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario), 

FOREIGN KEY (fk_cargo) REFERENCES cargos_e_funcoes(pk_cargo), 

FOREIGN KEY (fk_departamento) REFERENCES departamento(pk_departamento) 

); 

 

-- TABELA HISTORICO FUNCIONARIO 

CREATE TABLE historico_funcionario ( 

pk_historico INT PRIMARY KEY, 

fk_funcionario INT NOT NULL, 

fk_contrato INT NOT NULL, 

fk_nivel INT, 

nome_cargo_anterior VARCHAR(255) NOT NULL, 

nome_cargo_novo VARCHAR(255) NOT NULL, 

salario_anterior DECIMAL(12,2) NOT NULL, 

salario_novo DECIMAL(12,2) NOT NULL, 

data_alteracao DATE, 

motivo VARCHAR(255) NOT NULL, 

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario), 

FOREIGN KEY (fk_contrato) REFERENCES contratos(pk_contrato), 

FOREIGN KEY (fk_nivel) REFERENCES niveis_hierarquicos(pk_nivel) 

); 

 

-- TABELA QUALIFICACOES 

CREATE TABLE qualificacoes ( 

pk_qualificacoes INT PRIMARY KEY, 

fk_funcionario INT NOT NULL, 

tipo_formacao VARCHAR(100) NOT NULL, 

instituicao VARCHAR(100) NOT NULL, 

ano_conclusao DATE NOT NULL, 

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario) 

); 

 

-- TABELA BENEFICIOS 

CREATE TABLE beneficios ( 

pk_beneficio INT PRIMARY KEY, 

fk_funcionario INT NOT NULL, 

tipo_beneficio VARCHAR(50), 

valor_desconto DECIMAL(12,2) NOT NULL, 

data_adesao DATE NOT NULL, 

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario) 

); 

 

-- TABELA DEPENDENTES 

CREATE TABLE dependentes ( 

pk_dependentes INT PRIMARY KEY, 

fk_funcionario INT NOT NULL, 

nome_dependentes VARCHAR(255) NOT NULL, 

nivel_parentesco ENUM('filho(a)','cônjuge','pai','mãe') DEFAULT 'filho(a)', 

data_nascimento DATE NOT NULL, 

cpf CHAR(11) NOT NULL, 

email VARCHAR(100), 

telefone VARCHAR(20), 

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario) 

); 

 

-- TABELA LICENCAS 

CREATE TABLE licencas ( 

pk_licenca INT PRIMARY KEY, 

fk_funcionario INT NOT NULL, 

fk_cargo INT NOT NULL, 

tipo_licenca VARCHAR(100) NOT NULL, 

data_inicio DATE NOT NULL, 

data_fim DATE NOT NULL, 

motivo_da_lincenca VARCHAR(255) NOT NULL, 

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario), 

FOREIGN KEY (fk_cargo) REFERENCES cargos_e_funcoes(pk_cargo) 

); 

 

-- TABELA NOTAS FINANCEIRO 

CREATE TABLE notas_financeiro ( 

pk_lancamento INT PRIMARY KEY, 

fk_funcionario INT NOT NULL, 

tipo_de_evento VARCHAR(50) NOT NULL, 

data_pagamento DATE NOT NULL, 

valor_monetario DECIMAL(12,2) NOT NULL, 

descontos DECIMAL(12,2) NOT NULL, 

quantidade DECIMAL(5,2), 

motivo VARCHAR(255) NOT NULL, 

status_pag ENUM('pago','cancelado','pendente') DEFAULT 'pendente', 

FOREIGN KEY (fk_funcionario) REFERENCES funcionario(pk_funcionario) 

); 

 

-- TABELAS DE RELACIONAMENTO (N:N) 

 

CREATE TABLE funcionario_cargos ( 

pk_funcionario INT, 

pk_cargo INT, 

PRIMARY KEY (pk_funcionario, pk_cargo), 

FOREIGN KEY (pk_funcionario) REFERENCES funcionario(pk_funcionario), 

FOREIGN KEY (pk_cargo) REFERENCES cargos_e_funcoes(pk_cargo) 

); 

 

CREATE TABLE funcionario_beneficios ( 

pk_funcionario INT, 

pk_beneficios INT, 

PRIMARY KEY (pk_funcionario, pk_beneficios), 

FOREIGN KEY (pk_funcionario) REFERENCES funcionario(pk_funcionario), 

FOREIGN KEY (pk_beneficios) REFERENCES beneficios(pk_beneficio) 

); 

 

CREATE TABLE funcionario_qualificacoes ( 

pk_funcionarios INT, 

pk_qualificacoes INT, 

PRIMARY KEY (pk_funcionarios, pk_qualificacoes), 

FOREIGN KEY (pk_funcionarios) REFERENCES funcionario(pk_funcionario), 

FOREIGN KEY (pk_qualificacoes) REFERENCES qualificacoes(pk_qualificacoes) 

);
