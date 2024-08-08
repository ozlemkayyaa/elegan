const express = require("express");
const { 
    createUser, 
    loginUser, 
    getAllUsers, 
    getUser, 
    deleteUser, 
    updateUser,
    blockUser,
    unblockUser,
} = require("../controller/userCtrl");
const {authMiddleware, isAdmin} = require("../middlewares/authMiddleware");

const authRouter = express.Router();

authRouter.post("/register", createUser);
authRouter.post("/login", loginUser);
authRouter.get('/all-users', getAllUsers);
authRouter.get('/:id', authMiddleware, isAdmin, getUser);
authRouter.delete('/:id', deleteUser);
authRouter.put("/edit-user", authMiddleware, updateUser);
authRouter.put("/block-user/:id", authMiddleware,isAdmin, blockUser);
authRouter.put("/unblock-user/:id", authMiddleware, isAdmin, unblockUser);

module.exports = authRouter;