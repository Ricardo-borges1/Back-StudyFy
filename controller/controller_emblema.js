/*******************************************************
 * DATA: 01/10/2024
 * Autor: ricardo borges
 * Versão: 1.0
*******************************************************/

const message = require('./modulo/config.js');
const emblemaDAO = require('../model/emblema.js');

// Função para retornar todas as salas
const getEmblema = async function () {
    try {
        let emblemaJSON = {};
        let dadosEmblema = await emblemaDAO.selectEmblema();
        
        if (dadosEmblema) {
            emblemaJSON.emblema = dadosEmblema;
            emblemaJSON.quantidade = dadosEmblema.length;
            emblemaJSON.status_code = 200;
            return emblemaJSON;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para buscar uma sala por ID
const getBuscarEmblemaId = async function (id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

        let dadosEmblema = await emblemaDAO.selectByIdEmblema(id);
        if (dadosEmblema) {
            if (dadosEmblema.length > 0) {
                return { emblema: dadosEmblema, status_code: 200 };
            } else {
                return message.ERROR_NOT_FOUND;
            }
        } else {
            return message.ERROR_INTERNAL_SERVER_DB;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para inserir uma nova sala
const setInserirNovoEmblema = async function (dadosEmblema, contentType) {
    try {
        if (String(contentType).toLowerCase() !== 'application/json') {
            return message.ERROR_CONTENT_TYPE;
        }

        // Inserir sala no banco de dados
        const novoEmblema = await emblemaDAO.insertEmblema(dadosEmblema);
        if (novoEmblema) {
            const ultimoId = await emblemaDAO.lastIDEmblema();
            dadosEmblema.id = ultimoId[0].id;

            return {
                emblema: dadosEmblema,
                status_code: message.SUCCESS_CREATED_ITEM.status_code,
                message: message.SUCCESS_CREATED_ITEM.message
            };
        } else {
            return message.ERROR_INTERNAL_SERVER_DB;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para atualizar uma sala
const setAtualizarEmblema = async function (id, dadosEmblema, contentType) {
    try {
        if (String(contentType).toLowerCase() == 'application/json') {
            if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

            let emblema = await emblemaDAO.selectByIdEmblema(id);
            if (emblema) {
                let emblemaAtualizado = await emblemaDAO.updateEmblema(id, dadosEmblema);
                if (emblemaAtualizado) {
                    return {
                        emblema: dadosEmblema,
                        status_code: message.SUCCESS_UPDATED_ITEM.status_code,
                        message: message.SUCCESS_UPDATED_ITEM.message
                    };
                } else {
                    return message.ERROR_NOT_FOUND;
                }
            } else {
                return message.ERROR_NOT_FOUND;
            }
        } else {
            return message.ERROR_CONTENT_TYPE;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para deletar uma sala
const setExcluirEmblema = async function (id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

        let comando = await emblemaDAO.deleteEmblema(id);
        if (comando) {
            return message.SUCCESS_DELETED_ITEM;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER;
    }
};



module.exports = {
    getEmblema,
    getBuscarEmblemaId,
    setInserirNovoEmblema,
    setAtualizarEmblema,
    setExcluirEmblema,
};
