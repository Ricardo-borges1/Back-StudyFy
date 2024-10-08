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



const selectEmblemasAluno = async function (idAluno) {
    try {
        const sql = `
        SELECT 
            emblema.id AS emblema_id,
            emblema.nome AS emblema_nome,
            nivel_atual.nivel AS nivel_atual,
            nivel_atual.meta AS meta_atual,
            proximo_nivel.nivel AS proximo_nivel,
            proximo_nivel.meta AS meta_proxima
        FROM 
            tbl_emblema AS emblema
        JOIN 
            tbl_nivel_emblema AS nivel_atual ON emblema.id = nivel_atual.id_emblema
        LEFT JOIN 
            tbl_nivel_emblema AS proximo_nivel ON emblema.id = proximo_nivel.id_emblema AND proximo_nivel.nivel = nivel_atual.nivel + 1
        WHERE 
            nivel_atual.id IN (
                SELECT id_nivel_emblema 
                FROM tbl_aluno_emblema 
                WHERE id_aluno = ${idAluno}  -- Substitua diretamente pelo ID do aluno
            )
        AND 
            nivel_atual.nivel = (
                SELECT MAX(nivel) 
                FROM tbl_nivel_emblema 
                WHERE id_emblema = emblema.id AND 
                      id IN (
                          SELECT id_nivel_emblema 
                          FROM tbl_aluno_emblema 
                          WHERE id_aluno = ${idAluno}  -- Substitua diretamente pelo ID do aluno
                      )
            );
        `;
        
        let emblemas = await prisma.$queryRawUnsafe(sql);
        
        return emblemas;

    } catch (error) {
        console.log(error);
        return false;
    }
};


const selectEmblemasNaoConquistados = async function (idAluno) {
    try {
        const sql = `
        SELECT 
            n.id AS nivel_emblema_id,
            n.nivel,
            e.id AS emblema_id,
            e.nome AS emblema_nome,
            n.meta
        FROM 
            tbl_nivel_emblema n
        JOIN 
            tbl_emblema e ON n.id_emblema = e.id
        WHERE 
            n.nivel = 1 
            AND n.id NOT IN (
                SELECT id_nivel_emblema 
                FROM tbl_aluno_emblema 
                WHERE id_aluno = ${idAluno}  -- Placeholder para o ID do aluno
            );
        `;
        
        // Executa a consulta com o ID do aluno
        let emblemasNaoConquistados = await prisma.$queryRawUnsafe(sql, idAluno);
        
        return emblemasNaoConquistados;

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
    selectByIdEmblema,
    selectEmblemasAluno,
    selectEmblemasNaoConquistados
};
