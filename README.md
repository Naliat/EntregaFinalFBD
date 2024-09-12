# Gerenciamento de Clientes

Este projeto utiliza `Panel`, `Pandas` e `SQLAlchemy` para construir uma interface interativa de gerenciamento de clientes com um banco de dados PostgreSQL.

## Requisitos

Para rodar este projeto localmente, você precisará das seguintes ferramentas instaladas:

- Python 3.7+
- PostgreSQL
- Biblioteca `psycopg2` para conectar ao banco de dados PostgreSQL

## Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/usuario/repo.git
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

## Contribuição

Contribuições são bem-vindas! Por favor, envie um pull request ou abra uma issue no repositório.

## Licença

Este projeto está sob a licença MIT.
```
