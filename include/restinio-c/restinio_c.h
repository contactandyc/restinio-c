// SPDX-FileCopyrightText: 2019–2026 Andy Curtis <contactandyc@gmail.com>
// SPDX-FileCopyrightText: 2024–2025 Knode.ai
// SPDX-License-Identifier: Apache-2.0
//
// Maintainer: Andy Curtis <contactandyc@gmail.com>

#ifndef _RESTINIO_C_H
#define _RESTINIO_C_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// --- Request types ---

// --- Response types ---
typedef struct restinio_header_s {
    char *key;
    char *value;
    struct restinio_header_s *next;
} restinio_header_t;

typedef struct restinio_response_s {
    int error_code;
    char *error_message;

    restinio_header_t *headers;

    char *response;
    size_t response_length;

    // Optional callback to free resources associated with this response
    void (*destroy)(struct restinio_response_s *self);
} restinio_response_t;

// --- Callback signatures ---
typedef restinio_response_t *(*restinio_handle_request_cb)(
    void *arg, const char *method, const char *uri, const char *body,
    size_t body_length);

typedef void (*restinio_handle_detached_request_cb)(
    void *arg, const char *method, const char *uri, const char *body,
    size_t body_length, void *response_handle);

// --- Options ---
typedef struct {
    bool enable_http2;       // Not fully utilized in wrapper yet, but good for future API
    bool enable_keepalive;
    bool enable_thread_pool;
    size_t thread_pool_size; // Only used if enable_thread_pool is true
    uint16_t port;
    const char *address;
} restinio_options_t;

// --- API ---
void restinio_use(const char *method, const char *path,
                  restinio_handle_request_cb cb, void *arg);

void restinio_use_detached(const char *method, const char *path,
                           restinio_handle_detached_request_cb cb, void *arg);

void restinio_init(restinio_options_t *options);
void restinio_run();
void restinio_destroy();

void restinio_finish_detached(void *response_handle, int status_code,
                              const char *response_body,
                              size_t response_body_length,
                              restinio_header_t *headers);

void restinio_finish_detached_error(void *response_handle, int status_code,
                                    const char *response);

void restinio_finish_detached_text(void *response_handle, const char *response);

void restinio_finish_detached_json(void *response_handle,
                                   const char *response_body,
                                   size_t response_body_length);

#ifdef __cplusplus
}
#endif

#endif
