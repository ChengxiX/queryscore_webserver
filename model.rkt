#lang racket
(require db)


(define (init-db! home)
  (define db (sqlite3-connect #:database home #:mode 'create))
  (unless (table-exists? db "users")
    (query-exec db "CREATE TABLE users (name TEXT PRIMARY KEY, club TEXT, password BLOB)"))
  (unless (table-exists? db "clubs")
    (query-exec db "CREATE TABLE clubs (name TEXT PRIMARY KEY, score INTEGER)"))
  (unless (table-exists? db "records")
    (query-exec db "CREATE TABLE records (id INTEGER PRIMARY KEY AUTOINCREMENT, club TEXT, comment TEXT, result INTEGER)"))
  )

;(struct user (name club password)) ;password is hashed
(define (user-club _name)
  (query-value db "SELECT club FROM users WHERE name = ?" _name))
(define (user-password _name)
  (query-value db "SELECT password FROM users WHERE name = ?" _name))
(define (user-insert! _name _club _password)
  (query-exec db "INSERT INTO users VALUES (?, ?, ?)" _name _club _password))

;(struct club (name score))
(define (club-score _name)
  (query-value db "SELECT score FROM clubs WHERE name = ?" _name))
(define (club-insert! _name _score)
  (query-exec db "INSERT INTO clubs VALUES (?, ?)" _name _score))
;(struct record (id club comment result))
(define (record-*-byclub _club)
  (query-value db "SELECT * FROM records WHERE club = ?" _club))
(define (record-insert! _club _comment _result)
  (query-exec db "INSERT INTO records (club, comment, result) VALUES (?, ?, ?)" _club _comment _result))

