const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const morgan = require("morgan");//HTTP request logger
const app = express();

//Import routes
const authRoute = require("./routes/auth");
const getUserDetailsRoute = require("./routes/getUserDetails");
const getPendingRoute = require("./routes/getPending");
const getApprovedRoute = require("./routes/getApproved");
const getWorkRoute = require("./routes/getWork");
const getAvailableRoute = require("./routes/getAvailability");
const putResults = require("./routes/submitResult.js");
//Middleware
app.use(express.json());
app.use(morgan("common"));


dotenv.config();

//Connect to DB
mongoose.connect(
    process.env.DB_CONNECT,
    {
        useNewUrlParser:true,
        useUnifiedTopology: true,
    }).then(() =>console.log("Database connected"))
    .catch(err => console.log(err));

app.use("/api/user", authRoute);
app.use("/api/getwork", getWorkRoute);
app.use("/api/getUserDetails", getUserDetailsRoute);
app.use("/api/getPending", getPendingRoute);
app.use("/api/getApproved", getApprovedRoute);
app.use("/api/getAvailability", getAvailableRoute);
app.use("/api/putSubmit", putResults);
app.listen(3000, () => console.log("Running at 3000"));