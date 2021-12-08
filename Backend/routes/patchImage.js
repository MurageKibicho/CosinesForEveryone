const router = require('express').Router();
const verify = require("./verifyToken");
const User = require("../model/User");

router.patch("/",verify,async (req, res) => 
{ 
    try
    {
        const imageID = req.body.imagesCompressed;
        const currentUser = await User.findOneAndUpdate(
            {email: req.body.email},
            {imageID}
            );
        res.status(200).send({
            accountNumber: currentUser.id,
            name:currentUser.name,
            currentBalance: currentUser.currentBalance,
            imagesCompressed: currentUser.imagesCompressed,
            productivity: currentUser.dataUsed
        });
    }catch(err)
    {
        console.log(err);
        res.status(400).send(err);
    }
    
});

module.exports = router;