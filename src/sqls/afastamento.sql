SELECT emp.cgce_emp AS 'EMPRESA',
       emp.cgce_emp AS 'FILIAL',
       fun.i_empregados AS 'REGISTRO DO FUNCIONARIO',
       fun.nome AS 'NOME FUNCIONARIO',
       DATEFORMAT(afa.data_folha, 'DD/MM/YYYY') AS 'INICIO DE AFASTAMENTO', /* sem considerar os 15 primeiros dias */
       DATEFORMAT(days(afa.data_real, -1), 'DD/MM/YYYY') AS 'ULTIMO DIA DE TRABALHO',
       afadesc.descricao AS 'CONDICAO DE AFASTAMENTO',
       DATEFORMAT(afa.data_fim, 'DD/MM/YYYY') AS 'ULTIMO DIA DE AFASTAMENTO'


/* nao mexer daqui pra baixo */
  FROM bethadba.FOAFASTAMENTOS  AS afa
       INNER JOIN bethadba.foempregados AS fun
            ON    fun.codi_emp = afa.codi_emp
              AND fun.i_empregados = afa.i_empregados
       INNER JOIN bethadba.foafastamentos_tipos AS afadesc
            ON    afadesc.I_AFASTAMENTOS = afa.I_AFASTAMENTOS 
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = fun.codi_emp

 WHERE emp.cgce_emp LIKE '07515384%'
   AND afa.I_AFASTAMENTOS not in (1,8,9)
 
order by fun.codi_emp, fun.i_empregados, afa.data_real
