const mongoose = require("mongoose");

// MongoDB ID'sinin geçerli olup olmadığını kontrol eden fonksiyon
const validateMongoDbId = (id) => {
    // ObjectId'nin geçerli olup olmadığını kontrol eder
    const isValid = mongoose.Types.ObjectId.isValid(id);
    if(!isValid) throw new Error("Not a valid mongoDB id!");
};

module.exports = validateMongoDbId;