/*******************************************************
 * DATA: 01/10/2024
 * Autor: Ricardo
 * Versão: 1.0
*******************************************************/

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Selecionar todas as salas
const selectAlunoEmblema = async function () {
    try {
        let sql = `SELECT * FROM tbl_aluno_emblema`;
        let rsAlunoEmblema = await prisma.$queryRawUnsafe(sql);
        return rsAlunoEmblema;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// Selecionar o último ID inserido
const lastIDAlunoEmblema = async function () {
    try {
        let sql = `SELECT id FROM tbl_aluno_emblema ORDER BY id DESC LIMIT 1;`;
        let sqlID = await prisma.$queryRawUnsafe(sql);
        return sqlID;
    } catch (error) {
        return false;
    }
};

// Inserir uma nova sala
const insertAlunoEmblema = async function (dadosAlunoEmblema) {
    try {
        let sql = `INSERT INTO tbl_aluno_emblema (id_aluno, id_nivel_emblema, data_conquista ) 
                   VALUES (  '${dadosAlunoEmblema.id_aluno}', '${dadosAlunoEmblema.id_nivel_emblema}', '${dadosAlunoEmblema.data_conquista}'  );`;
        let rsInsert = await prisma.$executeRawUnsafe(sql);
        return rsInsert;
    } catch (error) {
        console.log(error);
        return false;
    }
};


// Atualizar uma sala
const updateAlunoEmblema = async function (id, dadosAlunoEmblema) {
    try {
        let sql = `UPDATE tbl_aluno_emblema SET id_aluno = '${dadosAlunoEmblema.id_aluno}', 
                                        id_nivel_emblema = '${dadosAlunoEmblema.id_nivel_emblema}', 
                                        data_conquista = '${dadosAlunoEmblema.data_conquista}'
                   WHERE id = ${id};`;
        let result = await prisma.$executeRawUnsafe(sql);
        return result;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// Deletar uma sala
const deleteAlunoEmblema = async function (id) {
    try {
        let sql = `DELETE FROM tbl_aluno_emblema WHERE id = ${id};`;
        let rsDelete = await prisma.$executeRawUnsafe(sql);
        return rsDelete;
    } catch (error) {
        return false;
    }
};

// Selecionar uma sala por ID
const selectByIdAlunoEmblema = async function (id) {
    try {
        let sql = `SELECT * FROM tbl_aluno_emblema WHERE id = ${id};`;
        let rsEmblema = await prisma.$queryRawUnsafe(sql);
        return rsEmblema;
    } catch (error) {
        console.log(error);
        return false;
    }
};

module.exports = {
    selectAlunoEmblema,
    lastIDAlunoEmblema,
    insertAlunoEmblema,
    updateAlunoEmblema,
    deleteAlunoEmblema,
    selectByIdAlunoEmblema
};
