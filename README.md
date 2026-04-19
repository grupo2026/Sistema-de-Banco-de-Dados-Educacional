# Sistema de Banco de Dados Educacional

## Introdução

Nosso projeto tem como objetivo modelar um sistema voltado para uma escola pública do ensino fundamental e médio, com base na proposta do SisGESC (Sistema de Gestão Educacional). A escola que escolhemos nos informou diversas mudanças que gostariam que existissem no sistema deles, uma necessidade de organizar e integrar essas informações de forma eficiente garantindo todo o controle, segurança e praticidade relacionados aos alunos e seu desempenho escolar.
O sistema que desenvolvemos inclui o módulo acadêmico, financeiro e de recursos humanos, que são responsáveis por gerenciar de forma integrada o ciclo de vida dos alunos, dos responsáveis e colaboradores dentro da instituição.

Como diferencial do nosso projeto resolvemos implementar uma solução voltada a segurança dos alunos, por meio de cadastro de responsáveis e contatos de emergência, além de criarmos um sistema de notificação que alerta o responsável do aluno em tempo real a presença ou ausência nas aulas. Essa funcionalidade tem como principal objetivo atender a uma necessidade real que ocorre dentro das escolas públicas, considerando que muitos alunos deixam o ambiente escolar mesmo após registrarem presença.

Por fim, a modelagem do sistema foi desenvolvida por meio de uma Diagrama Entidade-Relacionamento (DER) com o objetivo de atender as necessidades levantadas através de uma entrevista realizada com a coordenação de uma escola pública.

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

documentacao
  - der/
    - der.png

- dicionarios/
  - dicionario_rh.pdf
    
- bi_ia.md  
- regras_negocio.md  
- requisitos.md  

- sql
  - script.sql
---

## Documentação

  
- Acesse Dicionário de Dados: [Clique aqui](documentacao/dicionarios/dicionario_rh.pdf)

- Acesse o Requisitos: [Clique aqui](documentacao/requisitos.md)

- Acesse o Regras de negocio: [Clique aqui](documentacao/regras_negocio.md)
  
- Acesse o BI e IA: [Clique aqui](documentacao/documentacao/bi_ia.md)
  
- Acesse o diagrama DER: [Clique aqui](documentacao/der/der.png)

- [Visualizar Diagrama Online](https://dbdiagram.io/d/69e3f8ae0aa78f6bc108e841)

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
