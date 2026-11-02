---
name: graceful-shutdown-http-server
language: go
tags: [go, http, server, shutdown, graceful, signal]
use-case: HTTP server with graceful shutdown on SIGINT/SIGTERM
created: 2026-07-31
---

## Description

Starts an HTTP server and shuts down gracefully on SIGINT or SIGTERM:
drains active connections, respects a shutdown timeout, and exits cleanly.

## Usage

Replace `:8080` with desired address. Customize handler. Adjust shutdown
timeout (default 10 seconds).

## Code

```go
package main

import (
    "context"
    "errors"
    "log"
    "net/http"
    "os"
    "os/signal"
    "syscall"
    "time"
)

func main() {
    mux := http.NewServeMux()
    mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        w.Write([]byte("Hello"))
    })

    srv := &http.Server{Addr: ":8080", Handler: mux}

    go func() {
        log.Printf("listening on %s", srv.Addr)
        if err := srv.ListenAndServe(); !errors.Is(err, http.ErrServerClosed) {
            log.Fatalf("serve: %v", err)
        }
    }()

    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit

    ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
    defer cancel()
    if err := srv.Shutdown(ctx); err != nil {
        log.Fatalf("shutdown: %v", err)
    }
}
```

## Notes

- ErrServerClosed is expected, not a real error — handle with errors.Is.
- Increase 10s timeout for long-running request handlers.
- For multiple servers, use errgroup with context cancellation.
