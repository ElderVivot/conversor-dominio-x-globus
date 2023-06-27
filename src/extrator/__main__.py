# coding: utf-8

from __future__ import annotations
import logging
import os
import sys
import json
from typing import List, Dict
import pandas as pd

currentFolder = os.path.dirname(__file__)
folderSrc = os.path.join(currentFolder, '..')
folderBeforeSrc = os.path.join(currentFolder, '..', '..')
sys.path.append(currentFolder)
sys.path.append(folderSrc)
sys.path.append(folderBeforeSrc)

from extract_movimentacao_folha import ExtractMovimentacaoFolha

logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter(
    '%(asctime)s %(name)-12s %(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)

dataEnv = json.load(open(os.path.join(folderBeforeSrc, 'env.json')))
COMPANIES_MIGRATE: List[int] = dataEnv["companies_migrate"]


class MainExtrator:
    def __init__(self) -> None:
        fileExport = os.path.join(folderBeforeSrc, 'data', 'exportacao_movimentacao_folha.csv')
        if os.path.exists(fileExport) is True:
            os.remove(fileExport)
        self.__codeCompanieDominioXTransnet: Dict[int, str] = {}
        self.__codeTipoFolhaDominioXTransnet: Dict[int, str] = {}
        self.__listCPFsPerCompanie: Dict[str, List[str]] = {}
        self.__dfEventosDePara: pd.DataFrame

    def __getCodeCompanieDominioXTransnet(self):
        df: pd.DataFrame = pd.read_csv(os.path.join(folderBeforeSrc, 'data', '_empresas.csv'), sep=';')
        for _, data in df.iterrows():
            self.__codeCompanieDominioXTransnet[data['CodigoDominio']] = f"{str(data['CodigoTransnet']):0>3}"

    def __getCodeTipoFolhaDominioXTransnet(self):
        df: pd.DataFrame = pd.read_csv(os.path.join(folderBeforeSrc, 'layout', '_tipo_folha.csv'), sep=';')
        for _, data in df.iterrows():
            self.__codeTipoFolhaDominioXTransnet[data['CodigoDominio']] = f"{str(data['CodigoTransnet']):0>2}"

    def __getListCPFsToGenerateData(self):
        dict_df = pd.read_excel(
            io=os.path.join(folderBeforeSrc, 'data', '_relacao_colaboradores_grupo_mobi.xls'),
            sheet_name=None,
            usecols='A,D'
        )

        df: pd.DataFrame = pd.concat([dict_df.get(nameSheet) for nameSheet in dict_df.keys()])
        df['CPF'] = df['CPF'].str.replace('.', '').str.replace('-', '')

        for _, data in df.iterrows():
            codeCompanie = data['Empresa'][0:3]
            cpf = data['CPF']
            if cpf is None:
                continue
            try:
                self.__listCPFsPerCompanie[codeCompanie].append(cpf)
            except Exception:
                self.__listCPFsPerCompanie[codeCompanie] = [cpf]

    def __getDFEventosDePara(self):
        self.__dfEventosDePara: pd.DataFrame = pd.read_excel(
            io=os.path.join(folderBeforeSrc, 'data', '_eventos_de_para_transnet.xlsx'),
            usecols='A,B,C'
        )

        self.__dfEventosDePara['Código Empresa'] = self.__dfEventosDePara['Código Empresa'].astype(str).str.zfill(3)
        self.__dfEventosDePara['Código Evento Domínio'] = self.__dfEventosDePara['Código Evento Domínio'].astype(str).str.zfill(4)
        self.__dfEventosDePara['Código Evento Transnet'] = self.__dfEventosDePara['Código Evento Transnet'].astype(str).str.zfill(4)

        self.__dfEventosDePara.set_index(['Código Empresa', 'Código Evento Domínio'], inplace=True)

    def main(self):
        self.__getCodeCompanieDominioXTransnet()
        self.__getCodeTipoFolhaDominioXTransnet()
        self.__getListCPFsToGenerateData()
        self.__getDFEventosDePara()

        folderSqls = os.path.join(folderSrc, 'sqls')

        for codiEmp in COMPANIES_MIGRATE:
            logger.info(f'Exportando empresa {codiEmp}')
            ExtractMovimentacaoFolha(
                logger,
                folderSqls,
                'exportacao_movimentacao_folha.sql',
                {"codi_emp": str(codiEmp)},
                self.__codeCompanieDominioXTransnet,
                self.__codeTipoFolhaDominioXTransnet,
                self.__listCPFsPerCompanie,
                self.__dfEventosDePara
            ).main()


if __name__ == "__main__":
    MainExtrator().main()
