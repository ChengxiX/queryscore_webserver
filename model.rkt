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
(define (user-club name)
  (query-maybe-value db "SELECT club FROM users WHERE name = ?" name))
(define (user-get name club)
  (if (eq? name "")
  (query-maybe-value db "SELECT name, club FROM users WHERE club LIKE %?%" club)
  (query-maybe-value db "SELECT name, club FROM users WHERE name = ? AND  club LIKE %?%" name club)))
(define (user-password name)
  (query-maybe-value db "SELECT password FROM users WHERE name = ?" name))
(define (user-insert! name club password)
  (query-exec db "INSERT INTO users VALUES (?, ?, ?)" name club password))
(define (user-rename! name newname)
  (query-exec db "UPDATE users SET name=? WHERE name=?" newname name))
(define (user-all) (query-list db "SELECT name, club FROM users"))
(define (user-repassword! name password)
  (query-exec db "UPDATE users SET password=? WHERE name=?" password name))
(define (user-delete! name)
  (query-exec db "DELETE FROM users WHERE name=?" name))
(define (user-reclub! name club)
  (query-exec db "UPDATE users SET club=? WHERE name=?" club name))



;(struct club (name score))
(define (club-score name)
  (query-maybe-value db "SELECT score FROM clubs WHERE name = ?" name))
(define (club-insert! name score)
  (query-exec db "INSERT INTO clubs VALUES (?, ?)" name score))
(define (club-all) (query-list db "SELECT * FROM clubs"))

(define (club-rename! name newname)
  (query-exec db "UPDATE clubs SET name=? WHERE name=?" newname name)
  (map (lambda (original) (query-exec db "UPDATE users SET club=? WHERE name=?" (string-replace original name newname) original)) (query-list db "SELECT DISTINCT club FROM users WHERE club LIKE %?%" name)))

;(struct log (id club comment result))
(define (log-*-byclub club)
  (if (eq? club "")
      (query-list db "SELECT * FROM logs")
      (query-list db "SELECT * FROM logs WHERE club = ?" club)))
(define (log-insert! club comment result)
  (query-exec db "INSERT INTO logs (club, comment, result) VALUES (?, ?, ?)" club comment result))

(provide (all-defined-out))
