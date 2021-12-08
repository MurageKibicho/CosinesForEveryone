const router = require('express').Router();
const User = require("../model/User");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const{ RegisterValidation, LoginValidation } = require("../routes/validation");

router.post("/register",async (req,res) => 
{    
    //Validate length of email, password
    const { error } = RegisterValidation(req.body);
    if(error)
    {
        return res.status(400).send(error.details[0].message);
    }
    //Check if already registered
    var emailAddress = req.body.email.toLowerCase(); 
    const emailExist = await User.findOne({email: emailAddress});
    if(emailExist)
    {
        return res.status(400).send("Email already exists");
    }

    //Hash password
    const salt = await bcrypt.genSalt(10);
    const hashPassword= await bcrypt.hash(req.body.password,salt);
    const accountNumber = await bcrypt.hash(req.body.email,salt);

    const user = new User({
        name: req.body.name,
        email: emailAddress,
        password: hashPassword,
        nationality: req.body.nationality,
        dateOfBirth : req.body.dateOfBirth,
        accountNumber: accountNumber
    });
    try
    {
        const savedUser = await user.save();
        //Create jwt
        const token = jwt.sign({_id: savedUser.id}, process.env.TOKEN_SECRET);
        
        res.status(200).send({
            email: savedUser.email,
            currentBalance: savedUser.currentBalance,
            accountNumber: savedUser.accountNumber,
            jwt: token,
        });
    }
    catch(err)
    {
        console.log(err);
        res.status(400).send(err);
    }
});

router.post("/login",async (req, res) =>
{
    //Validate length of email, password
    const { error } = LoginValidation(req.body);
    if(error)
    {
        return res.status(400).send(error.details[0].message);
    }

    //Check if email is in database
    const currentUser = await User.findOne({email: req.body.email});
    if(!currentUser)
    {
        return res.status(400).send("Email does not exist");
    }

    //Check if password is correct
    const validPassword = await bcrypt.compare(req.body.password, currentUser.password);
    if(!validPassword)
    {
        return res.status(400).send("Password is wrong");
    }

    //Create and assign a token
    const token = jwt.sign({_id: currentUser.id}, process.env.TOKEN_SECRET);
    res.status(200).send({
        email: currentUser.email.toLowerCase(),
        currentBalance: currentUser.currentBalance,
        accountNumber: currentUser.accountNumber,
        jwt: token,
    });
});

module.exports = router;