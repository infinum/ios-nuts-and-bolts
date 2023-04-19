/*************************************************************************
 *
 * Copyright 2016 Realm Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 **************************************************************************/

#ifndef REALM_UTIL_LOGGER_HPP
#define REALM_UTIL_LOGGER_HPP

#include <realm/util/features.h>
#include <realm/util/thread.hpp>
#include <realm/util/file.hpp>

#include <cstring>
#include <ostream>
#include <string>
#include <utility>

namespace realm::util {

/// All Logger objects store a reference to a LevelThreshold object which it
/// uses to efficiently query about the current log level threshold
/// (`level_threshold.get()`). All messages logged with a level that is lower
/// than the current threshold will be dropped. For the sake of efficiency, this
/// test happens before the message is formatted.
///
/// A logger is not inherently thread-safe, but specific implementations can be
/// (see ThreadSafeLogger). For a logger to be thread-safe, the implementation
/// of do_log() must be thread-safe and the referenced LevelThreshold object
/// must have a thread-safe get() method.
///
/// Examples:
///
///    logger.error("Overlong message from master coordinator");
///    logger.info("Listening for peers on %1:%2", listen_address, listen_port);
class Logger {
public:
    template <class... Params>
    void trace(const char* message, Params&&...);
    template <class... Params>
    void debug(const char* message, Params&&...);
    template <class... Params>
    void detail(const char* message, Params&&...);
    template <class... Params>
    void info(const char* message, Params&&...);
    template <class... Params>
    void warn(const char* message, Params&&...);
    template <class... Params>
    void error(const char* message, Params&&...);
    template <class... Params>
    void fatal(const char* message, Params&&...);

    /// Specifies criticality when passed to log(). Functions as a criticality
    /// threshold when returned from LevelThreshold::get().
    ///
    ///     error   Be silent unless when there is an error.
    ///     warn    Be silent unless when there is an error or a warning.
    ///     info    Reveal information about what is going on, but in a
    ///             minimalistic fashion to avoid general overhead from logging
    ///             and to keep volume down.
    ///     detail  Same as 'info', but prioritize completeness over minimalism.
    ///     debug   Reveal information that can aid debugging, no longer paying
    ///             attention to efficiency.
    ///     trace   A version of 'debug' that allows for very high volume
    ///             output.
    // equivalent to realm_log_level_e in realm.h and must be kept in sync
    enum class Level { all = 0, trace = 1, debug = 2, detail = 3, info = 4, warn = 5, error = 6, fatal = 7, off = 8 };

    template <class... Params>
    void log(Level, const char* message, Params&&...);

    /// Shorthand for `int(level) >= int(level_threshold.get())`.
    bool would_log(Level level) const noexcept;

    class LevelThreshold;

    const LevelThreshold& level_threshold;

    virtual ~Logger() noexcept;

protected:
    Logger(const LevelThreshold&) noexcept;

    static void do_log(Logger&, Level, const std::string& message);

    virtual void do_log(Level, const std::string& message) = 0;

    static const char* get_level_prefix(Level) noexcept;

private:
    template <class... Params>
    REALM_NOINLINE void do_log(Level, const char* message, Params&&...);
};

template <class C, class T>
std::basic_ostream<C, T>& operator<<(std::basic_ostream<C, T>&, Logger::Level);

template <class C, class T>
std::basic_istream<C, T>& operator>>(std::basic_istream<C, T>&, Logger::Level&);

class Logger::LevelThreshold {
public:
    virtual Level get() const noexcept = 0;
};


/// A root logger that is not thread-safe and allows for the log level threshold
/// to be changed over time. The initial log level threshold is
/// Logger::Level::info.
class RootLogger : private Logger::LevelThreshold, public Logger {
public:
    void set_level_threshold(Level) noexcept;

protected:
    RootLogger();

private:
    Level m_level_threshold = Level::info;
    Level get() const noexcept override final;
};


/// A logger that writes to STDERR. This logger is not thread-safe.
///
/// Since this class is a RootLogger, it contains modifiable a log level
/// threshold.
class StderrLogger : public RootLogger {
protected:
    void do_log(Level, const std::string&) override final;
};


/// A logger that writes to a stream. This logger is not thread-safe.
///
/// Since this class is a RootLogger, it contains modifiable a log level
/// threshold.
class StreamLogger : public RootLogger {
public:
    explicit StreamLogger(std::ostream&) noexcept;

protected:
    void do_log(Level, const std::string&) override final;

private:
    std::ostream& m_out;
};


/// A logger that writes to a file. This logger is not thread-safe.
///
/// Since this class is a RootLogger, it contains modifiable a log level
/// threshold.
class FileLogger : public StreamLogger {
public:
    explicit FileLogger(std::string path);
    explicit FileLogger(util::File);

private:
    util::File m_file;
    util::File::Streambuf m_streambuf;
    std::ostream m_out;
};

class AppendToFileLogger : public StreamLogger {
public:
    explicit AppendToFileLogger(std::string path);
    explicit AppendToFileLogger(util::File);

private:
    util::File m_file;
    util::File::Streambuf m_streambuf;
    std::ostream m_out;
};


/// A thread-safe logger. This logger ignores the level threshold of the base
/// logger. Instead, it introduces new a LevelThreshold object with a fixed
/// value to achieve thread safety.
class ThreadSafeLogger : private Logger::LevelThreshold, public Logger {
public:
    explicit ThreadSafeLogger(Logger& base_logger, Level = Level::info);

protected:
    void do_log(Level, const std::string&) override final;

private:
    const Level m_level_threshold; // Immutable for thread safety
    Logger& m_base_logger;
    Mutex m_mutex;
    Level get() const noexcept override final;
};


/// A logger that adds a fixed prefix to each message. This logger inherits the
/// LevelThreshold object of the specified base logger. This logger is
/// thread-safe if, and only if the base logger is thread-safe.
class PrefixLogger : public Logger {
public:
    PrefixLogger(std::string prefix, Logger& base_logger) noexcept;

protected:
    void do_log(Level, const std::string&) override final;

private:
    const std::string m_prefix;
    Logger& m_base_logger;
};

// Implementation

template <class... Params>
inline void Logger::trace(const char* message, Params&&... params)
{
    log(Level::trace, message, std::forward<Params>(params)...); // Throws
}

template <class... Params>
inline void Logger::debug(const char* message, Params&&... params)
{
    log(Level::debug, message, std::forward<Params>(params)...); // Throws
}

template <class... Params>
inline void Logger::detail(const char* message, Params&&... params)
{
    log(Level::detail, message, std::forward<Params>(params)...); // Throws
}

template <class... Params>
inline void Logger::info(const char* message, Params&&... params)
{
    log(Level::info, message, std::forward<Params>(params)...); // Throws
}

template <class... Params>
inline void Logger::warn(const char* message, Params&&... params)
{
    log(Level::warn, message, std::forward<Params>(params)...); // Throws
}

template <class... Params>
inline void Logger::error(const char* message, Params&&... params)
{
    log(Level::error, message, std::forward<Params>(params)...); // Throws
}

template <class... Params>
inline void Logger::fatal(const char* message, Params&&... params)
{
    log(Level::fatal, message, std::forward<Params>(params)...); // Throws
}

template <class... Params>
inline void Logger::log(Level level, const char* message, Params&&... params)
{
    if (would_log(level))
        do_log(level, message, std::forward<Params>(params)...); // Throws
#if REALM_DEBUG
    else {
        // Do the string formatting even if it won't be logged to hopefully
        // catch invalid format strings
        static_cast<void>(format(message, std::forward<Params>(params)...)); // Throws
    }
#endif
}

inline bool Logger::would_log(Level level) const noexcept
{
    return int(level) >= int(level_threshold.get());
}

inline Logger::~Logger() noexcept {}

inline Logger::Logger(const LevelThreshold& lt) noexcept
    : level_threshold(lt)
{
}

inline void Logger::do_log(Logger& logger, Level level, const std::string& message)
{
    logger.do_log(level, std::move(message)); // Throws
}

template <class... Params>
void Logger::do_log(Level level, const char* message, Params&&... params)
{
    do_log(level, format(message, std::forward<Params>(params)...)); // Throws
}

template <class C, class T>
std::basic_ostream<C, T>& operator<<(std::basic_ostream<C, T>& out, Logger::Level level)
{
    switch (level) {
        case Logger::Level::all:
            out << "all";
            return out;
        case Logger::Level::trace:
            out << "trace";
            return out;
        case Logger::Level::debug:
            out << "debug";
            return out;
        case Logger::Level::detail:
            out << "detail";
            return out;
        case Logger::Level::info:
            out << "info";
            return out;
        case Logger::Level::warn:
            out << "warn";
            return out;
        case Logger::Level::error:
            out << "error";
            return out;
        case Logger::Level::fatal:
            out << "fatal";
            return out;
        case Logger::Level::off:
            out << "off";
            return out;
    }
    REALM_ASSERT(false);
    return out;
}

template <class C, class T>
std::basic_istream<C, T>& operator>>(std::basic_istream<C, T>& in, Logger::Level& level)
{
    std::basic_string<C, T> str;
    auto check = [&](const char* name) {
        size_t n = strlen(name);
        if (n != str.size())
            return false;
        for (size_t i = 0; i < n; ++i) {
            if (in.widen(name[i]) != str[i])
                return false;
        }
        return true;
    };
    if (in >> str) {
        if (check("all")) {
            level = Logger::Level::all;
        }
        else if (check("trace")) {
            level = Logger::Level::trace;
        }
        else if (check("debug")) {
            level = Logger::Level::debug;
        }
        else if (check("detail")) {
            level = Logger::Level::detail;
        }
        else if (check("info")) {
            level = Logger::Level::info;
        }
        else if (check("warn")) {
            level = Logger::Level::warn;
        }
        else if (check("error")) {
            level = Logger::Level::error;
        }
        else if (check("fatal")) {
            level = Logger::Level::fatal;
        }
        else if (check("off")) {
            level = Logger::Level::off;
        }
        else {
            in.setstate(std::ios_base::failbit);
        }
    }
    return in;
}

inline void RootLogger::set_level_threshold(Level new_level_threshold) noexcept
{
    m_level_threshold = new_level_threshold;
}

inline RootLogger::RootLogger()
    : Logger::LevelThreshold()
    , Logger(static_cast<Logger::LevelThreshold&>(*this))
{
}

inline Logger::Level RootLogger::get() const noexcept
{
    return m_level_threshold;
}

inline StreamLogger::StreamLogger(std::ostream& out) noexcept
    : m_out(out)
{
}

inline FileLogger::FileLogger(std::string path)
    : StreamLogger(m_out)
    , m_file(path, util::File::mode_Write) // Throws
    , m_streambuf(&m_file)                 // Throws
    , m_out(&m_streambuf)                  // Throws
{
}

inline FileLogger::FileLogger(util::File file)
    : StreamLogger(m_out)
    , m_file(std::move(file))
    , m_streambuf(&m_file) // Throws
    , m_out(&m_streambuf)  // Throws
{
}

inline AppendToFileLogger::AppendToFileLogger(std::string path)
    : StreamLogger(m_out)
    , m_file(path, util::File::mode_Append) // Throws
    , m_streambuf(&m_file)                  // Throws
    , m_out(&m_streambuf)                   // Throws
{
}

inline AppendToFileLogger::AppendToFileLogger(util::File file)
    : StreamLogger(m_out)
    , m_file(std::move(file))
    , m_streambuf(&m_file) // Throws
    , m_out(&m_streambuf)  // Throws
{
}

inline ThreadSafeLogger::ThreadSafeLogger(Logger& base_logger, Level threshold)
    : Logger::LevelThreshold()
    , Logger(static_cast<Logger::LevelThreshold&>(*this))
    , m_level_threshold(threshold)
    , m_base_logger(base_logger)
{
}

inline Logger::Level ThreadSafeLogger::get() const noexcept
{
    return m_level_threshold;
}

inline PrefixLogger::PrefixLogger(std::string prefix, Logger& base_logger) noexcept
    : Logger(base_logger.level_threshold)
    , m_prefix(std::move(prefix))
    , m_base_logger(base_logger)
{
}

} // namespace realm::util

#endif // REALM_UTIL_LOGGER_HPP
