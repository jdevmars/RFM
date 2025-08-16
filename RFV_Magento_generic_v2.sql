/*

RFM for Magento based on Order table

*/

-- 0) Uncategorized (Sem Categoria)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete')
GROUP BY O.customer_email
HAVING
  NOT (
    (
      -- Lost
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) >= @diasAtras
	  AND COUNT(O.order_id) = @quantidadePedidos
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) <= @valor
    )
    OR (
      -- Hibernating
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) >= @diasAtras
	  AND COUNT(O.order_id) BETWEEN @quantidadePedidosMinima AND @quantidadePedidosMaxima
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) <= @valor
    )
    OR (
      -- About to Sleep
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	  AND COUNT(O.order_id) = @quantidadePedidos
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) BETWEEN @valorInicial AND @valorFinal
    )
    OR (
      -- Need Attention
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	  AND COUNT(O.order_id) = @quantidadePedidos
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor
    )
    OR (
      -- At Risk
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	  AND COUNT(O.order_id) >= @quantidadePedidos
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor
    )
    OR (
      -- Promising
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	  AND COUNT(O.order_id) BETWEEN @quantidadePedidosMinima AND @quantidadePedidosMaxima
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) BETWEEN @valorInicial AND @valorFinal
    )
    OR (
      -- New Customers
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) <= @diasAtras
	  AND COUNT(O.order_id) = @quantidadePedidos
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor
    )
    OR (
      -- Potential Loyalist
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) <= @diasAtras
	  AND COUNT(O.order_id) BETWEEN @quantidadePedidosMinima AND @quantidadePedidosMaxima
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor
    )
    OR (
      -- Loyal
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	  AND COUNT(O.order_id) >= @quantidadePedidos
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor
    )
    OR (
      -- Champions
	  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) <= @diasAtras
	  AND COUNT(O.order_id) >= @quantidadePedidos
	  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor
    )
  )

-- 1) Lost Customers (Clientes Perdidos)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) >= @diasAtras
  AND COUNT(O.order_id) = @quantidadePedidos
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) <= @valor

-- 2) Hibernating Customers (Clientes Hibernados)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) >= @diasAtras
  AND COUNT(O.order_id) BETWEEN @quantidadePedidosMinima AND @quantidadePedidosMaxima
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) <= @valor

-- 3) About to Sleep (Prestes a Adormecer)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.order_id) = @quantidadePedidos
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) BETWEEN @valorInicial AND @valorFinal

-- 4) Need Attention (Precisa de Atenção)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.order_id) = @quantidadePedidos
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor

-- 5) At Risk (Em Risco)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.order_id) >= @quantidadePedidos
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor

-- 6) Promising (Promissor)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.order_id) BETWEEN @quantidadePedidosMinima AND @quantidadePedidosMaxima
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) BETWEEN @valorInicial AND @valorFinal

-- 7) New Customers (Novos Clientes)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) <= @diasAtras
  AND COUNT(O.order_id) = @quantidadePedidos
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor

-- 8) Potential Loyalist (Potencial Fiel)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) <= @diasAtras
  AND COUNT(O.order_id) BETWEEN @quantidadePedidosMinima AND @quantidadePedidosMaxima
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor

-- 9) Loyal (Fiel)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.order_id) >= @quantidadePedidos
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor

-- 10) Champions (Campeões)

SELECT O.customer_email
FROM dt_Order_Magento AS O
WHERE O.created_at IS NOT NULL
  AND O.customer_email IS NOT NULL
  AND O.status IN ('delivered','complete') 
GROUP BY O.customer_email
HAVING
  DATEDIFF(DAY, MAX(O.created_at), GETDATE()) <= @diasAtras
  AND COUNT(O.order_id) >= @quantidadePedidos
  AND SUM(TRY_CAST(O.total_paid AS DECIMAL(18,2))) >= @valor
