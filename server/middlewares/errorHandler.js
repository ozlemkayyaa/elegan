// Bu fonksiyon, 404 hatalarını işleyen bir ara katmandır.
const notFound = (req, res, next) => {
    // Açıklayıcı bir mesajla yeni bir Hata nesnesi oluştur. Mesaj, isteğin orijinal URL'sini içerir.
    const error = new Error(`Not Found - ${req.originalUrl}`);

    // Yanıtın durum kodunu 404 olarak ayarla. Bu, istenen kaynağın bulunamadığını belirtir.
    res.status(404);

    // Hata nesnesi ile sonraki fonksiyonu çağır.
    next(error);
};


// Bu fonksiyon, sunucumuz için bir hata işleyici ara katmanı olarak kullanılır.
const errorHandler = (err, req, res, next) => {
    // Yanıtın durum kodunu kontrol et
    const statusCode = res.statusCode == 200 ? 500 : res.statusCode;

    // Yanıtın durum kodunu belirlenen değere ayarla
    res.status(statusCode);

    // İki özelliği olan bir JSON yanıtı oluştur
    res.json({
        message: err?.message,
        // stack: hatanın program yürütme sırasında nerede meydana geldiğini ve hangi fonksiyon çağrılarının bu hataya yol açtığını gösterir. 
        stack: err?.stack,
    });

    // Belirlenen durum kodu ile bir sonraki ara katmanı çağır
    next(statusCode);
};

module.exports = {errorHandler, notFound};