/*******************************************************
 * DATA: 01/10/2024
 * Autor: Ricardo
 * Versão: 1.0
*******************************************************/

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Selecionar todas as salas
const selectNivelEmblema = async function () {
    try {
        let sql = `SELECT * FROM tbl_nivel_emblema`;
        let rsNivelEmblema = await prisma.$queryRawUnsafe(sql);
        return rsNivelEmblema;
    } catch (error) {
        console.log(error);
        return false;
    }
};


// Selecionar o último ID inserido
const lastIDNivelEmblema = async function () {
    try {
        let sql = `SELECT id FROM tbl_nivel_emblema ORDER BY id DESC LIMIT 1;`;
        let sqlID = await prisma.$queryRawUnsafe(sql);
        return sqlID;
    } catch (error) {
        return false;
    }
};

// Inserir uma nova sala
const insertNivelEmblema = async function (dadosNivelEmblema) {
    try {
        let sql = `INSERT INTO tbl_nivel_emblema (id_emblema, nivel, meta ) 
                   VALUES (  '${dadosNivelEmblema.id_emblema}', '${dadosNivelEmblema.nivel}', '${dadosNivelEmblema.meta}'  );`;
        let rsInsert = await prisma.$executeRawUnsafe(sql);
        return rsInsert;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// Atualizar uma sala
const updateNivelEmblema = async function (id, dadosNivelEmblema) {
    try {
        let sql = `UPDATE tbl_nivel_emblema SET id_emblema = '${dadosNivelEmblema.id_emblema}', 
                                        nivel = '${dadosNivelEmblema.nivel}', 
                                        meta = '${dadosNivelEmblema.meta}'
                   WHERE id = ${id};`;
        let result = await prisma.$executeRawUnsafe(sql);
        return result;
    } catch (error) {
        console.log(error);
        return false;
    }
};


// Deletar uma sala
const deleteNivelEmblema = async function (id) {
    try {
        let sql = `DELETE FROM tbl_nivel_emblema WHERE id = ${id};`;
        let rsDelete = await prisma.$executeRawUnsafe(sql);
        return rsDelete;
    } catch (error) {
        return false;
    }
};

// Selecionar uma sala por ID
const selectByIdNivelEmblema = async function (id) {
    try {
        let sql = `SELECT * FROM tbl_nivel_emblema WHERE id = ${id};`;
        let rsEmblema = await prisma.$queryRawUnsafe(sql);
        return rsEmblema;
    } catch (error) {
        console.log(error);
        return false;
    }
};

module.exports = {
    selectNivelEmblema,
    lastIDNivelEmblema,
    insertNivelEmblema,
    updateNivelEmblema,
    deleteNivelEmblema,
    selectByIdNivelEmblema
};
