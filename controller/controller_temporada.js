/*******************************************************
 * DATA: 01/10/2024
 * Autor: Adaptado
 * Versão: 1.0
*******************************************************/

const message = require('./modulo/config.js');
const temporadaDAO = require('../model/temporada.js');

// Função para formatar a data no formato YYYY-MM-DD
function formatarData(data) {
    const ano = data.getFullYear();
    const mes = String(data.getMonth() + 1).padStart(2, '0'); // Meses começam do zero
    const dia = String(data.getDate()).padStart(2, '0');
    return `${ano}-${mes}-${dia}`;
}

// Função para retornar todas as temporadas
const getTemporadas = async function () {
    try {
        let temporadasJSON = {};
        let dadosTemporadas = await temporadaDAO.selectTemporadas();
        
        if (dadosTemporadas) {
            // Formatar as datas das temporadas
            dadosTemporadas = dadosTemporadas.map(temporada => ({
                ...temporada,
                data_inicio: formatarData(new Date(temporada.data_inicio)),
                data_fim: formatarData(new Date(temporada.data_fim)),
            }));

            temporadasJSON.temporadas = dadosTemporadas;
            temporadasJSON.quantidade = dadosTemporadas.length;
            temporadasJSON.status_code = 200;
            return temporadasJSON;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para buscar uma temporada por ID
const getBuscarTemporadaId = async function (id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

        let dadosTemporada = await temporadaDAO.selectByIdTemporada(id);
        if (dadosTemporada) {
            if (dadosTemporada.length > 0) {
                // Formatar as datas
                const temporadaFormatada = {
                    ...dadosTemporada[0],
                    data_inicio: formatarData(new Date(dadosTemporada[0].data_inicio)),
                    data_fim: formatarData(new Date(dadosTemporada[0].data_fim)),
                };
                return { temporada: temporadaFormatada, status_code: 200 };
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

// Função para inserir uma nova temporada
const setInserirNovaTemporada = async function (dadosTemporada, contentType) {
    try {
        if (String(contentType).toLowerCase() !== 'application/json') {
            return message.ERROR_CONTENT_TYPE;
        }

        // Valida campos obrigatórios
        const validationError = validateTemporada(dadosTemporada);
        if (validationError) {
            return validationError;
        }

        // Inserir temporada no banco de dados
        const novaTemporada = await temporadaDAO.insertTemporada(dadosTemporada);
        if (novaTemporada) {
            const ultimoId = await temporadaDAO.lastIDTemporada();
            dadosTemporada.id = ultimoId[0].id;

            // Formatar as datas
            dadosTemporada.data_inicio = formatarData(new Date(dadosTemporada.data_inicio));
            dadosTemporada.data_fim = formatarData(new Date(dadosTemporada.data_fim));

            return {
                temporada: dadosTemporada,
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

// Função para atualizar uma temporada
const setAtualizarTemporada = async function (id, dadosTemporada, contentType) {
    try {
        if (String(contentType).toLowerCase() == 'application/json') {
            if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

            let temporada = await temporadaDAO.selectByIdTemporada(id);
            if (temporada) {
                let temporadaAtualizada = await temporadaDAO.updateTemporada(id, dadosTemporada);
                if (temporadaAtualizada) {
                    // Formatar as datas
                    dadosTemporada.data_inicio = formatarData(new Date(dadosTemporada.data_inicio));
                    dadosTemporada.data_fim = formatarData(new Date(dadosTemporada.data_fim));

                    return {
                        temporada: dadosTemporada,
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

// Função para deletar uma temporada
const setExcluirTemporada = async function (id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

        let comando = await temporadaDAO.deleteTemporada(id);
        if (comando) {
            return message.SUCCESS_DELETED_ITEM;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para validar os campos obrigatórios
function validateTemporada(dadosTemporada) {
    if (!dadosTemporada.data_inicio) {
        return message.ERROR_REQUIRED_FIELDS;
    }
    if (!dadosTemporada.data_fim) {
        return message.ERROR_REQUIRED_FIELDS;
    }
    return null;
}

const setInserirNovaTemporada2 = async function (dadosTemporada, contentType) {
    try {
        // Inserir nova temporada no banco de dados
        const novaTemporada = await temporadaDAO.insertTemporada2();
        if (novaTemporada) {
            return {
                status_code: 201, // Created
                message: 'Temporada criada com sucesso!'
            };
        } else {
            return {
                status_code: 500, // Internal Server Error
                message: 'Erro ao inserir a temporada no banco de dados.'
            };
        }
    } catch (error) {
        console.log(error);
        return {
            status: false,
            status_code: 500, // Internal Server Error
            message: 'Erro interno no servidor.'
        };
    }
};

module.exports = {
    getTemporadas,
    getBuscarTemporadaId,
    setInserirNovaTemporada,
    setAtualizarTemporada,
    setExcluirTemporada,
    setInserirNovaTemporada2
};
