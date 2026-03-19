### 1. Em qual camada foi implementado o cache e por quê?
O cache foi implementado na camada de Data (ProductCacheDatasource), pois Data é a camada a responsável pelo acesso e persistência de dados.

### 2. Por que o ViewModel não realiza chamadas HTTP diretamente?
O ViewModel tem como resposabilidade gerenciar estado da UI, não acessar dados, realizar camadas HTTP violaria o princípio da responsabilidade única. Isso favorece testabilidade e gera desacoplamento, uma vez que o ViewModel se utiliza da abstração ProductRepository, não de implementações concretas. 

### 3. O que aconteceria se a interface acessasse diretamente o datasource?
Seria uma violação da organização arquitetural em camadas e qualquer alteração na API quebraria a UI.

### 4. Como essa arquitetura facilitaria a substituição da API por um banco de dados local?
Se for necessário trocar a API por um banco de dados local ViewModel e UI não mudam, apenas altera-se a implementação do Datasource, cria-se um ProductLocalDatasource que implementa a mesma interface e o Repository pra usar esse Datasource local.

## Atividades 5, 6 e 7: 
A lista de produtos permite favoritar o produto e conta quantos são os favoritos. Adiconada tela inicial e tela com detalhamento do produto:


<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/9b1cf4b3-0dd1-4e25-9620-848014a0d3b0" />
<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/26c86a0a-be7f-45d5-b093-b7eadd71cc73" />
<img width="300" height="600" alt="image" src="https://github.com/user-attachments/assets/ce222fed-9ae9-4d2b-8924-8f8f960be7aa" />
