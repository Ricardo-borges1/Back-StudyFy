/*******************************************************
 * DATA: 01/10/2024
 * Autor: ricardo
 * Versão: 1.0
*******************************************************/

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Selecionar todas as salas
const selectRank = async function () {
    try {
        let sql = `SELECT * FROM tbl_ranks`;
        let rsRanks = await prisma.$queryRawUnsafe(sql);
        return rsRanks;
    } catch (error) {
        console.log(error);
        return false;
    }
};


// Selecionar o último ID inserido
const lastIDRank = async function () {
    try {
        let sql = `SELECT id FROM tbl_ranks ORDER BY id DESC LIMIT 1;`;
        let sqlID = await prisma.$queryRawUnsafe(sql);
        return sqlID;
    } catch (error) {
        return false;
    }
};

// Inserir uma nova sala
const insertRanks = async function (dadosRank) {
    try {
        let sql = `INSERT INTO tbl_ranks (nome, nivel , num_salas) 
                   VALUES (  '${dadosRank.nome}', '${dadosRank.nivel}', '${dadosRank.num_salas}');`;
        let rsInsert = await prisma.$executeRawUnsafe(sql);
        return rsInsert;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// Atualizar uma sala
const updateRank = async function (id, dadosRank) {
    try {
        let sql = `UPDATE tbl_ranks SET nome = '${dadosRank.nome}', 
                                        nivel = '${dadosRank.nivel}', 
                                        num_salas = '${dadosRank.num_salas}'
                   WHERE id = ${id};`;
        let result = await prisma.$executeRawUnsafe(sql);
        return result;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// Deletar uma sala
const deleteRank = async function (id) {
    try {
        let sql = `DELETE FROM tbl_ranks WHERE id = ${id};`;
        let rsDelete = await prisma.$executeRawUnsafe(sql);
        return rsDelete;
    } catch (error) {
        return false;
    }
};

// Selecionar uma sala por ID
const selectByIdRank = async function (id) {
    try {
        let sql = `SELECT * FROM tbl_ranks WHERE id = ${id};`;
        let rsRanks = await prisma.$queryRawUnsafe(sql);
        return rsRanks;
    } catch (error) {
        console.log(error);
        return false;
    }
};

const selectSalaRankByIdAluno = async function (id) {
    try {
        let sql = `SELECT
    vw_alunos_ranking_sala.*,
    tbl_salas.*,
    tbl_imagens_usuario.caminho_imagem,
    tbl_imagens_usuario.nome_imagem
FROM
    vw_alunos_ranking_sala
JOIN
    tbl_salas_alunos ON vw_alunos_ranking_sala.id_aluno = tbl_salas_alunos.aluno_id
JOIN
    tbl_salas ON tbl_salas_alunos.sala_id = tbl_salas.id
JOIN
    tbl_alunos ON vw_alunos_ranking_sala.id_aluno = tbl_alunos.id
JOIN
    tbl_imagens_usuario ON tbl_alunos.imagem_id = tbl_imagens_usuario.id  -- Alterado para tbl_imagens_usuario
WHERE
    tbl_salas_alunos.sala_id = (SELECT sala_id FROM tbl_salas_alunos WHERE aluno_id = ${id})
ORDER BY
    vw_alunos_ranking_sala.pontos_aluno DESC;`;
        let rsRanks = await prisma.$queryRawUnsafe(sql);

        console.log(rsRanks);

        const dadosConvertidos = rsRanks.map(item => ({
            ...item,
            posicao: Number(item.posicao) // Converte BigInt para Number
          }));

        return dadosConvertidos;
    } catch (error) {
        console.log(error);
        return false;
    }
};

module.exports = {
    selectSalaRankByIdAluno,
    selectRank,
    lastIDRank,
    insertRanks,
    updateRank,
    deleteRank,
    selectByIdRank
};
