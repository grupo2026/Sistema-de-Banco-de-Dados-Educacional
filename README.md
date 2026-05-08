# Sistema de Banco de Dados Educacional

## Introdução

Nosso projeto tem como objetivo modelar um sistema voltado para uma escola pública do ensino fundamental e médio, com base na proposta do SisGESC (Sistema de Gestão Educacional). A escola que escolhemos nos informou diversas mudanças que gostariam que existissem no sistema deles, com a necessidade de organizar e integrar essas informações de forma eficiente, garantindo controle, segurança e praticidade relacionados aos alunos e ao seu desempenho escolar.

O sistema que desenvolvemos inclui os módulos acadêmico, financeiro e de recursos humanos, responsáveis por gerenciar de forma integrada o ciclo de vida dos alunos, responsáveis e colaboradores dentro da instituição.

Como diferencial do projeto, resolvemos implementar uma solução voltada à segurança dos alunos, por meio do cadastro de responsáveis e contatos de emergência, além de criarmos um sistema de notificação que alerta o responsável do aluno em tempo real sobre presença ou ausência nas aulas. Essa funcionalidade tem como principal objetivo atender a uma necessidade real das escolas públicas, considerando que muitos alunos deixam o ambiente escolar mesmo após registrarem presença.

Por fim, a modelagem do sistema foi desenvolvida por meio de um Diagrama Entidade-Relacionamento (DER), com o objetivo de atender às necessidades levantadas através de uma entrevista realizada com a coordenação de uma escola pública.

---

## Módulos do Sistema

- **Acadêmico:** controle de alunos, turmas, notas e frequência  
- **Financeiro:** gestão de verbas, despesas e pagamentos  
- **Recursos Humanos:** controle de funcionários e vínculos  

---

## Diferencial do Projeto

Como diferencial, implementamos uma solução voltada à segurança dos alunos, incluindo:

- Cadastro de responsáveis  
- Contatos de emergência  
- Sistema de notificação em tempo real  

Esse sistema alerta os responsáveis sobre a presença ou ausência dos alunos nas aulas, atendendo uma necessidade real das escolas públicas.

---

## Modelagem

O modelo foi desenvolvido com base em um Diagrama Entidade-Relacionamento (DER), representando as entidades, atributos e relacionamentos do sistema.

---

## BI e IA

O banco foi estruturado para possibilitar análises futuras, como:

- previsão de inadimplência  
- análise de desempenho acadêmico  
- identificação de evasão escolar  

---

## Estrutura do Projeto

```text
├── documentacao/
│   ├── der/
│   │   └── der.png
│   ├── dicionarios/
│   │   └── dicionario_rh.pdf
│   ├── bi_ia.md
│   ├── regras_negocio.md
│   └── requisitos.md
│
├── sql/
│   └── run_all.sql
│
└── README.md
```

---

## Documentação Completa

- Acesse o diagrama DER: [Clique aqui](documentacao/der/der.png)

- [Visualizar Diagrama Online](https://dbdiagram.io/d/69e3f8ae0aa78f6bc108e841)

- Acesse o Dicionário de Dados: [Clique aqui](documentacao/dicionarios/dicionario_rh.pdf)

- Acesse BI e IA: [Clique aqui](documentacao/bi_ia.md)

- Acesse Regras de Negócio: [Clique aqui](documentacao/regras_negocio.md)

- Acesse Requisitos: [Clique aqui](documentacao/requisitos.md)

---

## SQL

- [Script SQL](sql/run_all.sql)

---

## Como Executar o Projeto


### Requisitos

- MySQL Server
- MySQL Workbench ou XAMPP

### Passos

1. Abra o MySQL Workbench.

2. Conecte no seu servidor MySQL.

3. No GitHub, baixe ou clone o projeto.

4. No Workbench:
   - clique em `File`
   - depois em `Open SQL Script`

5. Abra o arquivo:

```text
run_all.sql
```

6. Clique no ícone de raio ⚡ para executar o script.

7. O banco de dados será criado automaticamente com toda a estrutura necessária para o funcionamento do sistema.

---

## Tecnologias Utilizadas

- SQL
- DER (Diagrama Entidade-Relacionamento)
- dbdiagram.io (modelagem do banco)
- Vs Code
- GitHub

---

## Organização

O projeto foi desenvolvido em grupo, com divisão de responsabilidades entre os integrantes.
