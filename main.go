package main

import (
	"log"
	"net/http"
	"os"

	"gopkg.in/natefinch/lumberjack.v2"
)

func foo(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("OK\n"))
}

func main() {
	// Configure Logging
	logFileLocation := os.Getenv("LOG_FILE_LOCATION")
	if logFileLocation != "" {
		log.SetOutput(&lumberjack.Logger{
			Filename:   logFileLocation,
			MaxSize:    500, // megabytes
			MaxBackups: 3,
			MaxAge:     28,   //days
			Compress:   true, // disabled by default
		})
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/", foo)

	log.Println("running server in http://localhost:1919")
	log.Println(http.ListenAndServe(":1919", mux))
}
