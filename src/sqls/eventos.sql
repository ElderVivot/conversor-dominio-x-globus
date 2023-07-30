SELECT emp.cgce_emp || '_' || eve.i_eventos AS 'CODIGO EVENTO',
       eve.nome AS 'DESCRI플O EVENTO',
       CASE WHEN eve.prov_desc = 'P' THEN 'PROVENTOS'
            WHEN eve.prov_desc = 'D' THEN 'DESCONTOS'
            WHEN eve.prov_desc = 'I' THEN 'INFORMATIVA'
            WHEN eve.prov_desc = 'ID' THEN 'INFORMATIVA DEDUDORA'
            ELSE eve.prov_desc 
       END AS 'TIPO DE EVENTO',
       CASE WHEN eve.tipo_inf = 'H' THEN 'HORAS'
            WHEN eve.tipo_inf = 'V' THEN 'VALOR'
            WHEN eve.tipo_inf = 'A' THEN 'AUTOMATICO'
            WHEN eve.tipo_inf = 'D' THEN 'DIAS'
            WHEN eve.tipo_inf = 'P' THEN 'PERCENTUAL'
            ELSE eve.tipo_inf
       END AS 'ROTINA',
       COALESCE( (SELECT MAX('SIM')
                    FROM bethadba.foeventosbases AS evebase
                   WHERE evebase.codi_emp = eve.codi_emp
                     AND evebase.i_eventos = eve.i_eventos 
                     AND evebase.i_cadbases IN ( -9,-6,-12,-7,-10,-13,-8,-20, -21 ) ), 'NAO' ) AS 'INCIDENCIA/DEDU플O INSS',
       COALESCE( (SELECT MAX('SIM')
                    FROM bethadba.foeventosbases AS evebase
                   WHERE evebase.codi_emp = eve.codi_emp
                     AND evebase.i_eventos = eve.i_eventos 
                     AND evebase.i_cadbases IN ( 21,22,23 ) ), 'NAO' ) AS 'INCIDENCIA/DEDU플O IRRF',
       COALESCE( (SELECT MAX('SIM')
                    FROM bethadba.foeventosbases AS evebase
                   WHERE evebase.codi_emp = eve.codi_emp
                     AND evebase.i_eventos = eve.i_eventos 
                     AND evebase.i_cadbases IN ( 15,16,17,-15,-16,-17,-18,-19 ) ), 'NAO' ) AS 'INCIDENCIA/DEDU플O FGTS',
       eve.codigo_esocial AS 'RUBRICA ESOCIAL',
       eve.codigo_incidencia_inss_esocial AS 'INCIDENCIA/DEDU플O TRIBUTARIA RUBRICA INSS',
       eve.codigo_incidencia_irrf_esocial AS 'INCIDENCIA/DEDU플O TRIBUTARIA RUBRICA IRRF',
       eve.codigo_incidencia_fgts_esocial AS 'INCIDENCIA/DEDU플O TRIBUTARIA RUBRICA FGTS'       

  FROM bethadba.foeventos AS eve
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = eve.codi_emp

 WHERE emp.cgce_emp LIKE '07515384%'
   AND EXISTS ( SELECT 1
                  FROM bethadba.FOMOVTO AS mov
                       INNER JOIN bethadba.foparmto AS parmto
                            ON    parmto.codi_emp = mov.codi_emp
                 WHERE parmto.codi_emp_eve = eve.codi_emp
                   AND mov.i_eventos  = eve.i_eventos )

ORDER BY eve.codi_emp, eve.i_eventos