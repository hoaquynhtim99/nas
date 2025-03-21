package libs

/*
 * Các cấu hình cứng
 */
var AppVersion = "v1"
var AppScheme = "http"
var AppPort = "8081"
var AppDomain = "blanas.com"

var ClientAllowed = []string{"https://blanas.com"}

var SSLCertFile = "" // Full path nếu cái này có, không thì lấy trong thư mục ssl
var SSLKeyFile = ""  // Full patn nếu cái này có, không thì lấy trong thư mục ssl

var ApiSecretKey = "........................"

// Cấu hình CSDL
var DbUser = "root"
var DbPass = ""
var DbHost = "...."
var DbPort = "3306"
var DbName = "...."
var DbPrefix = "nv4"

var TblInform = DbPrefix + "_xxxx"

// Ngôn ngữ mặc định
var LangData string = "vi"
var LangAllowed = []string{"vi", "en"}

var Timezone = "Asia/Ho_Chi_Minh"
