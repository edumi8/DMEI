# README #

*TMDEI Dissertation  LaTeX Template*

This template explains the main formatting rules to apply to a Master Dissertation work for TMDEI, of the MSc in Computer Engineering of the Computer Engineering Department (DEI) of the School of Engineering (ISEP) of the Polytechnic of Porto (IPP).

**You can fork [this repository](https://github.com/MEI-ISEP/tmdei-dissertation-template) to make your own dissertation based on this template.**

Based on MastersDoctoralThesis version 1.2 by Vel (vel@latextemplates.com) and Johannes Böttcher, downloaded from [LaTeXTemplates](http://www.LaTeXTemplates.com) in November/2015. Adapted to TMDEI/ISEP style (Dec/2015) by Nuno Pereira and Paulo Baltarejo (DEI/ISEP).



### LaTeX Packages Needed

| Package       | Obs                                                                                                            |
|---------------|----------------------------------------------------------------------------------------------------------------|
| babel         | Required for automatically changing names of document elements to languages besides english                    |
| scrbase       | Required for handling language-dependent names of sections/document elements                                   |
| scrhack       | Loads fixes for various packages                                                                               |
| setspace      | Required for changing line spacing                                                                             |
| longtable     | Required for tables that span multiple pages (used in the symbols, abbreviations and physical constants pages) |
| siunitx       | Required for \SI commands                                                                                      |
| graphicx      | Required to include images                                                                                     |
| xcolor        | Required for extra color names                                                                                 |
| booktabs      | Required for better table rules                                                                                |
| inputenc      | Required for inputting portuguese characters                                                                   |
| fontenc       | Output font encoding for portuguese characters                                                                 |
| csquotes      | Required to generate language-dependent quotes in the bibliography                                             |
| cmbright      | Default font: CM Bright, lighter sans-serif variant of Computer Modern Sans Serif                              |
| algorithm     | Required for algorithms                                                                                        |
| algpseudocode | Part of algorithmicx package, required to customize the layout of algorithms                                   |
| listings      | Required for code listings                                                                                     |
| glossaries    | Required to define acronyms and make glossaries                                                                |
| caption       | Required for customising the captions                                                                          |
| biblatex      | Required for citations and bibliography                                                                        |
| tikz          | Required for creating graphics programmatically (can be removed if not used)                                   |
| pgfplots      | Required for drawing high--quality function plots (can be removed if not used)                                 |

## Who do I talk to? ##

* Nuno Pereira (nap@isep.ipp.pt) and 
* Paulo Baltarejo (pbs@isep.ipp.pt)




--------------------------------------
# Added by the Student
# Titulo: Observability for Containerized CI/CD Services: Improving Reliability
# Problema
Modern DevOps teams rely heavily on CI/CD platforms such as GitLab, Jenkins, Nexus, between others to manage the software delivery process. These services, often deployed in internal containerized environments, are critical to the daily functioning of development teams. Failures or misconfigurations can lead to downtime, reduced productivity, and delays in software delivery. 

Observability is the collection and correlation of metrics, logs, and traces and provides deeper insights into system behavior, allowing for faster detection of problems and more efficient troubleshooting. Implementing observability practices in these environments can therefore directly improve the reliability and availability of critical development infrastructure. 

## Problem Statement:

Most internal CI/CD environments rely only on basic monitoring to check service availability, but they lack integrated observability pipelines that provide a complete view of performance and failure modes. This makes it harder to detect and respond quickly to issues such as pipeline bottlenecks, misconfigurations, or resource exhaustion. 

## 1. Envolve questões técnicas amplas ou de difícil harmonização?
A criação de uma solução de observability neste contexto levanta vários desafios técnicos. Os serviços de CI/CD correm em containers Docker, num ambiente onde não existe acesso administrativo às máquinas, o que limita bastante a forma como é possível recolher métricas ou aceder a registos do sistema. Isso obriga a recorrer a containers adicionais ou sidecars para instrumentar os serviços, o que torna mais difícil recolher dados de baixo nível, como utilização de CPU, disco ou rede. Além disso, a infraestrutura é composta por três máquinas Linux e uma Windows, o que acrescenta complexidade devido às diferenças entre sistemas. É também necessário garantir que os dados recolhidos de cada máquina estão sincronizados e podem ser correlacionados. Como há um servidor crítico e outros três de teste/staging de aplicações que são desenvolvidas, a solução tem ainda de respeitar as diferenças entre as diversas aplicações nos diversos ambientes. Finalmente, como não existe atualmente nenhuma stack de observabilidade, é preciso desenhar tudo de raiz de forma distribuída e segura, o que torna a harmonização técnica um dos principais desafios do problema. 

## 2. Tem uma solução óbvia?
Cada ambiente tem as suas próprias restrições, desde a infraestrutura disponível até às ferramentas utilizadas e à forma como os serviços comunicam entre si. Neste caso em concreto, o facto de tudo correr em containers sem privilégios administrativos elimina várias opções comuns de observability e obriga a adaptar ferramentas que normalmente assumem outro tipo de acesso. Além disso, a integração entre métricas, logs e traces implica escolher tecnologias compatíveis e definir uma arquitetura que consiga equilibrar simplicidade, desempenho e isolamento. 

## 3. Aborda problemas não abrangidos pelas normas e códigos atuais?
As normas e guias atuais focam-se principalmente na monitorização tradicional de sistemas em produção, mas não abordam de forma específica a observabilidade aplicada a plataformas de CI/CD. Estas plataformas têm características diferentes, por exemplo pipelines dinâmicas, agentes efémeros e múltiplas dependências entre serviços que não são cobertas pelas práticas habituais de monitorização. Por isso, não existe ainda um modelo ou referência consolidada que oriente a implementação de observabilidade neste tipo de ambientes. Este trabalho procura precisamente explorar essa lacuna, adaptando e combinando boas práticas existentes para criar uma abordagem adequada a serviços de CI/CD containerizados. 


## 4. Envolve diversos grupos de partes interessadas (stakeholders)?
A equipa de DevOps precisa de visibilidade sobre as pipelines e automatizações para detetar e resolver falhas rapidamente. 

A equipa de infraestrutura/IT utiliza a observabilidade para acompanhar o desempenho e estabilidade das máquinas e serviços. 

As equipas de desenvolvimento beneficiam indiretamente de sistemas mais estáveis e resilientes, com menos falhas e interrupções em ferramentas como o GitLab, Jenkins ou Nexus. 

Os gestores tiram partido de métricas de qualidade e fiabilidade que permitem avaliar o impacto e a evolução do serviço ao longo do tempo. 

## Objetivos
- Design and deploy an observability framework for a container farm running critical CI/CD services. 

  

- Explore how observability data can improve system reliability and aid troubleshooting. 

  

Expected Contribution: 

A reference architecture and prototype showing how observability can be applied to internal CI/CD services to improve reliability, reduce downtime, and support system administration and DevOps practices. 

## Haverá interpretação do problema a resolver?
O trabalho vai permitir compreender melhor as causas da falta de fiabilidade nos serviços de CI/CD, nomeadamente a ausência de visibilidade e métricas integradas. A análise da situação atual ajudará a perceber de que forma a observabilidade pode reduzir falhas e tempos de paragem

## Haverá sistematização do conhecimento existente para a resolução do problema?
O trabalho vai incluir uma revisão da literatura e análise de referências técnicas sobre observabilidade em ambientes containerizados e plataformas de CI/CD. Esta etapa permitirá reunir o conhecimento existente e servir de base para a definição da arquitetura proposta. 

## Haverá avaliação de diferentes abordagens para a resolução do problema?
Serão estudadas e comparadas diferentes abordagens e ferramentas de observabilidade, de forma a identificar quais as mais adequadas ao contexto dos serviços de CI/CD e às restrições técnicas existentes. Esta avaliação vai apoiar a definição da solução final. 

## Haverá conceção de uma solução (produto, componente, processo)?
O trabalho vai propor e desenhar uma arquitetura de observabilidade adaptada aos serviços de CI/CD existentes 

## Haverá implementação de uma solução?
A solução será implementada num ambiente real com os serviços de CI/CD existentes (GitLab, Jenkins e Nexus). A implementação vai permitir validar o funcionamento da arquitetura proposta e medir o impacto na fiabilidade e disponibilidade dos sistemas. O objetivo é demonstrar, na prática, como a observabilidade pode reduzir falhas e melhorar a qualidade do serviço. 

## Haverá avaliação da solução desenhada/implementada?
A solução será avaliada com base em métricas de fiabilidade e desempenho, como a redução do tempo médio de deteção e recuperação de falhas (MTTD/MTTR) e a diminuição do número de interrupções nos serviços de CI/CD. Esta análise vai permitir confirmar se a arquitetura de observabilidade cumpre o objetivo de aumentar a qualidade e a resiliência dos sistemas. 


- The document must be written in English.
- The document must follow the structure defined in the TMDEI LaTeX Dissertation Template.