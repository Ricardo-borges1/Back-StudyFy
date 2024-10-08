/*******************************************************
 * DATA: 01/10/2024
 * Autor: Ricardo Borges
 * Versão: 1.0
*******************************************************/

const message = require('./modulo/config.js');
const alunoEmblemaDAO = require('../model/alunoEmblema.js');

// Função auxiliar para validar a data de nascimento
function isValidDate(dateString) {
    const regex = /^\d{4}-\d{2}-\d{2}$/;
    if (!regex.test(dateString)) {
        return false;
    }

    const [year, month, day] = dateString.split('-').map(Number);
    if (year < 1900) return false;
    if (month < 1 || month > 12) return false;

    const daysInMonth = new Date(year, month, 0).getDate();
    if (day < 1 || day > daysInMonth) return false;

    return true;
}

// Função para formatar a data
function formatarData(data) {
    if (!data) return null;

    if (data instanceof Date) {
        return data.toISOString().split('T')[0];
    }

    if (typeof data === 'string') {
        const dateObj = new Date(data);
        if (!isNaN(dateObj.getTime())) {
            return dateObj.toISOString().split('T')[0];
        }
        return null;
    }

    return null;
}

// Função para retornar todas as emblemas
const getAlunoEmblema = async function () {
    try {
        let alunoEmblemaJSON = {};
        let dadosAlunoEmblema = await alunoEmblemaDAO.selectAlunoEmblema();

        if (dadosAlunoEmblema) {
            dadosAlunoEmblema.forEach(emblema => {
                emblema.data_conquista = formatarData(emblema.data_conquista);
            });
            alunoEmblemaJSON.aluno_emblema = dadosAlunoEmblema;
            alunoEmblemaJSON.quantidade = dadosAlunoEmblema.length;
            alunoEmblemaJSON.status_code = 200;
            return alunoEmblemaJSON;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para buscar um emblema por ID
const getBuscarAlunoEmblemaId = async function (id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

        let dadosAlunoEmblema = await alunoEmblemaDAO.selectByIdAlunoEmblema(id);
        if (dadosAlunoEmblema && dadosAlunoEmblema.length > 0) {
            dadosAlunoEmblema[0].data_conquista = formatarData(dadosAlunoEmblema[0].data_conquista); // Formata a data aqui
            return { aluno_emblema: dadosAlunoEmblema[0], status_code: 200 };
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para inserir um novo emblema
const setInserirNovoAlunoEmblema = async function (dadosAlunoEmblema, contentType) {
    try {
        if (String(contentType).toLowerCase() !== 'application/json') {
            return message.ERROR_CONTENT_TYPE;
        }

        // Valida a data de conquista antes de inserir
        if (!isValidDate(dadosAlunoEmblema.data_conquista)) {
            return message.ERROR_INVALID_DATE;
        }

        // Formata a data antes de inserir
        dadosAlunoEmblema.data_conquista = formatarData(dadosAlunoEmblema.data_conquista);

        const novoAlunoEmblema = await alunoEmblemaDAO.insertAlunoEmblema(dadosAlunoEmblema);
        if (novoAlunoEmblema) {
            const ultimoId = await alunoEmblemaDAO.lastIDAlunoEmblema();
            dadosAlunoEmblema.id = ultimoId[0].id;

            return {
                aluno_emblema: dadosAlunoEmblema,
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

// Função para atualizar um emblema
const setAtualizarAlunoEmblema = async function (id, dadosAlunoEmblema, contentType) {
    try {
        if (String(contentType).toLowerCase() == 'application/json') {
            if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

            let emblema = await alunoEmblemaDAO.selectByIdAlunoEmblema(id);
            if (emblema) {
                // Valida a data de conquista antes de atualizar
                if (!isValidDate(dadosAlunoEmblema.data_conquista)) {
                    return message.ERROR_INVALID_DATE;
                }

                // Formata a data antes de atualizar
                dadosAlunoEmblema.data_conquista = formatarData(dadosAlunoEmblema.data_conquista);

                let emblemaAtualizado = await alunoEmblemaDAO.updateAlunoEmblema(id, dadosAlunoEmblema);
                if (emblemaAtualizado) {
                    return {
                        aluno_emblema: dadosAlunoEmblema,
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

// Função para deletar um emblema
const setExcluirAlunoEmblema = async function (id) {
    try {
        if (!id || isNaN(id)) return message.ERROR_INVALID_ID;

        let comando = await alunoEmblemaDAO.deleteAlunoEmblema(id);
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
    getAlunoEmblema,
    getBuscarAlunoEmblemaId,
    setInserirNovoAlunoEmblema,
    setAtualizarAlunoEmblema,
    setExcluirAlunoEmblema,
    formatarData
};
