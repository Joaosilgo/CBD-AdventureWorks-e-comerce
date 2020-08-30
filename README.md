## CBD-AdventureWorks-e-comerce



[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/Joaosilgo/CBD-AdventureWorks-e-comerce)

O presente projeto relativo á Unidade Curricular de Complementos de Base de Dados (CBD), destina-se ao
desenho e á implementação e restruturação de uma Base de Dados de suporte a um e e-comerce de uma empresa de material de ciclismo, AdventureWorks.
Dado este tema, decidi assim replicar a base de dados de suporte e restruturar a mesma fazendo uma migração de dados.
Posto isto, com os meus conhecimentos adquiridos na unidade curricular de Base de Dados lecionada no ano
anterior e com mais alguns conhecimentos adquiridos em CBD no presente semestre, elaboramos a BD pretendida
através da linguagem T-SQL utilizando o IDE SQL SERVER Management Studio 2018.



### Transformation 
![Image]( https://raw.githubusercontent.com/Joaosilgo/CBD-AdventureWorks-e-comerce/master/Projeto_CBD/Anexos/MixData_Schema.JPG) 


To This 👇

![Image](https://raw.githubusercontent.com/Joaosilgo/CBD-AdventureWorks-e-comerce/master/Projeto_CBD/MER/MER.png)

For more details see [MER](https://raw.githubusercontent.com/Joaosilgo/CBD-AdventureWorks-e-comerce/master/Projeto_CBD/MER/MER.png).

### Backups

#### Política de Backups

*Descrição fundamentada da política de backups implementada*

O modelo de backup que irei adotar é o modelo de recuperação completa (Full Recovery). Este modelo usa
backups de logs para evitar a perda de dados no intervalo mais amplo de cenários com falhas e o backup e a
restauração do log de transações (backups de log) são necessários. Os grandes benefícios (vantagens) de usar
backups de logs é que eles permitem restaurar uma base de dados em qualquer ponto no tempo contido dentro de
um backup de log (recuperação pontual).

Irei implementar dois modelos de backups, um para a base de dados um para a base de dados principal
(Projeto_CBD) e outro para a base de dados da Sede.

O modelo de backup que decidi implementar para a base de dados principal é o seguinte:

Backup completo a cada 24 horas, Diferencial a cada 4 horas, Log de transações a cada 1 hora.
Este modelo é adequado para bases de dados cuja perda pode ser considerada catastrófica ou pelo menos sérios
obstáculos a visualização dos conteúdos. Uma vez que a base de dados pode hospedar aplicativos escrevendo várias
dezenas ou mesmo centenas de transações por hora, então esperar as 4 ou mais horas entre backups diferenciais
significaria uma perda potencial de um número significativo das transações do dia. Além disso, uma vez que não há
registo manual de transações, então tentar recriar as transações perdidas seria impossível - daí a necessidade de
backups de log de transação. Este modelo de backups é adequado para um site online de médio porte.

O plano de Backups para a BD principal é executado da seguinte forma:
- Completo, que será executado diariamente pelas 04:00, visto ser esta a hora de menor tráfego do site.
-  Diferencial, que será executado a cada 4 horas a partir das 05:00, para não interferir com o Backup total que é executado às 04:00 e cujo tempo de duração é indeterminado.
- Backup de Logs, que é executado todos os dias a cada 1h de hora a hora, para assim garantir o mínimo de perda das transações ocorridas.

Backup completo a cada 7 dias, Diferencial diariamente, Log de transações a cada 1 hora.

O plano de Backups para a BD da Sede é executado da seguinte forma:

-  Completo, de 7 em 7 Dias (Domingos às 04h00), visto ser esta a hora de menor tráfego no site.
-  Diferencial, diariamente (às 05h00) para não interferir com o Backup total que é executado às 04:00 e cujo tempo de duração é indeterminado.
-  Backup de Logs, que é executado todos os dias a cada 1h de hora a hora, para assim garantir o mínimo de perda das transações ocorridas.

A política de backups consiste em guardar a informação em discos utilizando o método de armazenamento
RAID 1+0, tendo em consideração que no nosso sistema irão existir uma grande quantidade de backups e este nível
oferece o melhor desempenho em backups de registos sendo bastante robusto.

O método Raid 1+0, apesar de ter um elevado custo monetário, é considerado um bom investimento devido à sua
fiabilidade e elevado desempenho.
Para aumentar a fiabilidade e segurança, e também para evitar esquecimentos da realização dos backups, criámos
Jobs para correr os maintenance plans que efetuam os respectivos backups.


### Restore

Na eventualidade de haver alguma falha no sistema, a recuperação da informação será efetuada do seguinte modo:
restore do último backup completo, de todos os diferenciais e por fim de todos os transaction log’s até ao momento
em que ocorreu a falha no sistema.

### Run

#### Descrição da Demonstração

*Encadeamento de procedimentos que permita o teste visualizar o correto funcionamento da base de dados face aos requisitos*

O primeiro passo aconselhado ao utilizador é correr o código referente aos scriptToRunAll.sql que se encontra na pasta do projeto ter atenção terá de verificar a diretoria onde se encontra os ficheiros a correr, e também verificar se o o SQL Management Studio se encontra em modo SQLCMD Mode.
Os ficheiros estão numerados para facilitar o entendimento. Terá a seguinte forma:



- Para correr o scrip verificar o diretório da pasta do Projeto onde se encontra os ficheiros do projeto

- Verificar também se o o SQL Management Studio se encontra em modo SQLCMD Mode

- Verificar a diretoria no disco dos ficheiros, tem de ser na diretoria Data do utilizador do respetivo SQL Management Studio.
