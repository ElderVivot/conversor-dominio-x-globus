SELECT emp.cgce_emp AS 'EMPRESA',
       emp.cgce_emp AS 'FILIAL',
       fun.i_empregados AS 'REGISTRO DO FUNCIONARIO',
       DATEFORMAT(alt.competencia, 'DD/MM/YYYY') AS 'DATA INICIO DA VIGENCIA',
       coalesce( ( select tabela.nome
		             from bethadba.fotabelas AS tabela
		            where tabela.i_tabelas = 5
		              and tabela.i_codigo = alt.motivo ), '') AS 'MOTIVO DE ALTERACAO',
       alt.novo_salario AS 'SALARIO BASE',
       ( SELECT emp.cgce_emp || '-' || cargo.i_cargos || '-' || cargo.nome 
           FROM bethadba.fotrocas_cargos as altcar 
                INNER JOIN bethadba.focargos AS cargo
                     ON    cargo.CODI_EMP = altcar.codi_emp
                       and cargo.i_cargos = altcar.i_cargos 
                       and altcar.i_empregados = fun.i_empregados
          WHERE altcar.codi_emp = fun.codi_emp 
            AND altcar.i_empregados = fun.i_empregados
            and altcar.data_troca = ( select max(altcar2.data_troca)
                                      FROM bethadba.fotrocas_cargos AS altcar2
                                     where altcar2.codi_emp = alt.codi_emp
                                       and altcar2.i_empregados = alt.i_empregados
                                       and altcar2.data_troca <= alt.competencia) ) AS 'FUNCAO',
       fun.i_sindicatos || '-' || ( SELECT sind.nome 
                               FROM bethadba.fosindicatos AS sind 
                              WHERE sind.i_sindicatos = fun.i_sindicatos ) AS 'SINDICATO',
       'GERAL' AS 'AREA',
       fun.i_depto || '-' || ( SELECT depto.nome 
                                 FROM bethadba.fodepto AS depto
                                WHERE depto.codi_emp = fun.codi_emp 
                                  AND depto.i_depto = fun.i_depto ) AS 'DEPARTAMENTO',
       fun.i_ccustos || '-' || ( SELECT ccusto.nome 
                                 FROM bethadba.foccustos AS ccusto
                                WHERE ccusto.codi_emp = fun.codi_emp 
                                  AND ccusto.i_ccustos = fun.i_ccustos ) AS 'SETOR',
       'GERAL' AS 'SECAO' 
       
  FROM bethadba.foempregados AS fun
       INNER JOIN bethadba.foaltesal AS alt
            ON    alt.codi_emp = fun.codi_emp
              AND alt.i_empregados = fun.i_empregados
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = fun.codi_emp

 WHERE emp.cgce_emp LIKE '07515384%'
   AND fun.tipo_epr = 1

ORDER BY alt.codi_emp, alt.i_empregados, alt.competencia