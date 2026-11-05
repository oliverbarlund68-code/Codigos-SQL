-- Consulta 1: Usando a View criada para listar pedidos concluídos
SELECT * FROM vw_resumo_pedidos WHERE status = 'CONCLUIDO';

-- Consulta 2: Ranking de faturamento por categoria e saldo atual em estoque
SELECT 
    prod.categoria,
    COUNT(DISTINCT ip.pedido_id) AS qtd_pedidos,
    SUM(ip.quantidade) AS unidades_vendidas,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total,
    RANK() OVER (ORDER BY SUM(ip.quantidade * ip.preco_unitario) DESC) AS posicao_ranking
FROM produtos prod
LEFT JOIN itens_pedido ip ON prod.produto_id = ip.produto_id
GROUP BY prod.categoria;

-- Consulta 3: Verificar o estoque atualizado após as vendas
SELECT nome_produto, estoque FROM produtos ORDER BY nome_produto;
