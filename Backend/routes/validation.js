const Joi = require("joi");

const RegisterValidation = req =>
{
    const schema = Joi.object({
        name: Joi.string().min(6).required(),
        email: Joi.string().min(6).required().email(),
        password: Joi.string().min(6).required()  
    });
    return schema.validate(req.body); 
}

const LoginValidation = req =>
{
    const schema = Joi.object({
        email: Joi.string().min(6).required().email(),
        password: Joi.string().min(6).required()  
    });
    return schema.validate(req.body); 
}

module.exports.RegisterValidation = RegisterValidation;
module.exports.LoginValidation = LoginValidation;;