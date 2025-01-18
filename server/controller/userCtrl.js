const { generateToken } = require("../config/jwtToken");
const User = require("../models/userModel");
const asyncHandler = require("express-async-handler");
const validateMongoDbId = require("../utils/validateMongoDbId");
const { generateRefreshToken } = require("../config/refreshToken");
const jwt = require("jsonwebtoken");

// Create A User
const createUser = asyncHandler(async (req,res) => {
    const { firstName, lastName, email, password, mobile } = req.body;
    const findUser = await User.findOne({email});
    if (findUser) {
        return res.status(400).json({ msg: "User with same email already exists!" });
    }
    if(!findUser) {
        let user = new User({
            firstName,
            lastName,
            email,
            password,
            mobile,
        });
        user = await user.save();
        res.json(user);
    } else {
        throw new Error("User Already Exists");
    }
});

// Login A User
const loginUser = asyncHandler(async (req, res) => {
    const {email, password} = req.body;
    const findUser = await User.findOne({email: email});
    if (findUser && (await findUser.isPasswordMatched(password))) {
        const refreshToken = await generateRefreshToken(findUser?._id);
        const updateUser = await User.findByIdAndUpdate(findUser.id, {
            refreshToken: refreshToken,
        }, 
        {new: true}
        );

        res.cookie('refreshToken', refreshToken, {
            httpOnly: true,
            maxAge: 72 * 60 * 60 * 1000 
        });

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


// Handle Refresh Token
const handleRefreshToken = asyncHandler(async (req, res) => {
    const cookie = req.cookies;
    if (!cookie?.refreshToken) throw new Error("No Refresh Token in Cookies!");

    const refreshToken = cookie.refreshToken;
    const user = await User.findOne({refreshToken});

    if (!user) throw new Error("No Refresh Token in DB or Not Matched!");

    jwt.verify(refreshToken, process.env.JWT_SECRET, (err, decoded) => {
        if (err || user.id !== decoded.id) {
            throw new Error("There is something wrong with refresh token");
        }

        const accessToken = generateToken(user?._id);
        res.json({accessToken});
    });
});


// Logout
const logout = asyncHandler(async (req, res) => {
    const cookie = req.cookies;
    if (!cookie?.refreshToken) throw new Error("No Refresh Token in Cookies");

    const refreshToken = cookie.refreshToken;
    const user = await User.findOne({ refreshToken });

    if (!user) {
      res.clearCookie("refreshToken", {
        httpOnly: true,
        secure: true,
      });
      return res.sendStatus(204); 
    }

    await User.findOneAndUpdate({refreshToken}, {
      refreshToken: "",
    });

    res.clearCookie("refreshToken", {
      httpOnly: true,
      secure: true,
    });

    res.sendStatus(204);
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
    handleRefreshToken,
    logout,
};