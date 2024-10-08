/*******************************************************
 * DATA: 01/10/2024
 * Autor: ricardo borges
 * Versão: 1.0
*******************************************************/

const message = require('./modulo/config.js');
const nivelEmblemaDAO = require('../model/nivelEmblema.js');

// Função para retornar todas as salas
const getNivelEmblema = async function () {
    try {
        let nivelEmblemaJSON = {};
        let dadosNivelEmblema = await nivelEmblemaDAO.selectNivelEmblema();
        
        if (dadosNivelEmblema) {
            nivelEmblemaJSON.nivelEmblema = dadosNivelEmblema;
            nivelEmblemaJSON.quantidade = dadosNivelEmblema.length;
            nivelEmblemaJSON.status_code = 200;
            return nivelEmblemaJSON;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para buscar uma sala por ID
const getBuscarNivelEmblemaId = async function (id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

        let dadosNivelEmblema = await nivelEmblemaDAO.selectByIdNivelEmblema(id);
        if (dadosNivelEmblema) {
            if (dadosNivelEmblema.length > 0) {
                return { nivel_emblema: dadosNivelEmblema, status_code: 200 };
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
const setInserirNovoNivelEmblema = async function (dadosNivelEmblema, contentType) {
    try {
        if (String(contentType).toLowerCase() !== 'application/json') {
            return message.ERROR_CONTENT_TYPE;
        }

        // Inserir sala no banco de dados
        const novoNivelEmblema = await nivelEmblemaDAO.insertNivelEmblema(dadosNivelEmblema);
        if (novoNivelEmblema) {
            const ultimoId = await nivelEmblemaDAO.lastIDNivelEmblema();
            dadosNivelEmblema.id = ultimoId[0].id;

            return {
                nivel_emblema: dadosNivelEmblema,
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
const setAtualizarNivelEmblema = async function (id, dadosNivelEmblema, contentType) {
    try {
        if (String(contentType).toLowerCase() == 'application/json') {
            if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

            let emblema = await nivelEmblemaDAO.selectByIdNivelEmblema(id);
            if (emblema) {
                let emblemaAtualizado = await nivelEmblemaDAO.updateNivelEmblema(id, dadosNivelEmblema);
                if (emblemaAtualizado) {
                    return {
                        nivel_emblema: dadosNivelEmblema,
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
const setExcluirNivelEmblema = async function (id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

        let comando = await nivelEmblemaDAO.deleteNivelEmblema(id);
        if (comando) {
            return message.SUCCESS_DELETED_ITEM;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.log(error);
        
        return message.ERROR_INTERNAL_SERVER;
    }
};



module.exports = {
    getNivelEmblema,
    getBuscarNivelEmblemaId,
    setInserirNovoNivelEmblema,
    setAtualizarNivelEmblema,
    setExcluirNivelEmblema,
};
