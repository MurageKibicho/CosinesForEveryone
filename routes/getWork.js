const router = require('express').Router();
const verify = require("./verifyToken");
const path = require('path');

router.get("/",verify,(req, res) => {
    var filePath = path.join(__dirname, "bicho3.bae");
    res.download(filePath);
    //res.send(req.user);
});

module.exports = router;