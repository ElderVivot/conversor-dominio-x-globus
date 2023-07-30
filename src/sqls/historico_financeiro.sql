SELECT emp.cgce_emp AS 'EMPRESA',
       emp.cgce_emp AS 'FILIAL',
       fun.i_empregados AS 'REGISTRO DO FUNCIONARIO',
       fun.nome AS 'NOME FUNCIONARIO',
       'FOLHA' AS 'TIPO DE FOLHA',
       DATEFORMAT(mov.data, 'DD/MM/YYYY') AS 'COMPETENCIA',
       'SIM' AS 'ENCERRADO',
       CASE WHEN bas.situacao_mes = 1 THEN 'ATIVO'
            WHEN bas.situacao_mes IN (8,23) THEN 'DESLIGADO'
            ELSE 'AFASTAMENTO'  
       END AS 'SITUACAO',
       '' AS 'CONDICAO',
       empeve.cgce_emp || '_' || mov.i_eventos || '-' || eve.nome AS 'EVENTO',
       mov.valor_inf AS 'REFERENCIA',
       mov.valor_cal AS 'VALOR'


/* nao mexer daqui pra baixo */
  FROM bethadba.foempregados AS fun
       INNER JOIN bethadba.fomovto AS mov
            ON    mov.codi_emp = fun.codi_emp
              AND mov.i_empregados = fun.i_empregados
       INNER JOIN bethadba.fobases AS bas
            ON    bas.codi_emp = mov.codi_emp
              AND bas.i_empregados = mov.i_empregados
              AND bas.competencia = mov.data
              AND bas.tipo_process = mov.tipo_proces
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = fun.codi_emp
       INNER JOIN bethadba.foparmto AS parmto
            ON    parmto.codi_emp = fun.codi_emp       
       INNER JOIN bethadba.geempre AS empeve
            ON    empeve.codi_emp = parmto.codi_emp_eve
       INNER JOIN bethadba.foeventos AS eve
            ON    eve.codi_emp = parmto.codi_emp_eve
              AND eve.i_eventos = mov.i_eventos

 WHERE emp.cgce_emp LIKE '07515384%'

ORDER BY mov.codi_emp, mov.i_empregados, mov.data