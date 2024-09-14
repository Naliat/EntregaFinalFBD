CREATE SCHEMA farmacia;
SET SCHEMA 'farmacia';

-- Tabela Remédio
CREATE TABLE remedio (
    id_remedio SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL
);

-- Tabela Genéricos
CREATE TABLE generico (
    id_generico SERIAL PRIMARY KEY,
    id_remedio INTEGER NOT NULL,
    CONSTRAINT fk_generico_remedio FOREIGN KEY (id_remedio) 
    REFERENCES remedio (id_remedio) ON DELETE CASCADE
);

-- Tabela Tarjas
CREATE TABLE tarja (
    id_tarja SERIAL PRIMARY KEY,
    id_remedio INTEGER NOT NULL,
    cores_tarjas VARCHAR(255) NOT NULL,
    CONSTRAINT fk_tarja_remedio FOREIGN KEY (id_remedio) 
    REFERENCES remedio (id_remedio) ON DELETE CASCADE
);

-- Tabela Marcas
CREATE TABLE marca (
    id_marca SERIAL PRIMARY KEY,
    id_remedio INTEGER NOT NULL,
    nome_marca VARCHAR(255) NOT NULL,
    CONSTRAINT fk_marca_remedio FOREIGN KEY (id_remedio) 
    REFERENCES remedio (id_remedio) ON DELETE CASCADE
);

-- Tabela Cliente
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(255) NOT NULL,
    cpf CHAR(11) CHECK (char_length(cpf) = 11) NOT NULL UNIQUE,
    endereco_rua VARCHAR(255),
    endereco_numero INTEGER,
    endereco_bairro VARCHAR(255),
    endereco_cidade VARCHAR(255),
    endereco_estado CHAR(2) -- Adicionada coluna para estado
);

-- Tabela Telefone
CREATE TABLE telefone (
    id_telefone SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    numero_telefone VARCHAR(20) UNIQUE,
    CONSTRAINT fk_telefone_cliente FOREIGN KEY (id_cliente) 
    REFERENCES cliente (id_cliente) ON DELETE CASCADE
);

-- Tabela Fornecedor
CREATE TABLE fornecedor (
    id_fornecedor SERIAL PRIMARY KEY,
    nome_empresa VARCHAR(255) UNIQUE NOT NULL,
    cnpj CHAR(14) NOT NULL UNIQUE CHECK (char_length(cnpj) = 14),
    email VARCHAR(255),
    endereco_rua VARCHAR(255),
    endereco_numero INTEGER,
    endereco_bairro VARCHAR(255),
    endereco_cidade VARCHAR(255),
    endereco_estado CHAR(2) NOT NULL
);

-- Tabela Pedidos de Clientes
CREATE TABLE pedido_cliente (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    data_pedido DATE NOT NULL,
    qtd_rem_solic INTEGER NOT NULL,
    cod_rastr VARCHAR(50) UNIQUE,
    status_pedido VARCHAR(50) NOT NULL CHECK (status_pedido IN ('EM PRODUÇÃO', 'A CAMINHO', 'ENTREGUE')),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) 
    REFERENCES cliente (id_cliente) ON DELETE CASCADE
);

-- Tabela Pedidos de Fornecedores
CREATE TABLE pedido_fornecedor (
    id_pedido_fornecedor SERIAL PRIMARY KEY,
    id_fornecedor INTEGER NOT NULL,
    data_solicitacao DATE NOT NULL,
    data_entrega_prevista DATE,
    status_solicitacao VARCHAR(50) NOT NULL,
    CONSTRAINT fk_pedido_fornecedor FOREIGN KEY (id_fornecedor) 
    REFERENCES fornecedor (id_fornecedor) ON DELETE CASCADE
);

-- Tabela Relacional entre Remédio e Pedido de Cliente
CREATE TABLE pedido_cliente_remedio (
    id_pedido INTEGER NOT NULL,
    id_remedio INTEGER NOT NULL,
    PRIMARY KEY (id_pedido, id_remedio),
    CONSTRAINT fk_pedido_cliente_remedio FOREIGN KEY (id_pedido) 
    REFERENCES pedido_cliente (id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_remedio_pedido_cliente FOREIGN KEY (id_remedio) 
    REFERENCES remedio (id_remedio) ON DELETE CASCADE
);

-- Tabela Relacional entre Remédio e Pedido de Fornecedor
CREATE TABLE pedido_fornecedor_remedio (
    id_pedido_fornecedor INTEGER NOT NULL,
    id_remedio INTEGER NOT NULL,
    PRIMARY KEY (id_pedido_fornecedor, id_remedio),
    CONSTRAINT fk_pedido_fornecedor_remedio FOREIGN KEY (id_pedido_fornecedor) 
    REFERENCES pedido_fornecedor (id_pedido_fornecedor) ON DELETE CASCADE,
    CONSTRAINT fk_remedio_pedido_fornecedor FOREIGN KEY (id_remedio) 
    REFERENCES remedio (id_remedio) ON DELETE CASCADE
);

-- Tabela Funcionário
CREATE TABLE funcionario (
    id_funcionario SERIAL PRIMARY KEY,
    nome_funcionario VARCHAR(255) NOT NULL,  -- Mudança no nome da coluna para ser mais claro
    cargo VARCHAR(255) NOT NULL,
    salario NUMERIC(10, 2) NOT NULL
);

-- Tabela Relacional entre Funcionário e Pedido de Cliente
CREATE TABLE realiza_cliente (
    id_funcionario INTEGER NOT NULL,
    id_pedido INTEGER NOT NULL,
    PRIMARY KEY (id_funcionario, id_pedido),
    CONSTRAINT fk_realiza_cliente_funcionario FOREIGN KEY (id_funcionario) 
    REFERENCES funcionario (id_funcionario) ON DELETE CASCADE,
    CONSTRAINT fk_realiza_cliente_pedido FOREIGN KEY (id_pedido) 
    REFERENCES pedido_cliente (id_pedido) ON DELETE CASCADE
);

-- Tabela Relacional entre Funcionário e Pedido de Fornecedor
CREATE TABLE realiza_fornecedor (
    id_funcionario INTEGER NOT NULL,
    id_pedido_fornecedor INTEGER NOT NULL,
    PRIMARY KEY (id_funcionario, id_pedido_fornecedor),
    CONSTRAINT fk_realiza_fornecedor_funcionario FOREIGN KEY (id_funcionario) 
    REFERENCES funcionario (id_funcionario) ON DELETE CASCADE,
    CONSTRAINT fk_realiza_fornecedor_pedido FOREIGN KEY (id_pedido_fornecedor) 
    REFERENCES pedido_fornecedor (id_pedido_fornecedor) ON DELETE CASCADE
);

-- Tabela Estoque
CREATE TABLE estoque (
    id_estoque SERIAL PRIMARY KEY,
    id_remedio INTEGER NOT NULL,
    data_entrega_stq DATE,
    qtd_stq INTEGER NOT NULL,
    data_vali_stq DATE NOT NULL,
    medida_frascos INTEGER,
    medida_caixas INTEGER,
    medida_cartelas INTEGER,
    medida_unidade INTEGER,
    CONSTRAINT fk_estoque_remedio FOREIGN KEY (id_remedio) 
    REFERENCES remedio (id_remedio) ON DELETE CASCADE
);

-- Tabela Histórico de Compra
CREATE TABLE historico_compra (
    id_historico SERIAL PRIMARY KEY,
    receitas TEXT,  -- Ajustado para permitir textos maiores
    ult_compra DATE, -- Mudança para tipo DATE, dado o contexto de datas
    id_cliente INTEGER NOT NULL,
    CONSTRAINT fk_historico_cliente FOREIGN KEY (id_cliente) 
    REFERENCES cliente (id_cliente) ON DELETE CASCADE
);

-- Inserir dados na tabela Remédio
INSERT INTO remedio (nome, descricao) VALUES 
('Paracetamol', 'Analgésico e antipirético utilizado para dor e febre.'),
('Amoxicilina', 'Antibiótico usado para tratar infecções bacterianas.'),
('Omeprazol', 'Inibidor da bomba de prótons para tratamento de úlceras e refluxo gástrico.'),
('Ibuprofeno', 'Anti-inflamatório não esteroide para dor e febre.'),
('Dipirona', 'Analgésico e antipirético para dor e febre.'),
('Azitromicina', 'Antibiótico para infecções respiratórias e de pele.'),
('Lorazepam', 'Ansiolítico para tratamento de ansiedade e insônia.'),
('Metformina', 'Antidiabético para controle da glicose no sangue.'),
('Cetoconazol', 'Antifúngico para infecções por fungos.'),
('Cloridrato de Tramadol', 'Analgésico para tratamento de dor intensa.');

-- Inserir dados na tabela Genéricos
INSERT INTO generico (id_remedio) VALUES 
(1),  -- Paracetamol
(2),  -- Amoxicilina
(3),  -- Omeprazol
(4),  -- Ibuprofeno
(5),  -- Dipirona
(6),  -- Azitromicina
(7),  -- Lorazepam
(8),  -- Metformina
(9),  -- Cetoconazol
(10); -- Cloridrato de Tramadol

-- Inserir dados na tabela Tarjas
INSERT INTO tarja (id_remedio, cores_tarjas) VALUES 
(1, 'Amarela'),  -- Paracetamol
(2, 'Vermelha'), -- Amoxicilina
(3, 'Azul'),     -- Omeprazol
(4, 'Verde'),    -- Ibuprofeno
(5, 'Preta'),    -- Dipirona
(6, 'Rosa'),     -- Azitromicina
(7, 'Laranja'),  -- Lorazepam
(8, 'Cinza'),    -- Metformina
(9, 'Branca'),   -- Cetoconazol
(10, 'Vinho');   -- Cloridrato de Tramadol

-- Inserir dados na tabela Marcas
INSERT INTO marca (id_remedio, nome_marca) VALUES 
(1, 'Marca A'),  -- Paracetamol
(2, 'Marca B'),  -- Amoxicilina
(3, 'Marca C'),  -- Omeprazol
(4, 'Marca D'),  -- Ibuprofeno
(5, 'Marca E'),  -- Dipirona
(6, 'Marca F'),  -- Azitromicina
(7, 'Marca G'),  -- Lorazepam
(8, 'Marca H'),  -- Metformina
(9, 'Marca I'),  -- Cetoconazol
(10, 'Marca J'); -- Cloridrato de Tramadol

-- Inserir dados na tabela Cliente
INSERT INTO cliente (nome_cliente, cpf, endereco_rua, endereco_numero, endereco_bairro, endereco_cidade, endereco_estado) VALUES 
('João Silva', '12345678901', 'Rua A', 123, 'Bairro X', 'Cidade Y', 'SP'),
('Maria Oliveira', '10987654321', 'Rua B', 456, 'Bairro Y', 'Cidade Z', 'RJ'),
('Pedro Santos', '32165498700', 'Rua C', 789, 'Bairro Z', 'Cidade W', 'MG'),
('Ana Lima', '65432198700', 'Rua D', 101, 'Bairro A', 'Cidade V', 'SP'),
('Lucia Costa', '98765432100', 'Rua E', 202, 'Bairro B', 'Cidade U', 'BA'),
('Carlos Almeida', '01234567890', 'Rua F', 303, 'Bairro C', 'Cidade T', 'PE'),
('Fernanda Silva', '19876543210', 'Rua G', 404, 'Bairro D', 'Cidade S', 'SC'),
('Roberto Oliveira', '12378945600', 'Rua H', 505, 'Bairro E', 'Cidade R', 'PR'),
('Juliana Pereira', '45612378900', 'Rua I', 606, 'Bairro F', 'Cidade Q', 'DF'),
('Ricardo Martins', '78945612300', 'Rua J', 707, 'Bairro G', 'Cidade P', 'GO');

-- Inserir dados na tabela Telefone
INSERT INTO telefone (id_cliente, numero_telefone) VALUES 
(1, '123456789'),  -- João Silva
(2, '987654321'),  -- Maria Oliveira
(3, '111222333'),  -- Pedro Santos
(4, '444555666'),  -- Ana Lima
(5, '777888999'),  -- Lucia Costa
(6, '000111222'),  -- Carlos Almeida
(7, '333444555'),  -- Fernanda Silva
(8, '666777888'),  -- Roberto Oliveira
(9, '999000111'),  -- Juliana Pereira
(10, '222333444'); -- Ricardo Martins

-- Inserir dados na tabela Fornecedor
INSERT INTO fornecedor (nome_empresa, cnpj, email, endereco_rua, endereco_numero, endereco_bairro, endereco_cidade, endereco_estado) VALUES 
('Farmácia Central', '12345678000195', 'contato@farmaciacentral.com.br', 'Rua C', 789, 'Bairro Z', 'Cidade W', 'MG'),
('Laboratório Saúde', '09876543000187', 'suporte@laboratoriosaude.com.br', 'Rua D', 101, 'Bairro A', 'Cidade V', 'SP'),
('Distribuidora Farma', '23456789000198', 'vendas@distribuidorafarma.com.br', 'Rua E', 202, 'Bairro B', 'Cidade U', 'BA'),
('Medicamentos & Cia', '34567890000101', 'info@medicamentoscia.com.br', 'Rua F', 303, 'Bairro C', 'Cidade T', 'PE'),
('Farmácia Popular', '45678901000112', 'contato@farmaciapopular.com.br', 'Rua G', 404, 'Bairro D', 'Cidade S', 'SC'),
('Farma Mais', '56789012000123', 'atendimento@farmamais.com.br', 'Rua H', 505, 'Bairro E', 'Cidade R', 'PR'),
('Laboratório Vida', '67890123000134', 'suporte@laboratoriodvida.com.br', 'Rua I', 606, 'Bairro F', 'Cidade Q', 'DF'),
('Saúde em Casa', '78901234000145', 'contato@saudeemcasa.com.br', 'Rua J', 707, 'Bairro G', 'Cidade P', 'GO'),
('Distribuidora de Medicamentos', '89012345000156', 'vendas@distribuidoramedicamentos.com.br', 'Rua K', 808, 'Bairro H', 'Cidade N', 'MS'),
('Medicamentos Brasil', '90123456000167', 'info@medicamentosbrasil.com.br', 'Rua L', 909, 'Bairro I', 'Cidade M', 'TO');

-- Inserir dados na tabela Pedidos de Clientes
INSERT INTO pedido_cliente (id_cliente, data_pedido, qtd_rem_solic, cod_rastr, status_pedido) VALUES 
(1, '2024-09-01', 2, 'COD1234', 'EM PRODUÇÃO'),
(2, '2024-09-05', 1, 'COD5678', 'A CAMINHO'),
(3, '2024-09-07', 3, 'COD9101', 'ENTREGUE'),
(4, '2024-09-10', 1, 'COD1121', 'EM PRODUÇÃO'),
(5, '2024-09-12', 2, 'COD3141', 'A CAMINHO'),
(6, '2024-09-15', 1, 'COD5161', 'ENTREGUE'),
(7, '2024-09-17', 4, 'COD7181', 'EM PRODUÇÃO'),
(8, '2024-09-20', 2, 'COD9202', 'A CAMINHO'),
(9, '2024-09-22', 3, 'COD2232', 'ENTREGUE'),
(10, '2024-09-25', 1, 'COD3243', 'EM PRODUÇÃO');

-- Inserir dados na tabela Pedidos de Fornecedores
INSERT INTO pedido_fornecedor (id_fornecedor, data_solicitacao, data_entrega_prevista, status_solicitacao) VALUES 
(1, '2024-09-01', '2024-09-10', 'PENDENTE'),
(2, '2024-09-03', '2024-09-12', 'PENDENTE'),
(3, '2024-09-05', '2024-09-15', 'PENDENTE'),
(4, '2024-09-07', '2024-09-17', 'PENDENTE'),
(5, '2024-09-10', '2024-09-20', 'PENDENTE'),
(6, '2024-09-12', '2024-09-22', 'PENDENTE'),
(7, '2024-09-15', '2024-09-25', 'PENDENTE'),
(8, '2024-09-17', '2024-09-27', 'PENDENTE'),
(9, '2024-09-20', '2024-09-30', 'PENDENTE'),
(10, '2024-09-22', '2024-10-02', 'PENDENTE');

-- Inserir dados na tabela Relacional entre Remédio e Pedido de Cliente
INSERT INTO pedido_cliente_remedio (id_pedido, id_remedio) VALUES 
(1, 1),  -- Paracetamol no Pedido 1
(1, 2),  -- Amoxicilina no Pedido 1
(2, 3),  -- Omeprazol no Pedido 2
(3, 4),  -- Ibuprofeno no Pedido 3
(3, 5),  -- Dipirona no Pedido 3
(4, 6),  -- Azitromicina no Pedido 4
(5, 7),  -- Lorazepam no Pedido 5
(6, 8),  -- Metformina no Pedido 6
(7, 9),  -- Cetoconazol no Pedido 7
(8, 10); -- Cloridrato de Tramadol no Pedido 8

-- Inserir dados na tabela Relacional entre Remédio e Pedido de Fornecedor
INSERT INTO pedido_fornecedor_remedio (id_pedido_fornecedor, id_remedio) VALUES 
(1, 1),  -- Paracetamol no Pedido de Fornecedor 1
(1, 2),  -- Amoxicilina no Pedido de Fornecedor 1
(2, 3),  -- Omeprazol no Pedido de Fornecedor 2
(3, 4),  -- Ibuprofeno no Pedido de Fornecedor 3
(4, 5),  -- Dipirona no Pedido de Fornecedor 4
(5, 6),  -- Azitromicina no Pedido de Fornecedor 5
(6, 7),  -- Lorazepam no Pedido de Fornecedor 6
(7, 8),  -- Metformina no Pedido de Fornecedor 7
(8, 9),  -- Cetoconazol no Pedido de Fornecedor 8
(9, 10); -- Cloridrato de Tramadol no Pedido de Fornecedor 9

-- Inserir dados na tabela Funcionário
INSERT INTO funcionario (nome_funcionario, cargo, salario) VALUES 
('Carlos Mendes', 'Farmacêutico', 5000.00),
('Ana Souza', 'Atendente', 3000.00),
('Luiz Costa', 'Gerente', 7000.00),
('Juliana Martins', 'Auxiliar Administrativo', 3500.00),
('Ricardo Almeida', 'Farmacêutico', 4800.00),
('Patrícia Lima', 'Atendente', 3200.00),
('Eduardo Silva', 'Supervisor', 6000.00),
('Mariana Oliveira', 'Farmacêutico', 4900.00),
('Fernanda Santos', 'Auxiliar de Farmácia', 3300.00),
('Gustavo Pereira', 'Atendente', 3100.00);

-- Inserir dados na tabela Relacional entre Funcionário e Pedido de Cliente
INSERT INTO realiza_cliente (id_funcionario, id_pedido) VALUES 
(1, 1),  -- Carlos Mendes realizou o Pedido 1
(2, 2),  -- Ana Souza realizou o Pedido 2
(3, 3),  -- Luiz Costa realizou o Pedido 3
(4, 4),  -- Juliana Martins realizou o Pedido 4
(5, 5),  -- Ricardo Almeida realizou o Pedido 5
(6, 6),  -- Patrícia Lima realizou o Pedido 6
(7, 7),  -- Eduardo Silva realizou o Pedido 7
(8, 8),  -- Mariana Oliveira realizou o Pedido 8
(9, 9),  -- Fernanda Santos realizou o Pedido 9
(10, 10); -- Gustavo Pereira realizou o Pedido 10

-- Inserir dados na tabela Relacional entre Funcionário e Pedido de Fornecedor
INSERT INTO realiza_fornecedor (id_funcionario, id_pedido_fornecedor) VALUES 
(1, 1),  -- Carlos Mendes realizou o Pedido de Fornecedor 1
(2, 2),  -- Ana Souza realizou o Pedido de Fornecedor 2
(3, 3),  -- Luiz Costa realizou o Pedido de Fornecedor 3
(4, 4),  -- Juliana Martins realizou o Pedido de Fornecedor 4
(5, 5),  -- Ricardo Almeida realizou o Pedido de Fornecedor 5
(6, 6),  -- Patrícia Lima realizou o Pedido de Fornecedor 6
(7, 7),  -- Eduardo Silva realizou o Pedido de Fornecedor 7
(8, 8),  -- Mariana Oliveira realizou o Pedido de Fornecedor 8
(9, 9),  -- Fernanda Santos realizou o Pedido de Fornecedor 9
(10, 10); -- Gustavo Pereira realizou o Pedido de Fornecedor 10

-- Inserir dados na tabela Estoque
INSERT INTO estoque (id_remedio, data_entrega_stq, qtd_stq, data_vali_stq, medida_frascos, medida_caixas, medida_cartelas, medida_unidade) VALUES 
(1, '2024-09-01', 100, '2025-09-01', 10, 5, 20, 100),  -- Paracetamol
(2, '2024-09-02', 200, '2025-09-02', 20, 10, 30, 200),  -- Amoxicilina
(3, '2024-09-03', 150, '2025-09-03', 15, 8, 25, 150),  -- Omeprazol
(4, '2024-09-04', 180, '2025-09-04', 18, 9, 28, 180),  -- Ibuprofeno
(5, '2024-09-05', 160, '2025-09-05', 16, 7, 24, 160),  -- Dipirona
(6, '2024-09-06', 140, '2025-09-06', 14, 6, 22, 140),  -- Azitromicina
(7, '2024-09-07', 170, '2025-09-07', 17, 8, 26, 170),  -- Lorazepam
(8, '2024-09-08', 190, '2025-09-08', 19, 10, 29, 190),  -- Metformina
(9, '2024-09-09', 120, '2025-09-09', 12, 5, 21, 120),  -- Cetoconazol
(10, '2024-09-10', 130, '2025-09-10', 13, 6, 23, 130); -- Cloridrato de Tramadol

-- Inserir dados na tabela Histórico de Compra
INSERT INTO historico_compra (receitas, ult_compra, id_cliente) VALUES 
('Receita de Paracetamol', '2024-08-20', 1),  -- João Silva
('Receita de Amoxicilina', '2024-08-22', 2),  -- Maria Oliveira
('Receita de Omeprazol', '2024-08-24', 3),  -- Pedro Santos
('Receita de Ibuprofeno', '2024-08-26', 4),  -- Ana Lima
('Receita de Dipirona', '2024-08-28', 5),  -- Lucia Costa
('Receita de Azitromicina', '2024-08-30', 6),  -- Carlos Almeida
('Receita de Lorazepam', '2024-09-01', 7),  -- Fernanda Silva
('Receita de Metformina', '2024-09-03', 8),  -- Roberto Oliveira
('Receita de Cetoconazol', '2024-09-05', 9),  -- Juliana Pereira
('Receita de Cloridrato de Tramadol', '2024-09-07', 10); -- Ricardo Martins

