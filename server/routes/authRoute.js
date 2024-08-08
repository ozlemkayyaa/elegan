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
    handleRefreshToken,
    logout,
} = require("../controller/userCtrl");
const {authMiddleware, isAdmin} = require("../middlewares/authMiddleware");

const authRouter = express.Router();

authRouter.post("/register", createUser);
authRouter.post("/login", loginUser);
authRouter.get('/all-users', getAllUsers);
authRouter.get("/refresh-token", handleRefreshToken);
authRouter.get("/logout", logout);

authRouter.get('/:id', authMiddleware, isAdmin, getUser);
authRouter.delete('/:id', deleteUser);
authRouter.put("/edit-user", authMiddleware, updateUser);
authRouter.put("/block-user/:id", authMiddleware,isAdmin, blockUser);
authRouter.put("/unblock-user/:id", authMiddleware, isAdmin, unblockUser);

module.exports = authRouter;