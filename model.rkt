#lang racket
(require db)

(define PATH (current-directory-for-user)) ;can be set manually

(define (init-db! home)
  (define db (sqlite3-connect #:database home #:mode 'create))
  (unless (table-exists? db "users")
    (query-exec db "CREATE TABLE users (name TEXT PRIMARY KEY, club TEXT, password BLOB)"))
  (unless (table-exists? db "clubs")
    (query-exec db "CREATE TABLE clubs (name TEXT PRIMARY KEY, score INTEGER)"))
  (unless (table-exists? db "logs")
    (query-exec db "CREATE TABLE logs (id INTEGER PRIMARY KEY AUTOINCREMENT, club TEXT, comment TEXT, result INTEGER, logtime TIMESTAMP default (datetime('now', '+8 hour')))"))
  db)
(define db (init-db! (build-path PATH "database.sqlite")))

;(struct user (name club password)) ;password is hashed
(define (user-club _name)
  (query-maybe-value db "SELECT club FROM users WHERE name = ?" _name))
(define (user-password _name)
  (query-maybe-value db "SELECT password FROM users WHERE name = ?" _name))
(define (user-insert! _name _club _password)
  (query-exec db "INSERT INTO users VALUES (?, ?, ?)" _name _club _password))
(define (user-rename! _name _newname)
  (query-exec db "UPDATE users SET name=? WHERE name=?" _newname _name))

;(struct club (name score))
(define (club-score _name)
  (query-maybe-value db "SELECT score FROM clubs WHERE name = ?" _name))
(define (club-insert! _name _score)
  (query-exec db "INSERT INTO clubs VALUES (?, ?)" _name _score))
(define (club-all) (query-list db "SELECT * FROM clubs"))

(define (club-rename! _name _newname)
  (query-exec db "UPDATE users SET club=? WHERE club=?" _newname _name)
  (query-exec db "UPDATE clubs SET name=? WHERE name=?" _newname _name))

;(struct log (id club comment result))
(define (log-*-byclub _club)
  (query-list db "SELECT * FROM logs WHERE club = ?" _club))
(define (log-insert! _club _comment _result)
  (query-exec db "INSERT INTO logs (club, comment, result) VALUES (?, ?, ?)" _club _comment _result))
(define (log-all) (query-list db "SELECT * FROM logs"))

(provide (all-defined-out))
