-- 0) Uncategorized (Sem Categoria)

SELECT O.Email
FROM dt_Order AS O
WHERE 
  O.CreationDate IS NOT NULL
  AND O.TotalPrice IS NOT NULL
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING NOT (
  -- 1) Lost
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) >= @diasAtras
	AND COUNT(O.OrderId) = @quantidadePedidos
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) <= @valor
  )
  OR
  -- 2) Hibernating
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) >= @diasAtras
	AND COUNT(O.OrderId) BETWEEN @quantidadePedidosInicial AND @quantidadePedidosFinal
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) <= @valor
  )
  OR
  -- 3) About to Sleep
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	AND COUNT(O.OrderId) = @quantidadePedidos
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) BETWEEN @valorInicial AND @valorFinal
  )
  OR
  -- 4) Need Attention
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	AND COUNT(O.OrderId) = @quantidadePedidos
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor
  )
  OR
  -- 5) At Risk
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	AND COUNT(O.OrderId) >= @quantidadePedidos
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor
  )
  OR
  -- 6) Promising
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	AND COUNT(O.OrderId) BETWEEN @quantidadePedidosInicial AND @quantidadePedidosFinal
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) BETWEEN @valorInicial AND @valorFinal
  )
  OR
  -- 7) New Customers
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) <= @diasAtras
	AND COUNT(O.OrderId) = @quantidadePedidos
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor
  )
  OR
  -- 8) Potential Loyalist
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) <= @diasAtras
	AND COUNT(O.OrderId) BETWEEN @quantidadePedidosInicial AND @quantidadePedidosFinal
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor
  )
  OR
  -- 9) Loyal
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
	AND COUNT(O.OrderId) >= @quantidadePedidos
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor
  )
  OR
  -- 10) Champions
  (
	DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) <= @diasAtras
	AND COUNT(O.OrderId) >= @quantidadePedidos
	AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor
  )
)

-- 1) Lost Customers (Clientes Perdidos)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) >= @diasAtras
  AND COUNT(O.OrderId) = @quantidadePedidos
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) <= @valor

-- 2) Hibernating (Clientes Hibernados)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) >= @diasAtras
  AND COUNT(O.OrderId) BETWEEN @quantidadePedidosInicial AND @quantidadePedidosFinal
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) <= @valor

-- 3) About to Sleep (Prestes a Adormecer)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.OrderId) = @quantidadePedidos
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) BETWEEN @valorInicial AND @valorFinal

-- 4) Need Attention (Precisa de Atenção)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.OrderId) = @quantidadePedidos
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor

-- 5) At Risk (Em Risco)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.OrderId) >= @quantidadePedidos
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor

-- 6) Promising (Promissor)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.OrderId) BETWEEN @quantidadePedidosInicial AND @quantidadePedidosFinal
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) BETWEEN @valorInicial AND @valorFinal

-- 7) New Customers (Novos Clientes)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) <= @diasAtras
  AND COUNT(O.OrderId) = @quantidadePedidos
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor

-- 8) Potential Loyalist (Potencial Fiel)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) <= @diasAtras
  AND COUNT(O.OrderId) BETWEEN @quantidadePedidosInicial AND @quantidadePedidosFinal
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor

-- 9) Loyal (Fiel)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) BETWEEN @diasIniciais AND @diasFinais
  AND COUNT(O.OrderId) >= @quantidadePedidos
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor

-- 10) Champions (Campeões)

SELECT O.Email
FROM dt_Order AS O
WHERE O.CreationDate IS NOT NULL 
  AND O.TotalPrice IS NOT NULL 
  AND O.Email IS NOT NULL
  AND O.Status = 'Faturado'
GROUP BY O.Email
HAVING 
  DATEDIFF(DAY, MAX(O.CreationDate), GETDATE()) <= @diasAtras
  AND COUNT(O.OrderId) >= @quantidadePedidos
  AND SUM(TRY_CAST(O.TotalPrice AS DECIMAL) + TRY_CAST(O.TotalShipping AS DECIMAL)) >= @valor
