# Dicionário de Dados – RH 

### Tabela e descrição

| Nome das Tabelas RH | Descrição |
|--------|----------|
| Cargos_e_Funcoes | Armazena os dados referentes à estrutura de cargos e funções da escola.a |
| Funcionario | Entidade abstrata que armazena os dados cadastrais sobre os funcionários da escola (Professores, Diretores, Etc) |
| Alocacao | Armazena as informações de alocação dos funcionários em seus setores e horários de trabalho |
| Departamento | Armazena o cadastro dos departamentos e suas respectivas nomenclaturas. |
| Contratos | Armazena os registros e condições contratuais dos funcionários. |
| Historico_Funcionario | Registra o histórico de cargos e salários dos colaboradores. |
| Qualificacoes | Armazena as informações sobre o histórico de capacitação dos funcionários da escola. |
| Beneficios | Cataloga os tipos de benefícios disponíveis para os funcionários da escola. |
| Dependentes | Armazena os dados dos dependentes vinculados aos funcionários da escola|
| Licencas |Armazena o histórico de períodos de licença e justificativas dos funcionários da escola. |
| Notas_Financeiro | Registra a emissão de notas fiscais e gerencia o encaminhamento para o departamento financeiro. |
| Niveis_Hierarquicos | Armazena a classificação dos níveis de cargos e suas respectivas hierarquias na escola.|
| Funcionario_Cargos |Tabela de associação que estabelece o relacionamento muitos-para-muitos entre funcionários e cargos, permitindo o histórico de funções na instituição. |
| Funcionario_Beneficios | Tabela de associação que estabelece o relacionamento muitos-para-muitos entre funcionários e benefícios |
| Funcionario_Qualificacoes | Tabela de associação que estabelece o relacionamento muitos-para-muitos entre funcionários e qualificações. |

---

### Tabela: Cargos_e_Funcoes

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_cargo | INT | - | - | Sim | Não | Não | Sim | Identificador do cargo |
| nome_cargo | VARCHAR | 255 | - | Não | Não | Não | Não | Nome do cargo |
| fk_departamento | INT | - | - | Não | Sim | Não | Não | Departamento |
| fk_nivel | INT | - | - | Não | Sim | Não | Não | Nível hierárquico |
| descricao_atividades | VARCHAR | 255 | - | Não | Não | Não | Não | Atividades |
| piso_salarial | DECIMAL | 12,2 | - | Não | Não | Não | Não | Piso salarial |
| teto_salarial | DECIMAL | 12,2 | - | Não | Não | Não | Não | Teto salarial |

---


 ### Tabela: Funcionario

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_funcionario | INT | - | - | Sim | Não | Não | Sim | Identificador do funcionário |
| nome_funcionario | VARCHAR | 100 | - | Não | Não | Não | Não | Nome do funcionário |
| sobrenome | VARCHAR | 100 | - | Não | Não | Não | Não | Sobrenome |
| cpf | CHAR | 11 | 999.999.999-99 | Não | Não | Não | Sim | CPF |
| data_de_nascimento | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Data de nascimento |
| sexo | ENUM | - | feminino, masculino, outro | Não | Não | Não | Não | Sexo |
| email | VARCHAR | 100 | - | Não | Não | Não | Sim | Email |
| telefone | VARCHAR | 20 | - | Não | Não | Não | Sim | Telefone |
| cep | CHAR | 8 | 99999-999 | Não | Não | Não | Não | CEP |
| numero | INT | - | - | Não | Não | Sim | Não | Número |
| complemento | VARCHAR | 50 | - | Não | Não | Sim | Não | Complemento |
| status | ENUM | - | ativo, desligado, atestado, licen maternidade, férias | Não | Não | Sim | Não | Status |

--- 

### Tabela: Alocacao

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_alocacao | INT | - | - | Sim | Não | Não | Sim | Identificador |
| fk_funcionario | INT | - | - | Não | Sim | Não | Não | Funcionário |
| fk_cargo | INT | - | - | Não | Sim | Não | Não | Cargo |
| fk_departamento | INT | - | - | Não | Sim | Não | Não | Departamento |
| data_inicio | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Início |
| data_fim | DATE | - | YYYY-MM-DD | Não | Não | Sim | Não | Fim |
| horas_semanais | DECIMAL | 12,2 | - | Não | Não | Não | Não | Horas |
| status_cargo | ENUM | - | ativo, encerrado_na_funcao | Não | Não | Não | Não | Status |

---

### Tabela: Departamento

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_departamento | INT | - | - | Sim | Não | Não | Sim | Identificador |
| nome_departamento | VARCHAR | 255 | - | Não | Não | Não | Não | Nome |

---

### Tabela: Contratos

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_contrato | INT | - | - | Sim | Não | Não | Sim | Identificador |
| fk_funcionario | INT | - | - | Não | Sim | Não | Não | Funcionário |
| fk_cargo | INT | - | - | Não | Sim | Não | Não | Cargo |
| fk_nivel | INT | - | - | Não | Sim | Não | Não | Nível |
| data_admissao | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Admissão |
| salario_base | DECIMAL | 12,2 | - | Não | Não | Não | Não | Salário |
| status | ENUM | - | ativo, inativo | Não | Não | Sim | Não | Status |

---

### Tabela: Historico_Funcionario

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_historico | INT | - | - | Sim | Não | Não | Sim | Identificador |
| fk_funcionario | INT | - | - | Não | Sim | Não | Não | Funcionário |
| fk_contrato | INT | - | - | Não | Sim | Não | Não | Contrato |
| fk_nivel | INT | - | - | Não | Sim | Não | Não | Nível |
| nome_cargo_anterior | VARCHAR | 255 | - | Não | Não | Não | Não | Cargo anterior |
| nome_cargo_novo | VARCHAR | 255 | - | Não | Não | Não | Não | Novo cargo |
| salario_anterior | DECIMAL | 12,2 | - | Não | Não | Não | Não | Salário anterior |
| salario_novo | DECIMAL | 12,2 | - | Não | Não | Não | Não | Novo salário |
| data_alteracao | DATE | - | YYYY-MM-DD | Não | Não | Sim | Não | Data |
| motivo | VARCHAR | 255 | - | Não | Não | Não | Não | Motivo |

---

### Tabela: Qualificacoes

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_qualificacoes | INT | - | - | Sim | Não | Não | Sim | Identificador |
| fk_funcionario | INT | - | - | Não | Sim | Não | Não | Funcionário |
| tipo_formacao | VARCHAR | 100 | - | Não | Não | Não | Não | Formação |
| instituicao | VARCHAR | 100 | - | Não | Não | Não | Não | Instituição |
| ano_conclusao | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Conclusão |

---

### Tabela: Beneficios

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_beneficios | INT | - | - | Sim | Não | Não | Sim | Identificador |
| fk_funcionario | INT | - | - | Não | Sim | Não | Não | Funcionário |
| tipo_beneficio | VARCHAR | 50 | VT, VR, Plano de Saúde | Não | Não | Sim | Não | Tipo |
| valor_desconto | DECIMAL | 12,2 | - | Não | Não | Não | Não | Valor |
| data_adesao | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Data |

---

### Tabela: Beneficios

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_beneficios | INT | - | - | Sim | Não | Não | Sim | Identificador |
| fk_funcionario | INT | - | - | Não | Sim | Não | Não | Funcionário |
| tipo_beneficio | VARCHAR | 50 | VT, VR, Plano de Saúde | Não | Não | Sim | Não | Tipo |
| valor_desconto | DECIMAL | 12,2 | - | Não | Não | Não | Não | Valor |
| data_adesao | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Data |

---

### Tabela: Dependentes

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_dependentes | INT | - | - | Sim | Não | Não | Sim | Identificador |
| fk_funcionario | INT | - | - | Não | Sim | Não | Não | Funcionário |
| nome_dependentes | VARCHAR | 255 | - | Não | Não | Não | Não | Nome |
| nivel_parentesco | ENUM | - | filho(a), cônjuge, pai, mãe | Não | Não | Não | Não | Parentesco |
| data_nascimento | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Nascimento |
| cpf | CHAR | 11 | 999.999.999-99 | Não | Não | Não | Não | CPF |
| email | VARCHAR | 100 | - | Não | Não | Sim | Não | Email |
| telefone | VARCHAR | 20 | - | Não | Não | Sim | Não | Telefone |

---

### Tabela: Licencas

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_licenca | INT | - | - | Sim | Não | Não | Sim | Identificador |
| fk_funcionario | INT | - | - | Não | Sim | Não | Não | Funcionário |
| fk_cargo | INT | - | - | Não | Sim | Não | Não | Cargo |
| tipo_licenca | VARCHAR | 100 | - | Não | Não | Não | Não | Tipo |
| data_inicio | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Início |
| data_fim | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Fim |
| motivo_da_licenca | VARCHAR | 255 | - | Não | Não | Não | Não | Motivo |

---

### Tabela: Notas_Financeiro

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_lancamento | INT | - | - | Sim | Não | Não | Sim | Identificador |
| fk_funcionario | INT | - | - | Não | Sim | Não | Não | Funcionário |
| tipo_de_evento | VARCHAR | 50 | - | Não | Não | Não | Não | Tipo |
| data_pagamento | DATE | - | YYYY-MM-DD | Não | Não | Não | Não | Data |
| valor_monetario | DECIMAL | 12,2 | - | Não | Não | Não | Não | Valor |
| descontos | DECIMAL | 12,2 | - | Não | Não | Não | Não | Descontos |
| quantidade | DECIMAL | 5,2 | - | Não | Não | Sim | Não | Quantidade |
| motivo | VARCHAR | 255 | - | Não | Não | Não | Não | Motivo |
| status_pag | ENUM | - | pago, cancelado, pendente | Não | Não | Não | Não | Status |

---

### Tabela:  Niveis_Hierarquicos

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_nivel | INT | - | - | Sim | Não | Não | Sim | Identificador |
| nome_nivel | VARCHAR | 50 | Júnior, Pleno, Sênior | Não | Não | Sim | Não | Nome |

---


### Tabela: Funcionario_Cargos

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| pk_funcionario | INT | - | - | Sim| - | Não | Sim | Identificador do funcionário. |
| pk_cargo  | INT | 50 | -| - | Sim | - | Não | Sim | Identificador Identificador de cargos.|

--- 
### Tabela: N:N

 | Campo | Tipo | Tamanho | Formato |Chave Primária | Chave Estrangeira |Valores Nulos |Valores Únicos | Descrição |
|------|------|--------|--------|----|----|------|------|-----------|
| Funcionario_Cargos | pk_funcionario | INT | Sim | Sim | Funcionário |
| Funcionario_Cargos | pk_cargo | INT | Sim | Sim | Cargo |
| Funcionario_Beneficios | pk_funcionario | INT | Sim | Sim | Funcionário |
| Funcionario_Beneficios | pk_beneficios | INT | Sim | Sim | Benefício |
| Funcionario_Qualificacoes | pk_funcionario | INT | Sim | Sim | Funcionário |
| Funcionario_Qualificacoes | pk_qualificacoes | INT | Sim | Sim | Qualificação |




