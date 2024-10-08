/*******************************************************
 * DATA: 01/10/2024
 * Autor: Ricardo
 * Versão: 1.0
*******************************************************/

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Selecionar todas as salas
const selectEmblema = async function () {
    try {
        let sql = `SELECT * FROM tbl_emblema`;
        let rsEmblema = await prisma.$queryRawUnsafe(sql);
        return rsEmblema;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// Selecionar o último ID inserido
const lastIDEmblema = async function () {
    try {
        let sql = `SELECT id FROM tbl_emblema ORDER BY id DESC LIMIT 1;`;
        let sqlID = await prisma.$queryRawUnsafe(sql);
        return sqlID;
    } catch (error) {
        return false;
    }
};

// Inserir uma nova sala
const insertEmblema = async function (dadosEmblema) {
    try {
        let sql = `INSERT INTO tbl_emblema (nome, descricao, icone ) 
                   VALUES (  '${dadosEmblema.nome}', '${dadosEmblema.descricao}', '${dadosEmblema.icone}'  );`;
        let rsInsert = await prisma.$executeRawUnsafe(sql);
        return rsInsert;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// Atualizar uma sala
const updateEmblema = async function (id, dadosEmblema) {
    try {
        let sql = `UPDATE tbl_emblema SET nome = '${dadosEmblema.nome}', 
                                        descricao = '${dadosEmblema.descricao}', 
                                        icone = '${dadosEmblema.icone}'
                   WHERE id = ${id};`;
        let result = await prisma.$executeRawUnsafe(sql);
        return result;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// Deletar uma sala
const deleteEmblema = async function (id) {
    try {
        let sql = `DELETE FROM tbl_emblema WHERE id = ${id};`;
        let rsDelete = await prisma.$executeRawUnsafe(sql);
        return rsDelete;
    } catch (error) {
        return false;
    }
};

// Selecionar uma sala por ID
const selectByIdEmblema = async function (id) {
    try {
        let sql = `SELECT * FROM tbl_emblema WHERE id = ${id};`;
        let rsEmblema = await prisma.$queryRawUnsafe(sql);
        return rsEmblema;
    } catch (error) {
        console.log(error);
        return false;
    }
};

module.exports = {
    selectEmblema,
    lastIDEmblema,
    insertEmblema,
    updateEmblema,
    deleteEmblema,
    selectByIdEmblema
};
