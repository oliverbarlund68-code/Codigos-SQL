-- Função que abate o estoque automaticamente quando um item é inserido no pedido
CREATE OR REPLACE FUNCTION atualizar_estoque()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE produtos
    SET estoque = estoque - NEW.quantidade
    WHERE produto_id = NEW.produto_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que dispara a função acima após cada inserção em itens_pedido
CREATE TRIGGER trg_baixa_estoque
AFTER INSERT ON itens_pedido
FOR EACH ROW
EXECUTE FUNCTION atualizar_estoque();

-- View para facilitar a consulta do resumo financeiro de cada pedido
CREATE OR REPLACE VIEW vw_resumo_pedidos AS
SELECT 
    p.pedido_id,
    c.nome AS cliente,
    c.uf,
    p.data_pedido,
    p.status,
    SUM(ip.quantidade * ip.preco_unitario) AS valor_total
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id
JOIN itens_pedido ip ON p.pedido_id = ip.pedido_id
GROUP BY p.pedido_id, c.nome, c.uf, p.data_pedido, p.status;
