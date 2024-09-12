CREATE SCHEMA farmacia;  
SET SCHEMA 'farmacia';  

-- Tabela Remédio  
CREATE TABLE remedio (  
    id_remedio SERIAL PRIMARY KEY,  
    nome VARCHAR(255) NOT NULL,  
    descricao VARCHAR(255) NOT NULL  
);  

-- Tabela Genéricos  
CREATE TABLE generico (  
    id_generico SERIAL PRIMARY KEY,  
    id_remedio INTEGER NOT NULL,  
    FOREIGN KEY (id_remedio) REFERENCES remedio (id_remedio) ON DELETE CASCADE  
);  

-- Tabela Tarjas  
CREATE TABLE tarja (  
    id_tarja SERIAL PRIMARY KEY,  
    id_remedio INTEGER NOT NULL,  
    cores_tarjas VARCHAR(255) NOT NULL,  
    FOREIGN KEY (id_remedio) REFERENCES remedio (id_remedio) ON DELETE CASCADE  
);  

-- Tabela Marcas  
CREATE TABLE marca (  
    id_marca SERIAL PRIMARY KEY,  
    id_remedio INTEGER NOT NULL,  
    FOREIGN KEY (id_remedio) REFERENCES remedio (id_remedio) ON DELETE CASCADE  
);  

-- Tabela Cliente  
CREATE TABLE cliente (  
    id_cliente SERIAL PRIMARY KEY,  
    nome_cliente VARCHAR(255) NOT NULL,  
    cpf CHAR(11) CHECK (char_length(cpf) = 11) NOT NULL UNIQUE,  
    endereco_rua VARCHAR(255),  
    endereco_numero INTEGER,  
    endereco_bairro VARCHAR(255),  
    endereco_cidade VARCHAR(255)  
);  

-- Tabela Telefone  
CREATE TABLE telefone (  
    id_telefone SERIAL PRIMARY KEY,  
    id_cliente INTEGER NOT NULL,  
    numero_telefone VARCHAR(20) UNIQUE,  
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente) ON DELETE CASCADE  
);  

-- Tabela Fornecedor  
CREATE TABLE fornecedor (  
    id_fornecedor SERIAL PRIMARY KEY,  
    nome_empresa VARCHAR(255) UNIQUE NOT NULL,  
    cnpj VARCHAR(14) UNIQUE NOT NULL,  
    email VARCHAR(255),  
    endereco_rua VARCHAR(255),  
    endereco_numero INTEGER,  
    endereco_bairro VARCHAR(255),  
    endereco_cidade VARCHAR(255),  
    endereco_estado CHAR(2)  
);  

-- Tabela Pedidos de Clientes  
CREATE TABLE pedido_cliente (  
    id_pedido SERIAL PRIMARY KEY,  
    id_cliente INTEGER NOT NULL,  
    data_pedido DATE NOT NULL,  
    qtd_rem_solic INTEGER NOT NULL,  
    cod_rastr VARCHAR(50) UNIQUE,  
    status_pedido VARCHAR(50) NOT NULL CHECK (status_pedido IN ('EM PRODUÇÃO', 'A CAMINHO', 'ENTREGUE')),  
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente) ON DELETE CASCADE  
);  

-- Tabela Pedidos de Fornecedores  
CREATE TABLE pedido_fornecedor (  
    id_pedido_fornecedor SERIAL PRIMARY KEY,  
    id_fornecedor INTEGER NOT NULL,  
    data_solicitacao DATE NOT NULL,  
    data_entrega_prevista DATE,  
    status_solicitacao VARCHAR(50) NOT NULL,  
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor (id_fornecedor) ON DELETE CASCADE  
);  

-- Tabela Relacional entre Remédio e Pedido de Cliente  
CREATE TABLE pedido_cliente_remedio (  
    id_pedido INTEGER NOT NULL,  
    id_remedio INTEGER NOT NULL,  
    PRIMARY KEY (id_pedido, id_remedio),  
    FOREIGN KEY (id_pedido) REFERENCES pedido_cliente (id_pedido) ON DELETE CASCADE,  
    FOREIGN KEY (id_remedio) REFERENCES remedio (id_remedio) ON DELETE CASCADE  
);  

-- Tabela Relacional entre Remédio e Pedido de Fornecedor  
CREATE TABLE pedido_fornecedor_remedio (  
    id_pedido_fornecedor INTEGER NOT NULL,  
    id_remedio INTEGER NOT NULL,  
    PRIMARY KEY (id_pedido_fornecedor, id_remedio),  
    FOREIGN KEY (id_pedido_fornecedor) REFERENCES pedido_fornecedor (id_pedido_fornecedor) ON DELETE CASCADE,  
    FOREIGN KEY (id_remedio) REFERENCES remedio (id_remedio) ON DELETE CASCADE  
);  

-- Tabela Funcionário  
CREATE TABLE funcionario (  
    id_funcionario SERIAL PRIMARY KEY,  
    nome VARCHAR(255) NOT NULL,  
    cargo VARCHAR(255) NOT NULL,  
    salario NUMERIC(10, 2) NOT NULL  
);  

-- Tabela Relacional entre Funcionário e Pedido de Cliente  
CREATE TABLE realiza_cliente (  
    id_funcionario INTEGER NOT NULL,  
    id_pedido INTEGER NOT NULL,  
    PRIMARY KEY (id_funcionario, id_pedido),  
    FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario) ON DELETE CASCADE,  
    FOREIGN KEY (id_pedido) REFERENCES pedido_cliente (id_pedido) ON DELETE CASCADE  
);  

-- Tabela Relacional entre Funcionário e Pedido de Fornecedor  
CREATE TABLE realiza_fornecedor (  
    id_funcionario INTEGER NOT NULL,  
    id_pedido_fornecedor INTEGER NOT NULL,  
    PRIMARY KEY (id_funcionario, id_pedido_fornecedor),  
    FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario) ON DELETE CASCADE,  
    FOREIGN KEY (id_pedido_fornecedor) REFERENCES pedido_fornecedor (id_pedido_fornecedor) ON DELETE CASCADE  
);  

-- Tabela Estoque  
CREATE TABLE estoque (  
    id_estoque SERIAL PRIMARY KEY,  
    data_entrega_stq DATE,  
    qtd_stq INTEGER NOT NULL,  
    data_vali_stq DATE NOT NULL,  
    medida_frascos INTEGER,  
    medida_caixas INTEGER,  
    medida_cartelas INTEGER,  
    medida_unidade INTEGER  
);  

-- Tabela Relacional entre Estoque e Remédio  
CREATE TABLE possui (  
    id_estoque INTEGER NOT NULL,  
    id_remedio INTEGER NOT NULL,  
    PRIMARY KEY (id_estoque, id_remedio),  
    FOREIGN KEY (id_estoque) REFERENCES estoque (id_estoque) ON DELETE CASCADE,  
    FOREIGN KEY (id_remedio) REFERENCES remedio (id_remedio) ON DELETE CASCADE  
);  

-- Tabela Histórico de Compra  
CREATE TABLE historico_compra (  
    id_historico SERIAL PRIMARY KEY,  
    receitas VARCHAR(255),  
    ult_compra VARCHAR(255),  
    id_cliente INTEGER NOT NULL,  
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente) ON DELETE CASCADE  
);  

-- Tabela Relacional entre Histórico de Compra e Remédio  
CREATE TABLE faz_parte (  
    id_historico INTEGER NOT NULL,  
    id_remedio INTEGER NOT NULL,  
    PRIMARY KEY (id_historico, id_remedio),  
    FOREIGN KEY (id_historico) REFERENCES historico_compra (id_historico) ON DELETE CASCADE,  
    FOREIGN KEY (id_remedio) REFERENCES remedio (id_remedio) ON DELETE CASCADE  
);



-- Inserindo dados na tabela Remédio  
INSERT INTO remedio (nome, descricao) VALUES  
('Paracetamol', 'Analgésico e antipirético'),  
('Ibuprofeno', 'Anti-inflamatório não esteroidal'),  
('Amoxicilina', 'Antibiótico de amplo espectro'),  
('Metformina', 'Antidiabético oral'),  
('Losartana', 'Antihipertensivo'),  
('Omeprazol', 'Inibidor da bomba de prótons'),  
('Simvastatina', 'Redutor de colesterol'),  
('Atenolol', 'Betabloqueador'),  
('Dipirona', 'Analgésico e antipirético'),  
('Ranitidina', 'Antagonista H2');  

-- Inserindo dados na tabela Cliente  
INSERT INTO cliente (nome_cliente, cpf, endereco_rua, endereco_numero, endereco_bairro, endereco_cidade) VALUES  
('João Silva', '12345678901', 'Rua A', 100, 'Centro', 'São Paulo'),  
('Maria Oliveira', '23456789012', 'Rua B', 200, 'Jardim', 'Rio de Janeiro'),  
('Carlos Pereira', '34567890123', 'Rua C', 300, 'Vila Nova', 'Belo Horizonte'),  
('Ana Costa', '45678901234', 'Rua D', 400, 'Centro', 'Curitiba'),  
('Fernanda Lima', '56789012345', 'Rua E', 500, 'Bairro Alto', 'Porto Alegre'),  
('Roberto Santos', '67890123456', 'Rua F', 600, 'Zona Sul', 'Salvador'),  
('Patrícia Almeida', '78901234567', 'Rua G', 700, 'Centro', 'Fortaleza'),  
('Lucas Martins', '89012345678', 'Rua H', 800, 'Jardim', 'Recife'),  
('Juliana Ferreira', '90123456789', 'Rua I', 900, 'Vila Nova', 'Manaus'),  
('Ricardo Gomes', '01234567890', 'Rua J', 1000, 'Centro', 'Brasília');  

-- Inserindo dados na tabela Fornecedor  
INSERT INTO fornecedor (nome_empresa, cnpj, email, endereco_rua, endereco_numero, endereco_bairro, endereco_cidade, endereco_estado) VALUES  
('Farmácia A', '12345678000195', 'contato@farmaciaa.com.br', 'Av. 1', 100, 'Centro', 'São Paulo', 'SP'),  
('Distribuidora B', '23456789000196', 'contato@distribuidorab.com.br', 'Av. 2', 200, 'Jardim', 'Rio de Janeiro', 'RJ'),  
('Laboratório C', '34567890000197', 'contato@laboratorioc.com.br', 'Av. 3', 300, 'Vila Nova', 'Belo Horizonte', 'MG'),  
('Farmácia D', '45678901000198', 'contato@farmaciad.com.br', 'Av. 4', 400, 'Centro', 'Curitiba', 'PR'),  
('Distribuidora E', '56789012000199', 'contato@distribuidorae.com.br', 'Av. 5', 500, 'Bairro Alto', 'Porto Alegre', 'RS'),  
('Laboratório F', '67890123000200', 'contato@laboratoriof.com.br', 'Av. 6', 600, 'Zona Sul', 'Salvador', 'BA'),  
('Farmácia G', '78901234000201', 'contato@farmaciag.com.br', 'Av. 7', 700, 'Centro', 'Fortaleza', 'CE'),  
('Distribuidora H', '89012345000202', 'contato@distribuidorah.com.br', 'Av. 8', 800, 'Jardim', 'Recife', 'PE'),  
('Laboratório I', '90123456000203', 'contato@laboratorioi.com.br', 'Av. 9', 900, 'Vila Nova', 'Manaus', 'AM'),  
('Farmácia J', '01234567000204', 'contato@farmaciaj.com.br', 'Av. 10', 1000, 'Centro', 'Brasília', 'DF');  

-- Inserindo dados na tabela Telefone  
INSERT INTO telefone (id_cliente, numero_telefone) VALUES  
(1, '11987654321'),  
(2, '21987654321'),  
(3, '31987654321'),  
(4, '41987654321'),  
(5, '51987654321'),  
(6, '61987654321'),  
(7, '71987654321'),  
(8, '81987654321'),  
(9, '91987654321'),  
(10, '01987654321');  

-- Inserindo dados na tabela Pedidos de Clientes  
INSERT INTO pedido_cliente (id_cliente, data_pedido, qtd_rem_solic, cod_rastr, status_pedido) VALUES  
(1, '2023-01-10', 2, 'R123456', 'EM PRODUÇÃO'),  
(2, '2023-01-11', 1, 'R123457', 'A CAMINHO'),  
(3, '2023-01-12', 3, 'R123458', 'ENTREGUE'),  
(4, '2023-01-13', 1, 'R123459', 'EM PRODUÇÃO'),  
(5, '2023-01-14', 2, 'R123460', 'A CAMINHO'),  
(6, '2023-01-15', 1, 'R123461', 'ENTREGUE'),  
(7, '2023-01-16', 4, 'R123462', 'EM PRODUÇÃO'),  
(8, '2023-01-17', 2, 'R123463', 'A CAMINHO'),  
(9, '2023-01-18', 1, 'R123464', 'ENTREGUE'),  
(10, '2023-01-19', 3, 'R123465', 'EM PRODUÇÃO');  

-- Inserindo dados na tabela Pedidos de Fornecedores  
INSERT INTO pedido_fornecedor (id_fornecedor, data_solicitacao, data_entrega_prevista, status_solicitacao) VALUES  
(1, '2023-01-05', '2023-01-15', 'PENDENTE'),  
(2, '2023-01-06', '2023-01-16', 'PENDENTE'),  
(3, '2023-01-07', '2023-01-17', 'PENDENTE'),  
(4, '2023-01-08', '2023-01-18', 'PENDENTE'),  
(5, '2023-01-09', '2023-01-19', 'PENDENTE'),  
(6, '2023-01-10', '2023-01-20', 'PENDENTE'),  
(7, '2023-01-11', '2023-01-21', 'PENDENTE'),  
(8, '2023-01-12', '2023-01-22', 'PENDENTE'),  
(9, '2023-01-13', '2023-01-23', 'PENDENTE'),  
(10, '2023-01-14', '2023-01-24', 'PENDENTE');  

-- Inserindo dados na tabela pedido_cliente_remedio  
INSERT INTO pedido_cliente_remedio (id_pedido, id_remedio) VALUES  
(1, 1),  
(1, 2),  
(2, 3),  
(3, 4),  
(4, 5),  
(5, 6),  
(6, 7),  
(7, 8),  
(8, 9),  
(9, 10);  

-- Inserindo dados na tabela pedido_fornecedor_remedio  
INSERT INTO pedido_fornecedor_remedio (id_pedido_fornecedor, id_remedio) VALUES  
(1, 1),  
(1, 2),  
(2, 3),  
(3, 4),  
(4, 5),  
(5, 6),  
(6, 7),  
(7, 8),  
(8, 9),  
(9, 10);  

-- Inserindo dados na tabela Funcionário  
INSERT INTO funcionario (nome, cargo, salario) VALUES  
('Carlos Alberto', 'Farmacêutico', 5000.00),  
('Fernanda Souza', 'Atendente', 3000.00),  
('Roberto Lima', 'Gerente', 7000.00),  
('Patrícia Costa', 'Vendedor', 3500.00),  
('Lucas Mendes', 'Estoquista', 2500.00),  
('Juliana Rocha', 'Farmacêutico', 5000.00),  
('Ricardo Alves', 'Atendente', 3000.00),  
('Ana Beatriz', 'Gerente', 7000.00),  
('Marcos Paulo', 'Vendedor', 3500.00),  
('Tatiane Ferreira', 'Estoquista', 2500.00);  

-- Inserindo dados na tabela Estoque  
INSERT INTO estoque (data_entrega_stq, qtd_stq, data_vali_stq, medida_frascos, medida_caixas, medida_cartelas, medida_unidade) VALUES  
('2023-01-01', 100, '2024-01-01', 10, 5, 20, 50),  
('2023-01-02', 200, '2024-01-02', 15, 10, 25, 60),  
('2023-01-03', 150, '2024-01-03', 12, 8, 22, 55),  
('2023-01-04', 300, '2024-01-04', 20, 15, 30, 70),  
('2023-01-05', 250, '2024-01-05', 18, 12, 28, 65),  
('2023-01-06', 180, '2024-01-06', 14, 9, 24, 58),  
('2023-01-07', 220, '2024-01-07', 16, 11, 26, 62),  
('2023-01-08', 130, '2024-01-08', 11, 7, 21, 53),  
('2023-01-09', 170, '2024-01-09', 13, 10, 23, 57),  
('2023-01-10', 190, '2024-01-10', 17, 14, 29, 68);  

-- Inserindo dados na tabela possui (relacionando estoque e remédio)  
INSERT INTO possui (id_estoque, id_remedio) VALUES  
(1, 1),  
(1, 2),  
(2, 3),  
(2, 4),  
(3, 5),  
(3, 6),  
(4, 7),  
(4, 8),  
(5, 9),  
(5, 10);  

-- Inserindo dados na tabela Histórico de Compra  
INSERT INTO historico_compra (receitas, ult_compra, id_cliente) VALUES  
('Receita 1', '2023-01-10', 1),  
('Receita 2', '2023-01-11', 2),  
('Receita 3', '2023-01-12', 3),  
('Receita 4', '2023-01-13', 4),  
('Receita 5', '2023-01-14', 5),  
('Receita 6', '2023-01-15', 6),  
('Receita 7', '2023-01-16', 7),  
('Receita 8', '2023-01-17', 8),  
('Receita 9', '2023-01-18', 9),  
('Receita 10', '2023-01-19', 10);  

-- Inserindo dados na tabela faz_parte (relacionando histórico de compra e remédio)  
INSERT INTO faz_parte (id_historico, id_remedio) VALUES  
(1, 1),  
(1, 2),  
(2, 3),  
(3, 4),  
(4, 5),  
(5, 6),  
(6, 7),  
(7, 8),  
(8, 9),  
(9, 10),  
(10, 1);