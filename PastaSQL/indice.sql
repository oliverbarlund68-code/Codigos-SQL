-- Criação da tabela de clientes
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    uf CHAR(2) NOT NULL,
    data_cadastro DATE DEFAULT CURRENT_DATE
);

-- Criação da tabela de produtos com controle de estoque
CREATE TABLE produtos (
    produto_id SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    estoque INT NOT NULL CHECK (estoque >= 0)
);

-- Criação da tabela de pedidos
CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES clientes(cliente_id),
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'PENDENTE'
);

-- Criação da tabela associativa de itens do pedido
CREATE TABLE itens_pedido (
    item_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL REFERENCES pedidos(pedido_id) ON DELETE CASCADE,
    produto_id INT NOT NULL REFERENCES produtos(produto_id),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10, 2) NOT NULL
);

-- Índice para acelerar buscas de pedidos por cliente
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
