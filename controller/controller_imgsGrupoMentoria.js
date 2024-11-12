/*******************************************************
 * DATA: 12/11/2024
 * Autor: Matheus Noronha
 * Versão: 1.0
*******************************************************/

// Importa as mensagens e os DAOs
const imgsGrupoMentoriaDAO = require ('../model/imagensGrupoMentoria.js')
const message = require('./modulo/config.js');


const getListarImgs = async function() {
    try {
        // Criar o objeto JSON
        let imgsJSON = {};
        
        // Chamar a função do DAO para retornar os dados da tabela de produtos
        
        let imgs = await imgsGrupoMentoriaDAO.selectAllImgs();

        // Validação para verificar se existem dados 
        if (imgs) {
            // Criar o JSON para devolver para o APP
            imgsJSON.imagens = imgs;
            imgsJSON.quantidade = imgs.length;
            imgsJSON.status_code = 200;
            return imgsJSON;
        } else {
            return message.ERROR_NOT_FOUND;
        } 
    } catch (error) {
        console.log(error);
        return message.ERROR_INTERNAL_SERVER;
    }
}


module.exports = {
    getListarImgs
};

