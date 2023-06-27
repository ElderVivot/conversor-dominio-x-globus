# coding: utf-8

from __future__ import annotations
from logging import Logger
import os
import sys
from typing import Any, Dict, List
import pandas as pd

currentFolder = os.path.dirname(__file__)
folderSrc = os.path.join(currentFolder, '..')
folderBeforeSrc = os.path.join(currentFolder, '..', '..')
sys.path.append(currentFolder)
sys.path.append(folderSrc)
sys.path.append(folderBeforeSrc)

from connection_db import ConnectionDB
from common.utils.read_sql import readSql
from common.exceptions.fetch_sql import FetchSQLExcepction


class ExtractMovimentacaoFolha():
    def __init__(self, logger: Logger, pathSql: str, nameSql: str, args: Dict[str, Any], codeCompanieDominioXTransnet: Dict[int, str],
                 codeTipoFolhaDominioXTransnet: Dict[int, str], listCPFsPerCompanie: Dict[str, List[str]], dfEventosDePara: pd.DataFrame):
        self.__logger = logger
        self.__pathSql = pathSql
        self.__nameSql = nameSql
        self.__args = args
        self.__codeCompanieDominioXTransnet = codeCompanieDominioXTransnet
        self.__codeTipoFolhaDominioXTransnet = codeTipoFolhaDominioXTransnet
        self.__listCPFsPerCompanie = listCPFsPerCompanie
        self.__dfEventosDePara = dfEventosDePara

        self.__connectionDB = ConnectionDB(self.__logger)
        self.__connection = self.__connectionDB.getConnection()

    def main(self):
        try:
            folderToSaveCsv = os.path.join(folderBeforeSrc, 'data', self.__nameSql.replace('.sql', '.csv'))

            sql = readSql(self.__pathSql, self.__nameSql, self.__args)

            df: pd.DataFrame = pd.read_sql_query(sql, self.__connection)
            df = df.replace({r'\n': '', r'\r': '', r'\t': '', r';': ''}, regex=True)
            df['ID_EMPRESA'] = df['ID_EMPRESA'].replace(self.__codeCompanieDominioXTransnet)
            df['CD_TIPO_FOLHA'] = df['CD_TIPO_FOLHA'].replace(self.__codeTipoFolhaDominioXTransnet)
            df['CD_EVENTO_FOLHA'] = df['CD_EVENTO_FOLHA'].astype(str).str.zfill(4)

            with open(folderToSaveCsv, 'w') as f:
                for _, data in df.iterrows():
                    id_empresa: str = data['ID_EMPRESA']
                    cd_tipo_folha: str = data['CD_TIPO_FOLHA']
                    nr_cpf: str = data['NR_CPF']
                    nr_anomes: str = data['NR_ANOMES']
                    cd_evento_folha: str = data['CD_EVENTO_FOLHA']
                    vl_referencia: str = data['VL_REFERENCIA']
                    vl_valor: str = data['VL_VALOR']
                    dt_pagamento: str = data['DT_PAGAMENTO']
                    dt_importacao: str = data['DT_IMPORTACAO']
                    # ignore cpfs dont exist in transnet
                    if self.__listCPFsPerCompanie[id_empresa].count(nr_cpf) == 0:
                        continue
                    try:
                        cd_evento_folha = self.__dfEventosDePara.loc[(id_empresa, cd_evento_folha)]['Código Evento Transnet']
                    except Exception:
                        pass
                    f.write(f"{id_empresa};{cd_tipo_folha};{nr_cpf};{nr_anomes};{cd_evento_folha};{vl_referencia};{vl_valor};{dt_pagamento};{dt_importacao}\n")
        except Exception as e:
            raise FetchSQLExcepction(e)
        finally:
            self.__connectionDB.closeConnection()


# if __name__ == "__main__":
#     import logging

#     logger = logging.getLogger()
#     handler = logging.StreamHandler()
#     formatter = logging.Formatter(
#         '%(asctime)s %(name)-12s %(levelname)-8s %(message)s')
#     handler.setFormatter(formatter)
#     logger.addHandler(handler)
#     logger.setLevel(logging.DEBUG)

#     main = ExtractData(logger, currentFolder, 'foempregados.sql', {"codi_emp": "3"})
#     print(main.fetchData())
