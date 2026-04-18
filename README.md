# Sistema de Banco de Dados Educacional

## Introdução
Este projeto tem como objetivo modelar um sistema de banco de dados voltado para uma escola pública de ensino fundamental e médio, com base na proposta do SisGESC (Sistema de Gestão Educacional).

A proposta surgiu a partir de necessidades reais identificadas na escola analisada, que relatou dificuldades na organização e integração das informações. A ideia é tornar esse controle mais eficiente, garantindo mais segurança, praticidade e melhor acompanhamento do desempenho dos alunos.

O sistema foi estruturado em três módulos principais: acadêmico, financeiro e de recursos humanos. Esses módulos trabalham de forma integrada para gerenciar alunos, responsáveis e colaboradores dentro da instituição.

Como diferencial, o projeto propõe uma solução voltada à segurança dos alunos, com cadastro de responsáveis e contatos de emergência, além de um sistema de notificação que informa, em tempo real, a presença ou ausência nas aulas. Essa funcionalidade busca atender uma situação comum em escolas públicas, onde alunos podem sair do ambiente escolar após o registro de presença.

A modelagem do banco foi desenvolvida a partir de um Diagrama Entidade-Relacionamento (DER), construído com base nas necessidades levantadas em uma entrevista com a coordenação da escola.

---

## Módulos do Sistema

- **Acadêmico:** controle de alunos, turmas, notas e frequência  
- **Financeiro:** gestão de verbas, despesas e pagamentos  
- **Recursos Humanos:** controle de funcionários e vínculos  

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

- `docs/` → documentação do sistema  
- `sql/` → scripts do banco de dados  

---

## Documentação

- [Dicionário de Dados](docs/dicionario_dados.md)
  
- [Requisitos](docs/requisitos.md)
  
- [Regras de Negócio](docs/regras_negocio.md)
  
- [BI e IA](docs/bi_ia.md)

- ![DER](docs/DER.png)


---


## SQL 

- [Script sql ](sql/script.sql)

---

##  Tecnologias utilizadas
- SQL
- DER (Diagrama Entidade-Relacionamento)
- dbdiagram.io (modelagem do banco)

---

## Organização

O projeto foi desenvolvido em grupo, com divisão de responsabilidades entre os integrantes.
