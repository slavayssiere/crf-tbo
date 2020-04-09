package main

import "net/http"

func main() {
	s := http.NewServeMux()

	s.HandleFunc("/myroute", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("<h1>Another simple server</h1>"))
	})

	http.ListenAndServe(":8080", s)
}
