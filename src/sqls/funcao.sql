SELECT emp.cgce_emp || '-' || cargo.i_cargos AS 'CODIGO FUN��O',
       cargo.nome AS 'DESCRI��O FUN��O',
       cargo.cbo_2002 AS 'CBO',
       cargo.atividade AS 'INFORMA��ES GERAIS DESCRI��O DE ATIVIDADE',
       '99.999' AS 'ATIVIDADES ESOCIAL'

  FROM bethadba.focargos AS cargo
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = cargo.codi_emp

 WHERE emp.cgce_emp LIKE '07515384%'
 

