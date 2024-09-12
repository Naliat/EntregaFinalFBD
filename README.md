# Gerenciamento de Clientes

## Tabela Cliente

Este projeto utiliza `Panel`, `Pandas` e `SQLAlchemy` para construir uma interface interativa de gerenciamento de clientes com um banco de dados PostgreSQL.

## Requisitos

Para rodar este projeto localmente, você precisará das seguintes ferramentas instaladas:

- Python 3.7+
- PostgreSQL
- Biblioteca `psycopg2` para conectar ao banco de dados PostgreSQL

## Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/Naliat/EntregaFinalFBD/
   ```

2. Crie um ambiente virtual:
   ```bash
   python -m venv venv
   ```

3. Ative o ambiente virtual:
   - No Windows:
     ```bash
     venv\Scripts\activate
     ```
   - No macOS/Linux:
     ```bash
     source venv/bin/activate
     ```

4. Instale as dependências necessárias:
   ```bash
   pip install -r requirements.txt
   ```

### Dependências

As seguintes bibliotecas Python são necessárias para rodar o projeto:

- `panel`
- `pandas`
- `sqlalchemy`
- `psycopg2`

Você pode instalar essas dependências usando o comando:
```bash
pip install panel pandas sqlalchemy psycopg2
```

## Configuração do Banco de Dados

Certifique-se de ter um banco de dados PostgreSQL rodando localmente ou remotamente e crie uma tabela chamada `cliente` dentro de um esquema chamado `farmacia`.

Estrutura básica da tabela `cliente`:
```sql
CREATE SCHEMA farmacia;

CREATE TABLE farmacia.cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    endereco_rua VARCHAR(150),
    endereco_numero INT,
    endereco_bairro VARCHAR(100),
    endereco_cidade VARCHAR(100)
);
```

Atualize o arquivo de configuração do banco de dados com suas credenciais em `db_config` no código.

## Executando o Projeto

Para iniciar a interface de gerenciamento, execute o seguinte comando no terminal:
```bash
python nome_do_arquivo.py
```

Isso lançará um servidor local na URL `http://localhost:60040`, onde você poderá acessar a interface gráfica para gerenciar clientes.

## Funcionalidades

A interface possui as seguintes funcionalidades:

1. **Filtrar clientes**: Filtrar por ID ou nome.
2. **Adicionar cliente**: Adicionar um novo cliente ao banco de dados.
3. **Atualizar cliente**: Atualizar os dados de um cliente existente.
4. **Excluir cliente**: Remover um cliente do banco de dados.
5. **Exibir clientes**: Mostrar todos os clientes cadastrados.


## Tabela Rémedio

Aqui está a explicação do código sem a parte sobre a configuração do ambiente:


# Gerenciamento de Remédios

Este código cria uma interface interativa para o gerenciamento de remédios utilizando `Panel`, `Pandas`, e `SQLAlchemy` para se conectar a um banco de dados PostgreSQL.

## Configuração do Banco de Dados

Certifique-se de que o PostgreSQL está rodando e crie o esquema e a tabela de `remedio` no banco de dados `Gerenciamento_Remedios`:

```sql
CREATE SCHEMA farmacia;

CREATE TABLE farmacia.remedio (
    id_remedio SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);
```

Atualize o arquivo de configuração do banco de dados no código para refletir suas credenciais de conexão:

```python
db_config = {
    'user': 'postgres',
    'password': '1412',
    'host': 'localhost',
    'port': '5432',
    'database': 'Gerenciamento_Remedios'
}
```

## Funções do Código

O código fornece as seguintes funções para interagir com o banco de dados:

### `read_remedios`

- **Descrição**: Função para ler dados da tabela `remedio`. Aceita dois parâmetros opcionais:
  - `id_remedio`: Filtra a busca pelo ID do remédio.
  - `nome`: Filtra a busca pelo nome do remédio (usando `ILIKE` para busca parcial).
- **Retorno**: Um DataFrame com os resultados da consulta.

### `create_remedio`

- **Descrição**: Insere um novo remédio na tabela `remedio`.
- **Parâmetros**:
  - `nome`: Nome do remédio.
  - `descricao`: Descrição do remédio.
- **Retorno**: Mensagem indicando sucesso ou erro.

### `update_remedio`

- **Descrição**: Atualiza os dados de um remédio existente.
- **Parâmetros**:
  - `id_remedio`: O ID do remédio a ser atualizado.
  - `nome`: Novo nome do remédio.
  - `descricao`: Nova descrição do remédio.
- **Retorno**: Mensagem indicando sucesso ou erro.

### `delete_remedio`

- **Descrição**: Remove um remédio da tabela.
- **Parâmetro**: 
  - `id_remedio`: O ID do remédio a ser excluído.
- **Retorno**: Mensagem indicando sucesso ou erro.

## Interface Gráfica com `Panel`

### Widgets Interativos

O código utiliza widgets do `Panel` para criar uma interface gráfica interativa, onde é possível realizar as seguintes ações:

- **Filtrar Remédios**: Filtros por ID ou nome para buscar remédios na tabela.
- **Adicionar Remédio**: Campos para inserir o nome e a descrição de um novo remédio.
- **Atualizar Remédio**: Campos para atualizar o nome e a descrição de um remédio existente.
- **Excluir Remédio**: Campo para inserir o ID de um remédio e excluí-lo.
- **Exibir Tabela**: Exibe os dados da tabela `remedio` em um widget de DataFrame.

### Funções de Callback

Os botões interativos possuem funções de callback associadas:

- **Filtrar Remédios**: Quando o botão de filtro é clicado, a função `on_filter_button_click` é chamada, que atualiza a tabela com base nos filtros aplicados.
- **Adicionar Remédio**: O botão "Adicionar Remédio" chama a função `on_create_button_click`, que adiciona um novo remédio ao banco de dados.
- **Atualizar Remédio**: O botão "Atualizar Remédio" chama a função `on_update_button_click`, que atualiza os dados de um remédio existente.
- **Excluir Remédio**: O botão "Excluir Remédio" chama a função `on_delete_button_click`, que exclui um remédio da tabela.

### Layout

O layout da interface é organizado em colunas e linhas utilizando o `Panel`:

- **Filtros**: Inputs para filtrar remédios por ID ou nome.
- **Adicionar Remédio**: Inputs para adicionar um novo remédio.
- **Atualizar Remédio**: Inputs para atualizar nome e descrição de um remédio.
- **Excluir Remédio**: Input para inserir o ID do remédio a ser excluído.
- **Tabela**: Tabela que exibe os dados da tabela `remedio`.
- **Output Pane**: Área para exibir mensagens de sucesso ou erro após cada ação.

### Exemplo de Layout

```python
layout = pn.Column(
    pn.pane.Markdown("# Gerenciamento de Remédios", sizing_mode='stretch_width'),
    pn.Row(
        pn.Column(id_filter_input, nome_filter_input, filter_button),
        sizing_mode='stretch_width'
    ),
    pn.Row(
        pn.Column(nome_input, descricao_input, create_button),
        sizing_mode='stretch_width'
    ),
    pn.Row(
        pn.Column(id_input, update_nome_input, update_descricao_input, update_button),
        sizing_mode='stretch_width'
    ),
    pn.Row(
        pn.Column(delete_id_input, delete_button),
        sizing_mode='stretch_width'
    ),
    table,
    output_pane,
    sizing_mode='stretch_width'
)
layout.show()
```

Isso lança a interface no navegador localmente, onde as operações de CRUD podem ser realizadas.

## Conclusão

Este código fornece uma solução completa para o gerenciamento de remédios com uma interface gráfica interativa, permitindo criar, ler, atualizar e excluir registros no banco de dados PostgreSQL de forma intuitiva.


Este conteúdo pode ser incluído diretamente na sua documentação, explicando o funcionamento do código.

## Contribuição

Contribuições são bem-vindas! Por favor, envie um pull request ou abra uma issue no repositório.

## Licença

Este projeto está sob a licença MIT.

