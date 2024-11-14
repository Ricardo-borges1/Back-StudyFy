/*******************************************************
 * DATA: 05/09/2024
 * Autor: Ricardo Borges
 * Versão: 2.0
*******************************************************/

// Importa as mensagens e os DAOs
const { Prisma } = require('@prisma/client');
const duvidaCompartilhadaDAO = require ('../model/duvidaCompartilhada.js')
const message = require('./modulo/config.js');

// Função para listar todas as dúvidas
const getListarAllDuvidas = async function() {
    try {
        let duvidasJSON = {};
        let dadosDuvidas = await duvidaCompartilhadaDAO.selectAllDuvidas();

        if (dadosDuvidas) {
            duvidasJSON.membros = dadosDuvidas;
            duvidasJSON.quantidade = dadosDuvidas.length;
            duvidasJSON.status_code = 200;
            return duvidasJSON;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para excluir dúvida compartilhada
const setExcluirDuvidaCompartilhada = async function(id) {
    try {
        let idDuvidaCompartilhada = id;

        if (idDuvidaCompartilhada === '' || idDuvidaCompartilhada === undefined || isNaN(idDuvidaCompartilhada)) {
            return message.ERROR_INVALID_ID; // 400
        } else {
            let duvidaCompartilhadaeletado = await duvidaCompartilhadaDAO.deleteDuvidaCompartilhada(idDuvidaCompartilhada);

            if (duvidaCompartilhadaeletado) {
                return message.SUCCESS_DELETED_ITEM;
            } else {
                return message.ERROR_INTERNAL_SERVER_DB; // 500
            }
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER; // 500
    }
};

// Função para listar dúvidas respondidas
const getListarDuvidasRespondidas = async function() {
    try {
        let duvidasJSON = {};
        let dadosDuvidas = await duvidaCompartilhadaDAO.selectDuvidasRespondidas();

        if (dadosDuvidas) {
            duvidasJSON.membros = dadosDuvidas;
            duvidasJSON.quantidade = dadosDuvidas.length;
            duvidasJSON.status_code = 200;
            return duvidasJSON;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para listar dúvidas não respondidas
const getListarDuvidasNaoRespondidas = async function() {
    try {
        let duvidasJSON = {};
        let dadosDuvidas = await duvidaCompartilhadaDAO.selectDuvidasNaoRespondidas();

        if (dadosDuvidas) {
            duvidasJSON.membros = dadosDuvidas;
            duvidasJSON.quantidade = dadosDuvidas.length;
            duvidasJSON.status_code = 200;
            return duvidasJSON;
        } else {
            return message.ERROR_NOT_FOUND;
        }
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Função para inserir nova dúvida
const setInserirNovaDuvida = async function(dadosDuvida, contentType) {
    try {
        if (String(contentType).toLowerCase() === 'application/json') {
            if (!dadosDuvida.conteudo || dadosDuvida.conteudo.length > 500 || !dadosDuvida.data_envio || dadosDuvida.data_envio.length > 45 || !dadosDuvida.membro_id || typeof dadosDuvida.membro_id !== 'number') {
                return { error: "Campos obrigatórios inválidos." };
            } else {
                let novaDuvida = await duvidaCompartilhadaDAO.inserirDuvidaCompartilhada(dadosDuvida);
                
                if (novaDuvida) {
                    return {
                        status: "Dúvida criada com sucesso!",
                        status_code: 201,
                    };
                } else {
                    return { error: "Erro interno ao inserir na base de dados." };
                }
            }
        } else {
            return { error: "Tipo de conteúdo não suportado." };
        }
    } catch (erro) {
        console.log(erro);
        return { error: "Erro interno do servidor." };
    }
};

// Função para buscar dúvidas por ID de membro
const getBuscarDuvidasPorMembro = async function(membroId) {
    try {
        if (!membroId || isNaN(membroId)) {
            return message.ERROR_INVALID_ID; // 400
        } else {
            let dadosDuvidas = await duvidaCompartilhadaDAO.getDuvidasPorMembro(membroId);

            if (dadosDuvidas) {
                if (dadosDuvidas.length > 0) {
                    return {
                        duvidas: dadosDuvidas,
                        status_code: 200,
                    };
                } else {
                    return message.ERROR_NOT_FOUND; // 404, se não encontrar dúvidas
                }
            } else {
                return message.ERROR_INTERNAL_SERVER_DB; // 500, erro na consulta
            }
        }
    } catch (error) {
        console.error(error);
        return message.ERROR_INTERNAL_SERVER; // 500, erro interno
    }
};

// Função para buscar dúvidas por grupo de mentoria
const getBuscarDuvidasPorGrupoMentoria = async function(grupoId) {
    try {
        if (!grupoId || isNaN(grupoId)) {
            return message.ERROR_INVALID_ID; // 400
        } else {
            // Chama a função do DAO para buscar as dúvidas do grupo de mentoria
            let dadosDuvidas = await duvidaCompartilhadaDAO.getDuvidasPorGrupoMentoria(grupoId);

            if (dadosDuvidas) {
                if (dadosDuvidas.length > 0) {
                    return {
                        duvidas: dadosDuvidas,
                        status_code: 200,
                    };
                } else {
                    return message.ERROR_NOT_FOUND; // 404, se não encontrar dúvidas
                }
            } else {
                return message.ERROR_INTERNAL_SERVER_DB; // 500, erro na consulta
            }
        }
    } catch (error) {
        console.error(error);
        return message.ERROR_INTERNAL_SERVER; // 500, erro interno
    }
};

// Função para atualizar dúvida compartilhada
const setAtualizarDuvida = async function(id, dadosDuvida, contentType) {
    try {
        let idDuvida = id;

        if (idDuvida === '' || idDuvida === undefined || isNaN(idDuvida) || idDuvida === null) {
            return message.ERROR_INVALID_ID;
        } else {
            if (String(contentType).toLowerCase() === 'application/json') {
                let updateDuvidaJSON = {};
                
                if (dadosDuvida.conteudo === '' || dadosDuvida.conteudo === undefined || dadosDuvida.conteudo === null) {
                    return message.ERROR_REQUIRED_FIELDS;
                } else {
                    let updateResult = await  duvidaCompartilhadaDAO.updateDuvidaCompartilhada(idDuvida, dadosDuvida);

                    if (updateResult) {
                        updateDuvidaJSON.duvida = dadosDuvida;
                        updateDuvidaJSON.status = message.SUCCESS_UPDATED_ITEM.status;
                        updateDuvidaJSON.status_code = message.SUCCESS_UPDATED_ITEM.status_code;
                        updateDuvidaJSON.message = message.SUCCESS_UPDATED_ITEM.message;
                        
                        return updateDuvidaJSON;
                    } else {
                        return message.ERROR_INTERNAL_SERVER_DB;
                    }
                }
            } else {
                return message.ERROR_CONTENT_TYPE;
            }
        }
    } catch (error) {
        console.log(error);
        
        return message.ERROR_INTERNAL_SERVER;
    }
};

// Exporta as funções da controller
module.exports = {
    getListarAllDuvidas,
    getListarDuvidasRespondidas,
    getListarDuvidasNaoRespondidas,
    setInserirNovaDuvida,
    getBuscarDuvidasPorMembro,
    setAtualizarDuvida,
    setExcluirDuvidaCompartilhada,
    getBuscarDuvidasPorGrupoMentoria // Função para listar dúvidas por grupo de mentoria
};
