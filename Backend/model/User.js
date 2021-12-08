const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name : 
    {
        type: String,
        required: true,
        min: 6,
        max: 255,
        unique: false
    },
    email:
    {
        type: String,
        required: true,
        min: 6,
        max: 255,
        unique: true
    },
    password:
    {
        type: String,
        required: true,
        max: 1024,
        min: 6,
        unique: false
    },
    nationality: 
    {
        type: String,
        required: true,
        unique: false
    },
    dateOfBirth: 
    {
        type: String,
        required: true,
        unique: false
    },
    accountNumber: 
    {
        type: String,
        required: true,
        unique: true
    },
    currentBalance: 
    {
        type: String,
        default: 0,
        unique: false
    },
    imagesCompressed: 
    {
        type: Array,
        default: [],
        unique: false
    },
    imageQueue: 
    {
        type: Array,
        default: [],
        unique: false
    },
    date: 
    {
        type: String,
        default: Date.now,
        unique: false
    },
    
});

module.exports = mongoose.model("User", userSchema);