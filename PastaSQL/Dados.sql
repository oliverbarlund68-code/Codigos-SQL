BEGIN;

INSERT INTO clientes (nome, email, uf) VALUES
('Mariana Costa', 'mariana@email.com', 'MG'),
('Carlos Mendes', 'carlos@email.com', 'SP'),
('Fernanda Lima', 'fernanda@email.com', 'RJ');

INSERT INTO produtos (nome_produto, categoria, preco, estoque) VALUES
('Notebook Pro 15', 'Eletrônicos', 4500.00, 10),
('Mouse Sem Fio', 'Acessórios', 120.00, 50),
('Monitor 27 4K', 'Eletrônicos', 1800.00, 15),
('Teclado Mecânico', 'Acessórios', 350.00, 30);

-- Criando pedidos e adicionando itens (a Trigger reduzirá o estoque automaticamente)
INSERT INTO pedidos (cliente_id, status) VALUES (1, 'CONCLUIDO'), (2, 'CONCLUIDO'), (1, 'CONCLUIDO');

INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 4500.00),
(1, 2, 2, 120.00),
(2, 3, 1, 1800.00),
(3, 4, 1, 350.00);

COMMIT;
