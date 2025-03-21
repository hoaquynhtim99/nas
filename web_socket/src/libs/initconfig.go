package libs

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"
)

var AppMode = "debug"

var BaseLogPath string
var CurrentTime int
var CurrentTimeStr string
var RootDir string
var LogFile string

// Config không đổi cho server
func InitConfig() {
	ex, err := os.Executable()
	if err != nil {
		log.Fatalln(err)
	}
	exPath := filepath.Dir(ex)
	RootDir = strings.Replace(exPath, "\\", "/", -1)
	BaseLogPath = RootDir + "/logs"
	RefreshConfig()
}

// Làm mới các giá trị dựa trên mỗi lần request
func RefreshConfig() {
	CurrentTime = int(time.Now().Unix())
	CurrentTimeStr = fmt.Sprint(CurrentTime)
	LogFile = time.Now().Format("2006-01-02") + ".log"
}
