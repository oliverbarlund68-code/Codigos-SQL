WITH VendasConsolidadas AS (
    -- 1. CTE para unir tabelas e calcular o valor líquido de cada pedido
    SELECT 
        c.cliente_id,
        c.nome AS nome_cliente,
        cat.nome_categoria,
        p.pedido_id,
        p.data_pedido,
        SUM(ip.quantidade * ip.preco_unitario * (1 - COALESCE(ip.desconto, 0))) AS valor_pedido
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    INNER JOIN itens_pedido ip ON p.pedido_id = ip.pedido_id
    INNER JOIN produtos prod ON ip.produto_id = prod.produto_id
    INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
    WHERE p.status = 'CONCLUIDO'
      AND p.data_pedido >= '2026-01-01'
    GROUP BY 
        c.cliente_id, 
        c.nome, 
        cat.nome_categoria, 
        p.pedido_id, 
        p.data_pedido
),
MetricasPorCliente AS (
    -- 2. Segunda CTE para aplicar Window Functions (Rankings e Médias Móveis/Particionadas)
    SELECT 
        nome_categoria,
        nome_cliente,
        COUNT(pedido_id) AS total_pedidos,
        SUM(valor_pedido) AS total_gasto,
        -- Média de gasto dentro da mesma categoria sem agrupar as linhas
        AVG(SUM(valor_pedido)) OVER(PARTITION BY nome_categoria) AS media_categoria,
        -- Ranking dos maiores compradores por categoria (sem pular posições em caso de empate)
        DENSE_RANK() OVER(
            PARTITION BY nome_categoria 
            ORDER BY SUM(valor_pedido) DESC
        ) AS ranking_categoria,
        -- Participação percentual do cliente no total da categoria
        ROUND(
            (SUM(valor_pedido) / SUM(SUM(valor_pedido)) OVER(PARTITION BY nome_categoria)) * 100, 
            2
        ) AS participacao_pct
    FROM VendasConsolidadas
    GROUP BY nome_categoria, cliente_id, nome_cliente
)
-- 3. Consulta final filtrando apenas o Top 3 de cada categoria e classificando o perfil
SELECT 
    nome_categoria,
    ranking_categoria,
    nome_cliente,
    total_pedidos,
    ROUND(total_gasto, 2) AS total_gasto,
    ROUND(media_categoria, 2) AS media_categoria,
    participacao_pct || '%' AS share_categoria,
    CASE 
        WHEN total_gasto > media_categoria * 1.5 THEN 'VIP'
        WHEN total_gasto >= media_categoria THEN 'Acima da Média'
        ELSE 'Regular'
    END AS perfil_cliente
FROM MetricasPorCliente
WHERE ranking_categoria <= 3
ORDER BY nome_categoria ASC, ranking_categoria ASC;
