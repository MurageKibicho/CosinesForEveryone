const router = require('express').Router();
const verify = require("./verifyToken");
const User = require("../model/User");

router.get("/",verify,async (req, res) => {
    const currentUser = await User.findOne({email: req.body.email});
    if(!currentUser)
    {
        return res.status(400).send("Email does not exist");
    }
    try
    {
        res.status(200).send({
            accountNumber: currentUser.id,
            name:currentUser.name,
            currentBalance: currentUser.currentBalance,
        });
    }catch(err)
    {
        console.log(err);
        res.status(400).send(err);
    }
    
});

module.exports = router;