const router = require('express').Router();
const verify = require("./verifyToken");
const path = require('path');

router.get("/",verify,(req, res) => {

    try
    {
        res.status(200).send({
            width : 2048,
            height : 1152 
        });
    }
    catch(err)
    {
        console.log(err);
        res.status(400).send(err);
    }
    
    //res.send(req.user);
});

module.exports = router;
//width : 3768,height : 3736 