SELECT emp.codi_emp AS 'ID_EMPRESA', mov.tipo_proces AS 'CD_TIPO_FOLHA', fun.cpf AS 'NR_CPF', 
       DATEFORMAT(mov.data, 'YYYYMM') AS 'NR_ANOMES', mov.i_eventos AS 'CD_EVENTO_FOLHA',
       mov.valor_inf AS 'VL_REFERENCIA', mov.valor_cal AS 'VL_VALOR',
       DATEFORMAT(bserv.data_pagto, 'DDMMYYYY') AS 'DT_PAGAMENTO', 
       DATEFORMAT(today(), 'DDMMYYYY') AS 'DT_IMPORTACAO'

  FROM bethadba.fomovto AS mov
       INNER JOIN bethadba.fobasesserv AS bserv
            ON    bserv.codi_emp = mov.codi_emp
              AND bserv.i_empregados = mov.i_empregados
              AND bserv.i_calculos = mov.i_calculos
              AND bserv.rateio = mov.rateio
       INNER JOIN bethadba.foempregados AS fun
              ON    fun.codi_emp = mov.codi_emp
                AND fun.i_empregados = mov.i_empregados
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = mov.codi_emp

 WHERE emp.codi_emp = '#codi_emp#'
   AND mov.rateio = 0
   AND mov.tipo_proces not in (51,52)

ORDER BY mov.codi_emp, mov.i_empregados, mov.data