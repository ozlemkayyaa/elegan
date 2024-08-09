const { generateToken } = require("../config/jwtToken");
const User = require("../models/userModel");
const asyncHandler = require("express-async-handler");
const validateMongoDbId = require("../utils/validateMongoDbId");
const { generateRefreshToken } = require("../config/refreshToken");
const jwt = require("jsonwebtoken");

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
const loginUser = asyncHandler(async (req, res) => {
    // İstek gövdesinden email ve password (şifre) alınır.
    const {email, password} = req.body;

    // Kullanıcının var olup olmadığını kontrol eder.
    const findUser = await User.findOne({email: email});

    // Eğer kullanıcı mevcutsa ve girilen şifre ile kaydedilen şifre eşleşiyorsa:
    if (findUser && (await findUser.isPasswordMatched(password))) {
        // Yeni bir refresh token oluşturur.
        const refreshToken = await generateRefreshToken(findUser?._id);

        // Refresh token'ı kullanıcı veritabanı kaydında günceller.
        const updateUser = await User.findByIdAndUpdate(findUser.id, {
            refreshToken: refreshToken,
        }, 
        {new: true} // Güncellenmiş kullanıcıyı döner.
        );

        // Refresh token'ı kullanıcıya bir cookie olarak gönderir.
        res.cookie('refreshToken', refreshToken, {
            httpOnly: true, // Güvenlik amacıyla, bu cookie sadece HTTP isteği ile erişilebilir.
            maxAge: 72 * 60 * 60 * 1000 // Cookie'nin ömrünü 3 gün olarak ayarlar.
        });

        // Kullanıcıya giriş bilgilerini ve JWT token'ını döner.
        res.json({
            _id: findUser?._id,
            firstName: findUser?.firstName,
            lastName: findUser?.lastName,
            email: findUser?.email,
            mobile: findUser?.mobile,
            address: findUser?.address,
            token: generateToken(findUser?._id) // Kullanıcı kimliğini doğrulayan JWT token.
        });
    } else {
        // Eğer kullanıcı yoksa veya şifre eşleşmiyorsa hata fırlatır.
        throw new Error("Invalid Credentials");
    }
});


// Handle Refresh Token- Yeni bir JWT token almak için kullanılan fonksiyon
const handleRefreshToken = asyncHandler(async (req, res) => {
    // İstekten cookie'yi alır.
    const cookie = req.cookies;

    // Eğer refresh token cookie'de yoksa hata fırlatır.
    if (!cookie?.refreshToken) throw new Error("No Refresh Token in Cookies!");

    // Cookie'den refresh token'ı alır.
    const refreshToken = cookie.refreshToken;

    // Veritabanında bu refresh token'a sahip olan kullanıcıyı bulur.
    const user = await User.findOne({refreshToken});

    // Eğer kullanıcı yoksa veya refresh token eşleşmiyorsa hata fırlatır.
    if (!user) throw new Error("No Refresh Token in DB or Not Matched!");

    // Refresh token'ı doğrular.
    jwt.verify(refreshToken, process.env.JWT_SECRET, (err, decoded) => {
        // Eğer doğrulama başarısız olursa veya kullanıcı ID'leri eşleşmezse hata fırlatır.
        if (err || user.id !== decoded.id) {
            throw new Error("There is something wrong with refresh token");
        }

        // Eğer doğrulama başarılı olursa yeni bir access token oluşturur.
        const accessToken = generateToken(user?._id);

        // Yeni access token'ı JSON formatında döner.
        res.json({accessToken});
    });
});


// Logout
const logout = asyncHandler(async (req, res) => {
    // Cookie'yi istekten alır.
    const cookie = req.cookies;

    // Eğer refresh token cookie'de yoksa hata fırlatır.
    if (!cookie?.refreshToken) throw new Error("No Refresh Token in Cookies");

    // Cookie'den refresh token'ı alır.
    const refreshToken = cookie.refreshToken;

    // Veritabanında bu refresh token'a sahip olan kullanıcıyı bulur.
    const user = await User.findOne({ refreshToken });

    // Eğer kullanıcı yoksa, sadece refresh token cookie'sini temizler ve yanıt döner.
    if (!user) {
      res.clearCookie("refreshToken", {
        httpOnly: true,
        secure: true,
      });
      // 204: Sunucunun isteği başarıyla işlediğini ancak geri dönecek bir içerik olmadığını belirtir.
      return res.sendStatus(204); 
    }

    // Kullanıcının veritabanındaki refresh token'ını temizler.
    await User.findOneAndUpdate({refreshToken}, {
      refreshToken: "",
    });

    // Kullanıcının tarayıcısındaki refresh token cookie'sini temizler.
    res.clearCookie("refreshToken", {
      httpOnly: true,
      secure: true,
    });

    // 204: İçerik olmadığını belirten bir yanıt döner.
    res.sendStatus(204);
});


// Get All Users - Tüm kullanıcıları getirir ve JSON formatında döner
const getAllUsers = asyncHandler(async(req, res) => {
    try {
        const getUsers = await User.find(); // Veritabanından tüm kullanıcıları bulur
        res.json(getUsers); // Kullanıcıları JSON olarak döner
    } catch (error) {
        throw new Error(error); // Hata durumunda hata fırlatır
    }
});

// Update A User
const updateUser = asyncHandler(async(req, res) =>  {
    const { _id } = req.user; // Kullanıcının kimliğini alır
    validateMongoDbId(_id); // Kimliğin geçerli olup olmadığını kontrol eder
    try {
        const updatedUser = await User.findByIdAndUpdate(_id, {
            // Bilgiler güncellenir
            firstName: req?.body.firstName,
            lastName: req?.body.lastName,
            email: req?.body.email,
            mobile: req?.body.mobile,
            address: req?.body.address,
            type: req?.body.type,
        }, {
            new: true, // Güncellenmiş belgeyi döner
        });
        res.json({updatedUser}); // Güncellenmiş kullanıcıyı JSON olarak döner
    } catch (error) {
        throw new Error(error);
    }
});

// Get A Single User - Belirtilen kullanıcıyı getirir
const getUser = asyncHandler(async(req, res) =>  {
    const { id } = req.params; // Parametrelerden kullanıcı kimliğini alır
    validateMongoDbId(id); // Kimliğin geçerli olup olmadığını kontrol eder
    try {
        const getTheUser = await User.findById(id); // Belirtilen kullanıcıyı bulur
        res.json({getTheUser});
    } catch (error) {
        throw new Error(error);
    }
});

// Delete A User
const deleteUser = asyncHandler(async(req, res) =>  {
    const { id } = req.params; // Parametrelerden kullanıcı kimliğini alır
    validateMongoDbId(id); // Kimliğin geçerli olup olmadığını kontrol eder
    try {
        const deletedUser = await User.findByIdAndDelete(id); // Belirtilen kullanıcıyı siler
        res.json({deletedUser}); 
    } catch (error) {
        throw new Error(error);
    }
});

// Block A User - Belirtilen kullanıcıyı bloke eder
const blockUser = asyncHandler(async (req, res) => {
    const { id } = req.params;
    validateMongoDbId(id);
    try {
        const block = await User.findByIdAndUpdate(id, {
            isBlocked: true, // Kullanıcının bloke durumunu true yapar
        }, {
            new: true, // Güncellenmiş belgeyi döner
        });
        res.json({block});
    } catch (error) {
        throw new Error(error);
    }
});

// Unblock A User - Belirtilen kullanıcının blokajını kaldırır
const unblockUser = asyncHandler(async (req, res) => {
    const { id } = req.params;
    validateMongoDbId(id);
    try {
        const unblock = await User.findByIdAndUpdate(id, {
            isBlocked: false, // Kullanıcının bloke durumunu false yapar
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