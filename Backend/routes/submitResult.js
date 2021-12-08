const router = require('express').Router();
const verify = require("./verifyToken");
const User = require("../model/User");

router.put("/",verify,async(req, res) => {
    //Filter request body 
    for(var key in req.body)
    {
        if(key == "imageID" || key == "email")
        {
            //Do nothing
        }
        else
        {
            delete req.body[key];
        }
    }    
    try
    {
        const currentUser = await User.findOne({email: req.body.email});
        if(!currentUser)
        {
            return res.status(400).send("Unable to update");
        }
        if(!currentUser.imageQueue.includes(req.body.imageID))
        {
            await currentUser.updateOne({ $push: { imageQueue: req.body.imageID } });
            res.status(200).send("Updated");
        }
        else
        {
            res.status(400).send("You've already sent this");
        }
            
    }catch(err)
    {
        console.log(err);
        res.status(400).send(err);
    }
    //res.send(req.user);
});

router.put("/passwordChange",verify,async(req, res) => {
    //Filter request body 
    for(var key in req.body)
    {
        if(key == "nationality" || key == "email")
        {
            //Do nothing
        }
        else
        {
            delete req.body[key];
        }
    }    
    try
    {
        const currentUser = await User.findOneAndUpdate(
        {email: req.body.email},
        {
            $set:req.body,
        });
        if(!currentUser)
        {
            return res.status(400).send("Unable to update");
        }
            res.status(200).send("Here");
    }catch(err)
    {
        console.log(err);
        res.status(400).send(err);
    }
    //res.send(req.user);
});

module.exports = router;