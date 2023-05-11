////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or utilied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#ifndef REALM_GENERIC_NETWORK_TRANSPORT_HPP
#define REALM_GENERIC_NETWORK_TRANSPORT_HPP

#include <realm/util/functional.hpp>
#include <realm/util/optional.hpp>

#include <iosfwd>
#include <map>
#include <memory>
#include <string>
#include <system_error>
#include <vector>

namespace realm::app {

enum class ClientErrorCode {
    user_not_found = 1,
    user_not_logged_in = 2,
    app_deallocated = 3,
    redirect_error = 4,
    too_many_redirects = 5
};

enum class JSONErrorCode { bad_token = 1, malformed_json = 2, missing_json_key = 3, bad_bson_parse = 4 };

enum class ServiceErrorCode {
    missing_auth_req = 1,
    /// Invalid session, expired, no associated user, or app domain mismatch
    invalid_session = 2,
    user_app_domain_mismatch = 3,
    domain_not_allowed = 4,
    read_size_limit_exceeded = 5,
    invalid_parameter = 6,
    missing_parameter = 7,
    twilio_error = 8,
    gcm_error = 9,
    http_error = 10,
    aws_error = 11,
    mongodb_error = 12,
    arguments_not_allowed = 13,
    function_execution_error = 14,
    no_matching_rule_found = 15,
    internal_server_error = 16,
    auth_provider_not_found = 17,
    auth_provider_already_exists = 18,
    service_not_found = 19,
    service_type_not_found = 20,
    service_already_exists = 21,
    service_command_not_found = 22,
    value_not_found = 23,
    value_already_exists = 24,
    value_duplicate_name = 25,
    function_not_found = 26,
    function_already_exists = 27,
    function_duplicate_name = 28,
    function_syntax_error = 29,
    function_invalid = 30,
    incoming_webhook_not_found = 31,
    incoming_webhook_already_exists = 32,
    incoming_webhook_duplicate_name = 33,
    rule_not_found = 34,
    api_key_not_found = 35,
    rule_already_exists = 36,
    rule_duplicate_name = 37,
    auth_provider_duplicate_name = 38,
    restricted_host = 39,
    api_key_already_exists = 40,
    incoming_webhook_auth_failed = 41,
    execution_time_limit_exceeded = 42,
    not_callable = 43,
    user_already_confirmed = 44,
    user_not_found = 45,
    user_disabled = 46,
    auth_error = 47,
    bad_request = 48,
    account_name_in_use = 49,
    invalid_email_password = 50,
    maintenance_in_progress = 51,

    unknown = -1,
    none = 0
};

const std::error_category& json_error_category() noexcept;
std::error_code make_error_code(JSONErrorCode) noexcept;

const std::error_category& custom_error_category() noexcept;
std::error_code make_custom_error_code(int code) noexcept;

ServiceErrorCode service_error_code_from_string(const std::string& code);
const std::error_category& service_error_category() noexcept;
std::error_code make_error_code(ServiceErrorCode) noexcept;

const std::error_category& http_error_category() noexcept;
std::error_code make_http_error_code(int http_code) noexcept;

const std::error_category& client_error_category() noexcept;
std::error_code make_client_error_code(ClientErrorCode) noexcept;

struct AppError {
    std::error_code error_code;
    util::Optional<int> http_status_code;

    std::string message;
    std::string link_to_server_logs;

    AppError(std::error_code error_code, std::string message, std::string link = "",
             util::Optional<int> http_error_code = util::none)
        : error_code(error_code)
        , http_status_code(http_error_code)
        , message(message)
        , link_to_server_logs(link)
    {
    }

    bool is_json_error() const
    {
        return error_code.category() == json_error_category();
    }

    bool is_service_error() const
    {
        return error_code.category() == service_error_category();
    }

    bool is_http_error() const
    {
        return error_code.category() == http_error_category();
    }

    bool is_custom_error() const
    {
        return error_code.category() == custom_error_category();
    }

    bool is_client_error() const
    {
        return error_code.category() == client_error_category();
    }
};

std::ostream& operator<<(std::ostream& os, AppError error);

/**
 * An HTTP method type.
 */
enum class HttpMethod { get, post, patch, put, del };

/**
 * Request/Response headers type
 */
using HttpHeaders = std::map<std::string, std::string>;

/**
 * An HTTP request that can be made to an arbitrary server.
 */
struct Request {
    /**
     * The HTTP method of this request.
     */
    HttpMethod method = HttpMethod::get;

    /**
     * The URL to which this request will be made.
     */
    std::string url;

    /**
     * The number of milliseconds that the underlying transport should spend on an HTTP round trip before failing with
     * an error.
     */
    uint64_t timeout_ms = 0;

    /**
     * The HTTP headers of this request - keys are case insensitive.
     */
    HttpHeaders headers;

    /**
     * The body of the request.
     */
    std::string body;

    /// Indicates if the request uses the refresh token or the access token
    bool uses_refresh_token = false;

    /**
     * A recursion counter to prevent too many redirects
     */
    int redirect_count = 0;
};

/**
 * The contents of an HTTP response.
 */
struct Response {
    /**
     * The status code of the HTTP response.
     */
    int http_status_code;

    /**
     * A custom status code provided by the language binding (SDK).
     */
    int custom_status_code;

    /**
     * The headers of the HTTP response - keys are case insensitive.
     */
    HttpHeaders headers;

    /**
     * The body of the HTTP response.
     */
    std::string body;

    /**
     * An error code used by the client to report http processing errors.
     */
    util::Optional<ClientErrorCode> client_error_code;
};

/// Generic network transport for foreign interfaces.
struct GenericNetworkTransport {
    virtual ~GenericNetworkTransport() = default;
    virtual void send_request_to_server(const Request& request,
                                        util::UniqueFunction<void(const Response&)>&& completion) = 0;

    void send_request_to_server(Request&& request,
                                util::UniqueFunction<void(Request&&, const Response&)>&& completion)
    {
        auto request_ptr = std::make_unique<Request>(std::move(request));
        const auto& request_ref = *request_ptr;
        send_request_to_server(request_ref, [request_ptr = std::move(request_ptr),
                                             completion = std::move(completion)](const Response& response) {
            completion(std::move(*request_ptr), response);
        });
    }
};

const char* httpmethod_to_string(HttpMethod method);

} // namespace realm::app

#endif /* REALM_GENERIC_NETWORK_TRANSPORT_HPP */
