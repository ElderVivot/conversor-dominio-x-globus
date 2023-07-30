SELECT emp.cgce_emp AS 'EMPRESA',
       emp.cgce_emp AS 'FILIAL',
       fun.i_empregados AS 'REGISTRO DO FUNCIONARIO',
       fun.nome AS 'NOME FUNCIONARIO',
       DATEFORMAT(fer.inicio_gozo, '01/MM/YYYY') AS 'COMPETENCIA',
       'FERIAS' AS 'TIPO DE FERIAS',
       DATEFORMAT(fer.inicio_aquisitivo, 'DD/MM/YYYY') AS 'PERIODO AQUISITIVO INICIAL',
       DATEFORMAT(fer.fim_aquisitivo, 'DD/MM/YYYY') AS 'PERIODO AQUISITIVO FINAL',
       DATEFORMAT(fer.inicio_gozo, 'DD/MM/YYYY') AS 'PERIODO DE GOZO INICIAL',
       DATEFORMAT(fer.fim_gozo, 'DD/MM/YYYY') AS 'PERIODO DE GOZO FINAL',
       CASE WHEN fer.pago_abono = 'S' THEN DATEFORMAT(fer.inicio_abono, 'DD/MM/YYYY') ELSE '' END AS 'PERIODO DE GOZO ABONO INICIAL',
       CASE WHEN fer.pago_abono = 'S' THEN DATEFORMAT(fer.fim_abono, 'DD/MM/YYYY') ELSE '' END AS 'PERIODO DE GOZO ABONO FINAL'


/* nao mexer daqui pra baixo */
  FROM bethadba.foferias AS fer
       INNER JOIN bethadba.foempregados AS fun
            ON    fun.codi_emp = fer.codi_emp
              AND fun.i_empregados = fer.i_empregados
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = fun.codi_emp

 WHERE emp.cgce_emp LIKE '07515384%'
 
 ORDER BY fun.codi_emp, fun.i_empregados, fer.inicio_aquisitivo
