const jwt = require('jsonwebtoken');

// Token oluşturmak için kullanılan fonksiyon
const generateToken = (id) => {
    // jwt.sign -> JWT oluşturur ve imzalar.
    // { id } -> Payload, yani token içerisinde saklanacak veri. Bu örnekte sadece kullanıcı id'si saklanıyor.
    // process.env.JWT_SECRET -> Gizli anahtar, JWT'nin imzalanmasında kullanılır. Bu değer çevre değişkenlerinden alınır.
    // { expiresIn: "3d" } -> Tokenın geçerlilik süresini belirler. Bu örnekte token 3 gün boyunca geçerli olacaktır. 
    // 7d -> 1 hafta, 30d -> 1 ay, 365d -> 1 yıl geçerli demek
    return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: "365d" });
};

module.exports = { generateToken };
