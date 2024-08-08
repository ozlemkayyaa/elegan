const { generateToken } = require("../config/jwtToken");
const User = require("../models/userModel");
const asyncHandler = require("express-async-handler");
const validateMongoDbId = require("../utils/validateMongoDbId");

// Create A User
const createUser = asyncHandler(async (req,res) => {
    // Veritabanında bu e-posta adresine sahip bir kullanıcı olup olmadığını kontrol eder.
    const email = req.body.email;
    const findUser = await User.findOne({email: email});
    // Kullanıcı bulunamadıysa
    if(!findUser) {
        // Yeni kullanıcı oluştur
        const newUser = await User.create(req.body);
        res.json(newUser);
    } else {
        throw new Error("User Already Exists");
    }
});

// Login A User
const loginUser = asyncHandler(async(req, res) => {
    const {email, password} = req.body;
    // check if user exists or not
    const findUser = await User.findOne({email: email});
    if(findUser && (await findUser.isPasswordMatched(password))) {
        res.json({
            _id: findUser?._id,
            firstName: findUser?.firstName,
            lastName: findUser?.lastName,
            email: findUser?.email,
            mobile: findUser?.mobile,
            address: findUser?.address,
            token: generateToken(findUser?._id)
        });
    } else {
        throw new Error("Invalid Credentials");
    }
});

// Get All Users
const getAllUsers = asyncHandler(async(req, res) => {
    try {
        const getUsers = await User.find();
        res.json(getUsers);
    } catch (error) {
        throw new Error(error);
    }
});

// Update A User
const updateUser = asyncHandler(async(req, res) =>  {
    const { _id } = req.user;
    validateMongoDbId(_id);
    try {
        const updatedUser = await User.findByIdAndUpdate(_id, {
            firstName: req?.body.firstName,
            lastName: req?.body.lastName,
            email: req?.body.email,
            mobile: req?.body.mobile,
            address: req?.body.address,
            type: req?.body.type,
        }, {
            new: true,
        });
        res.json({updatedUser});
    } catch (error) {
        throw new Error(error);
    }
});

// Get A Single User
const getUser = asyncHandler(async(req, res) =>  {
    const { id } = req.params;
    validateMongoDbId(id);
    try {
        const getTheUser = await User.findById(id);
        res.json({getTheUser});
    } catch (error) {
        throw new Error(error);
    }
});

// Delete A User
const deleteUser = asyncHandler(async(req, res) =>  {
    const { id } = req.params;
    validateMongoDbId(id);
    try {
        const deletedUser = await User.findByIdAndDelete(id);
        res.json({deletedUser});
    } catch (error) {
        throw new Error(error);
    }
});

// Block A User
const blockUser = asyncHandler(async (req, res) => {
    const { id } = req.params;
    validateMongoDbId(id);
    try {
        const block = await User.findByIdAndUpdate(id, {
            isBlocked: true,
        }, {
            new: true,
        });
        res.json({block});
    } catch (error) {
        throw new Error(error);
    }
});

// Unblock A User
const unblockUser = asyncHandler(async (req, res) => {
    const { id } = req.params;
    validateMongoDbId(id);
    try {
        const unblock = await User.findByIdAndUpdate(id, {
            isBlocked: false,
        }, {
            new: true,
        });
        res.json({unblock});
    } catch (error) {
        throw new Error(error);
    }
});

module.exports = {
    createUser, 
    loginUser, 
    getAllUsers, 
    getUser, 
    deleteUser,
    updateUser,
    blockUser,
    unblockUser,
};