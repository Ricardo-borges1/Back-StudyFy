/*******************************************************
 * DATA: 12/11/2024
 * Autor: Matheus Noronha
 * Versão: 1.0
*******************************************************/

// Importa a biblioteca do @prisma/client
const { PrismaClient } = require('@prisma/client');

// Instância da classe PrismaClient
const prisma = new PrismaClient();

// Função para selecionar ordem de palavra pelo ID
const selectAllImgs = async function() {
    try {
        let sql = `select * from tbl_imagens_grupo_mentoria;`;
        let resultado = await prisma.$queryRawUnsafe(sql);
        return resultado;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// Exporta as funções
module.exports = {
    selectAllImgs
};
