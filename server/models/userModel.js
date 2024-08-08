const mongoose = require('mongoose'); // Erase if already required
const bcrypt = require('bcrypt');

// Declare the Schema of the Mongo model
var userSchema = new mongoose.Schema({
    firstName:{
        type:String,
        required:true,
        trim:true,
    },
    lastName:{
        type:String,
        required:true,
        trim:true,
    },
    email:{
        type:String,
        required:true,
        trim:true,
        unique:true,
    },
    mobile:{
        type:String,
        required:true,
        unique:true,
    },
    password:{
        type:String,
        required:true,
    },
    type: {
        type: String,
        default: 'user',
    },
    isBlocked: {
        type: Boolean,
        default: false,
    },
    cart: {
        type: Array,
        default: [],
    },
    address: [{type: mongoose.Schema.Types.ObjectId, ref: "Address"}],
    wishlist: [{type: mongoose.Schema.Types.ObjectId, ref: "Product"}],
    refreshToken: {
        type: String,
    },
}, {
    timestamps: true,
});

// Şifreyi hash'lemek için 'pre' hook kullanımı
// Bu kod, kullanıcının şifresi kaydedilmeden önce hash'lenmesini sağlar.
userSchema.pre("save", async function (next) {
    // 'pre' hook, Mongoose tarafından sağlanır ve bir belge kaydedilmeden önce belirli bir işlevi çalıştırır.
    // Hook'lar, belirli olaylar meydana geldiğinde çalıştırılan işlevlerdir. 
    // Mongoose'da pre ve post hook'ları kullanarak, belirli bir modelin belirli olayları öncesinde veya sonrasında özel işlevler çalıştırabilirsiniz. 
    // Örneğin, pre('save') hook'u, bir belge kaydedilmeden önce çalıştırılır.

    try {
        // bcrypt.genSalt(12) -> Şifreleme için bir salt (tuz) oluşturur. 12, saltRounds değeridir ve hash işleminin zorluk seviyesini belirtir.
        const saltRounds = 12;
        const salt = await bcrypt.genSalt(saltRounds);
        
        // bcrypt.hash(this.password, salt) -> Şifreyi oluşturulan salt ile hash'ler ve şifrelenmiş sonucu this.password'e atar.
        this.password = await bcrypt.hash(this.password, salt);
        
        // Bir sonraki middleware'e geçişi sağlar.
        next();
    } catch (error) {
        // Hata durumunda, bir sonraki middleware'e hatayı iletir.
        next(error);
    }
});


// Şifre karşılaştırma yöntemi
// Bu kod, girilen şifrenin hash'lenmiş şifreyle eşleşip eşleşmediğini kontrol eder.
userSchema.methods.isPasswordMatched = async function (enteredPassword) {
    // bcrypt.compare(enteredPassword, this.password) -> Girilen şifreyi hash'lenmiş şifreyle karşılaştırır ve eşleşirse true, eşleşmezse false döner.
    return await bcrypt.compare(enteredPassword, this.password);
};

//Export the model
module.exports = mongoose.model('User', userSchema);