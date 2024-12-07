package main

import (
	"log"
	"net/http"
	_ "net/http/pprof"

	"github.com/felixge/fgprof"
	isuports "github.com/isucon/isucon12-qualify/webapp/go"
)

func main() {
	http.DefaultServeMux.Handle("/debug/fgprof", fgprof.Handler())
	go func() {
		log.Fatal(http.ListenAndServe("localhost:6061", nil))
	}()

	isuports.Run()
}
