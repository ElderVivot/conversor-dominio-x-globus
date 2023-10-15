SELECT emp.codi_emp AS 'EMPRESA',
       emp.cgce_emp AS 'FILIAL',
       fun.i_empregados AS 'REGISTRO DO FUNCIONARIO',
       fun.nome AS 'NOME FUNCIONARIO',
       CASE WHEN fun.i_afastamentos = 1 THEN 'ATIVO'
            WHEN fun.i_afastamentos IN (8,23) THEN 'DESLIGADO'
            ELSE 'AFASTAMENTO'  
       END AS 'SITUACAO FUNCIONARIO',
       COALESCE( ( SELECT afades.descricao
                     FROM bethadba.FOAFASTAMENTOS_TIPOS AS afades
                    WHERE afades.I_AFASTAMENTOS = fun.i_afastamentos 
                      AND afades.I_AFASTAMENTOS NOT IN(1) ) , '') AS 'CODIGO DE CONDICAO',
       ( SELECT DATEFORMAT(res.demissao, 'DD/MM/YYYY') 
           FROM bethadba.forescisoes AS res
          WHERE res.codi_emp = fun.codi_emp 
            AND res.i_empregados = fun.i_empregados 
            AND res.tipo = 1 ) AS 'DATA DESL/AFAST',
       fun.cpf AS 'CPF',
       fun.pis AS 'PIS',
       fun.i_empregados AS 'CHAPA',
       DATEFORMAT(fun.data_nascimento, 'DD/MM/YYYY') AS 'DATA DE NASCIMENTO',
       ( SELECT mun.codigo_ibge || '-' || mun.nome_municipio 
           FROM bethadba.gemunicipio AS mun 
          WHERE mun.codigo_municipio = fun.municipio_nascimento ) AS 'MUNICIPIO NASC',
       fun.uf_nascimento AS 'UF NASC',
       fun.sexo AS 'SEXO',
       fun.grau_instrucao || '-' || CASE WHEN fun.grau_instrucao = 1 THEN 'Analfabeto'
                               WHEN fun.grau_instrucao = 2 THEN 'Ensino Fundamental at� 5� ano Incompleto'
                               WHEN fun.grau_instrucao = 3 THEN 'Ensino Fundamental 5� Completo'
                               WHEN fun.grau_instrucao = 4 THEN 'Ensino Fundamental 6� ao 9�'
                               WHEN fun.grau_instrucao = 5 THEN 'Ensino Fundamental Completo'
                               WHEN fun.grau_instrucao = 6 THEN 'Ensino M�dio Incompleto'
                               WHEN fun.grau_instrucao = 7 THEN 'Ensino M�dio Completo'
                               WHEN fun.grau_instrucao = 8 THEN 'Ensino Superior Incompleto'
                               WHEN fun.grau_instrucao = 9 THEN 'Ensino Superior Completo'
                               WHEN fun.grau_instrucao = 10 THEN 'P�s Gradua��o'
                               WHEN fun.grau_instrucao = 11 THEN 'Mestrado'
                               WHEN fun.grau_instrucao = 12 THEN 'Doutorado'
                               WHEN fun.grau_instrucao = 13 THEN 'Ph. D'
                               ELSE ''
                          END AS 'GRAU DE INSTRUCAO',
       'BRASILEIRA' AS 'NACIONALIDADE',
       CASE WHEN fun.estado_civil = 'S' THEN 'Solteiro'
             WHEN fun.estado_civil = 'C' THEN 'Casado'
             WHEN fun.estado_civil = 'V' THEN 'Viuvo'
             WHEN fun.estado_civil = 'D' THEN 'Divorciado' 
             WHEN fun.estado_civil = 'O' THEN 'Concubinato'
             WHEN fun.estado_civil = 'J' THEN 'Separado judicialmente'
             WHEN fun.estado_civil = 'U' THEN 'Uniao estavel'
             ELSE ''
        END AS 'ESTADO CIVIL',
       DATEFORMAT(fun.admissao, 'DD/MM/YYYY') AS 'DATA DE ADMISSAO',
       bco.numero AS 'BANCO ',
       bco.agencia AS 'AGENCIA',
       COALESCE(fun.conta_corr, '') || COALESCE(fun.DIGITO_CONTA_PAGAMENTO, '') AS 'CONTA CORRENTE',
       ( SELECT p.nome_pais 
           FROM bethadba.gepais AS p
          WHERE p.codigo_pais = fun.pais_nascimento ) AS 'PAIS NASCIMENTO',
       ( SELECT p.nome_pais 
           FROM bethadba.gepais AS p
          WHERE p.codigo_pais = fun.pais_nacionalidade ) AS 'PAIS NACIONALIDADE',
       fun.nome AS 'APELIDO',
       fun.nome AS 'NOME COMPLETO',
       fun.salario AS 'SALARIO BASE',
       ( SELECT emp.cgce_emp || '-' || cargo.i_cargos || '-' || cargo.nome 
           FROM bethadba.focargos AS cargo 
          WHERE cargo.codi_emp = fun.codi_emp 
            AND cargo.i_cargos = fun.i_cargos ) AS 'FUNCAO',
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
       'GERAL' AS 'SECAO FUNCIONARIO',
       CASE WHEN fun.vinculo = 1 THEN 'Celetista'
            WHEN fun.vinculo = 2 THEN 'Estatutario'
            WHEN fun.vinculo = 3 THEN 'Trabalhador Avulso'
            WHEN fun.vinculo = 4 THEN 'Trabalhador Temporario Lei 6.019/74'
            WHEN fun.vinculo = 5 THEN 'Celetista Contrato Prazo Determinado' 
            WHEN fun.vinculo = 6 THEN 'Trabalhador Rural'
            WHEN fun.vinculo = 8 THEN 'Servidor P�blico n�o Efetivo'
            WHEN fun.vinculo = 9 THEN 'Trab. Rural Contrato Prazo Determinado'
            WHEN fun.vinculo = 10 THEN 'Contrato Prazo Determinado Lei 9.601/98'
            WHEN fun.vinculo = 50 THEN 'Estagiario'
            WHEN fun.vinculo = 52 THEN 'Empregado Domestico'
            WHEN fun.vinculo = 53 THEN 'Aprendiz'
            WHEN fun.vinculo = 99 THEN 'Celetista regime tempo parcial'
            ELSE STRING(fun.vinculo)
       END AS 'VINCULO ENPREGATICIO',
       CASE WHEN fun.emprego_ant = 1 THEN 'ADMISSAO'
            WHEN fun.emprego_ant = 2 THEN 'ADMISSAO POR SUCESSAO, INCORPORACAO OU FUSAO'
            WHEN fun.emprego_ant = 4 THEN 'TRANSFERENCIA SEM ONUS'
            ELSE STRING(fun.emprego_ant)
       END AS 'TIPO DE ADMISSAO',
       CASE WHEN fun.cor = 0 THEN 'INDIGENA'
            WHEN fun.cor = 2 THEN 'BRANCA'
            WHEN fun.cor = 4 THEN 'NEGRA'
            WHEN fun.cor = 6 THEN 'AMARELA'
            WHEN fun.cor = 8 THEN 'PARDA'
            ELSE 'NAO INFORMADO'
       END AS 'RACA',
       '08:00' AS 'JORNADA DIARIA',
       '' AS 'DOCUMENTO 3',
       fun.identidade AS 'RG',
       CASE WHEN fun.orgao_expedicao_rg = 1 THEN 'SSP'
			WHEN fun.orgao_expedicao_rg = 2 THEN 'TRE'
			WHEN fun.orgao_expedicao_rg = 3 THEN'EXT'
			WHEN fun.orgao_expedicao_rg = 4 THEN'DRT'
			WHEN fun.orgao_expedicao_rg = 5 THEN'M MILITAR'
			WHEN fun.orgao_expedicao_rg = 6 THEN'MIN AER'
			WHEN fun.orgao_expedicao_rg = 7 THEN'MIN EXER'
			WHEN fun.orgao_expedicao_rg = 8 THEN'MIN MAR'
			WHEN fun.orgao_expedicao_rg = 9 THEN'DPF'
			WHEN fun.orgao_expedicao_rg = 10 THEN'INSS'
			WHEN fun.orgao_expedicao_rg = 11 THEN'SRF'
			WHEN fun.orgao_expedicao_rg = 12 THEN'CLASSISTAS'
			WHEN fun.orgao_expedicao_rg = 13 THEN'CRA'
			WHEN fun.orgao_expedicao_rg = 14 THEN'CRAS'
			WHEN fun.orgao_expedicao_rg = 15 THEN'CRB'
			WHEN fun.orgao_expedicao_rg = 16 THEN'CRC'
			WHEN fun.orgao_expedicao_rg = 17 THEN'CRECI'
			WHEN fun.orgao_expedicao_rg = 18 THEN'COREN'
			WHEN fun.orgao_expedicao_rg = 19 THEN'CREA'
			WHEN fun.orgao_expedicao_rg = 20 THEN'CONRE'
			WHEN fun.orgao_expedicao_rg = 21 THEN'CRF'
			WHEN fun.orgao_expedicao_rg = 22 THEN'CREFITO'
			WHEN fun.orgao_expedicao_rg = 23 THEN'CRM'
			WHEN fun.orgao_expedicao_rg = 24 THEN'CRMV'
			WHEN fun.orgao_expedicao_rg = 25 THEN'OMB'
			WHEN fun.orgao_expedicao_rg = 26 THEN'CRN'
			WHEN fun.orgao_expedicao_rg = 27 THEN'CRO'
			WHEN fun.orgao_expedicao_rg = 28 THEN'CONRERP'
			WHEN fun.orgao_expedicao_rg = 29 THEN'CRP'
			WHEN fun.orgao_expedicao_rg = 30 THEN'CRQ'
			WHEN fun.orgao_expedicao_rg = 31 THEN'CORE'
			WHEN fun.orgao_expedicao_rg = 32 THEN'OAB'
			WHEN fun.orgao_expedicao_rg = 33 THEN'OE'
			WHEN fun.orgao_expedicao_rg = 34 THEN'DOC ESTR'
			WHEN fun.orgao_expedicao_rg = 35 THEN'CRE'
			WHEN fun.orgao_expedicao_rg = 36 THEN'REG CIVIL'
			WHEN fun.orgao_expedicao_rg = 37 THEN'DETRAN'
			ELSE STRING(fun.orgao_expedicao_rg)
	   END AS 'ORGAO EMISSAO',
       DATEFORMAT(fun.dt_exp_ident, 'DD/MM/YYYY') AS 'DATA DE EXPEDICAO',
       fun.uf_exp_ident AS 'UF IDENTIDADE',
       fun.cart_prof AS 'CTPS',
       fun.serie_cart_prof AS 'SERIE',
       fun.uf_cart_prof AS 'UF CTPS',
       DATEFORMAT(fun.dt_exp_cprof, 'DD/MM/YYYY') AS 'EXPEDICAO CTPS',
       fun.cart_motorista AS 'CNH',
       fun.categ_cart_mot AS 'CATEGORIA CNH',
       DATEFORMAT(fun.venc_cart_mot, 'DD/MM/YYYY') AS 'VALIDADE CNH',
       DATEFORMAT(fun.data_expedicao_cnh, 'DD/MM/YYYY') AS 'EXPEDICAO CNH',
       CASE WHEN fun.cart_motorista IS NULL THEN ''
            ELSE ( SELECT uf.sigla_uf FROM bethadba.geestado AS uf WHERE uf.codigo_uf = fun.codigo_uf_carteira_motorista)
       END AS 'UF CNH',
       '' AS 'CIDADE CNH', // nao tem na dominio 
       fun.cart_reservista AS 'RESERVISTA',
       fun.cate_reservista AS 'CATEGORIA', 
       '' AS 'EXPEDICAO RESERVISTA', // nao tem na dominio
       fun.titulo_eleit AS 'TITULO DE ELEITOR',
       fun.zona_eleit AS 'ZONA',
       fun.secao_eleit AS 'SECAO',
       '' AS 'EXPEDICAO TIT ELEITOR', // nao tem na dominio
       ( SELECT p.nome_pais 
           FROM bethadba.gepais AS p
          WHERE p.codigo_pais = fun.PAIS_ENDERECO ) AS 'LOCAL DE RESIDENCIA',
       fun.cep AS 'CEP',
       COALESCE( CASE fun.tipo_endereco 
		WHEN 1 THEN 'Aeroporto'
        WHEN 45 THEN 'AEROPORTO'
        WHEN 2 THEN 'Alameda'
        WHEN 46 THEN 'ALAMEDA'
        WHEN 3 THEN 'Area'
        WHEN 47 THEN 'AREA'
        WHEN 4 THEN 'Avenida'
        WHEN 48 THEN 'AVENIDA'
        WHEN 89 THEN 'Balneario'
        WHEN 90 THEN 'BALNEARIO'
        WHEN 91 THEN 'Bloco'
        WHEN 92 THEN 'BLOCO'
        WHEN 5 THEN 'Campo'
        WHEN 49 THEN 'CAMPO'
        WHEN 6 THEN 'Chacara'
        WHEN 50 THEN 'CHaCARA'
        WHEN 7 THEN 'Colonia'
        WHEN 51 THEN 'COL�NIA'
        WHEN 8 THEN 'Condomonio'
        WHEN 52 THEN 'CONDOMONIO'
        WHEN 9 THEN 'Conjunto'
        WHEN 53 THEN 'CONJUNTO'
        WHEN 10 THEN 'Distrito'
        WHEN 54 THEN 'DISTRITO'
        WHEN 11 THEN 'Esplanada'
        WHEN 55 THEN 'ESPLANADA'
        WHEN 12 THEN 'Estacao'
        WHEN 56 THEN 'ESTACAO'
        WHEN 13 THEN 'Estrada'
        WHEN 57 THEN 'ESTRADA'
        WHEN 14 THEN 'Favela'
        WHEN 58 THEN 'FAVELA'
        WHEN 15 THEN 'Fazenda'
        WHEN 59 THEN 'FAZENDA'
        WHEN 16 THEN 'Feira'
        WHEN 60 THEN 'FEIRA'
        WHEN 93 THEN 'Galeria'
        WHEN 94 THEN 'GALERIA'
        WHEN 95 THEN 'Granja'
        WHEN 96 THEN 'GRANJA'
        WHEN 17 THEN 'Jardim'
        WHEN 61 THEN 'JARDIM'
        WHEN 18 THEN 'Ladeira'
        WHEN 62 THEN 'LADEIRA'
        WHEN 19 THEN 'Lago'
        WHEN 63 THEN 'LAGO'
        WHEN 20 THEN 'Lagoa'
        WHEN 64 THEN 'LAGOA'
        WHEN 21 THEN 'Largo'
        WHEN 65 THEN 'LARGO'
        WHEN 22 THEN 'Loteamento'
        WHEN 66 THEN 'LOTEAMENTO'
        WHEN 23 THEN 'Morro'
        WHEN 67 THEN 'MORRO'
        WHEN 24 THEN 'Nucleo'
        WHEN 68 THEN 'NUCLEO'
        WHEN 25 THEN 'Parque'
        WHEN 69 THEN 'PARQUE'
        WHEN 26 THEN 'Passarela'
        WHEN 70 THEN 'PASSARELA'
        WHEN 27 THEN 'Patio'
        WHEN 71 THEN 'PATIO'
        WHEN 28 THEN 'Praca'
        WHEN 72 THEN 'PRACA'
        WHEN 97 THEN 'Praia'
        WHEN 98 THEN 'PRAIA'
        WHEN 29 THEN 'Quadra'
        WHEN 73 THEN 'QUADRA'
        WHEN 30 THEN 'Recanto'
        WHEN 74 THEN 'RECANTO'
        WHEN 31 THEN 'Residencial'
        WHEN 75 THEN 'RESIDENCIAL'
        WHEN 32 THEN 'Rodovia'
        WHEN 76 THEN 'RODOVIA'
        WHEN 33 THEN 'Rua'
        WHEN 77 THEN 'RUA'
        WHEN 34 THEN 'Setor'
        WHEN 78 THEN 'SETOR'
        WHEN 35 THEN 'Sitio'
        WHEN 79 THEN 'SITIO'
        WHEN 36 THEN 'Travessa'
        WHEN 80 THEN 'TRAVESSA'
        WHEN 37 THEN 'Trecho'
        WHEN 81 THEN 'TRECHO'
        WHEN 38 THEN 'Trevo'
        WHEN 82 THEN 'TREVO'
        WHEN 39 THEN 'Vale'
        WHEN 83 THEN 'VALE'
        WHEN 40 THEN 'Vereda'
        WHEN 84 THEN 'VEREDA'
        WHEN 41 THEN 'Via'
        WHEN 85 THEN 'VIA'
        WHEN 42 THEN 'Viaduto'
        WHEN 86 THEN 'VIADUTO'
        WHEN 43 THEN 'Viela'
        WHEN 87 THEN 'VIELA'
        WHEN 44 THEN 'Vila'
        WHEN 88 THEN 'VILA'
        WHEN 99 THEN 'Outro'
		ELSE 'RUA' END , 'RUA' ) AS 'TIPO DE LOGRADOURO',
       fun.endereco AS 'ENDERECO',
       COALESCE(STRING(fun.numero_end), 'SN') AS 'NUMERO',
       fun.complemento AS 'COMPLEMENTO',
       fun.bairro AS 'BAIRRO',
       ( SELECT mun.codigo_ibge || '-' || mun.nome_municipio 
           FROM bethadba.gemunicipio AS mun 
          WHERE mun.codigo_municipio = fun.municipio_endereco ) AS 'MUNICIPIO ENDERECO',
       fun.estado AS 'UF ENDERECO',
       COALESCE(fun.DDD_CELULAR, '') || COALESCE(fun.celular, '') AS 'TELEFONE'


/* nao mexer daqui pra baixo */
  FROM bethadba.foempregados AS fun
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = fun.codi_emp
       LEFT JOIN bethadba.fobancos AS bco
           ON    bco.i_bancos = fun.i_bancos

 WHERE emp.cgce_emp LIKE '07515384%'
   AND fun.tipo_epr = 1
   --AND fun.i_afastamentos NOT IN (8)
   --AND fun.cart_prof IS null

ORDER BY emp.codi_emp, fun.i_empregados
