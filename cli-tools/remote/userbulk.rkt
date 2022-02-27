#lang racket
(require csv-reading)
(require db)

(require crypto)
(require crypto/all)
(use-all-factories!)

(define contentincsv (csv->list (open-input-file "clubunion账户.CSV")))

(define db (mysql-connect #:user "remote" #:password "g5kXuPWp4Eoz"
#:server "voiceme.club" #:port 8806
#:database "clubunion" #:ssl 'yes))
(define (user-insert! name clubs password);get a list of clubs
  (query-exec db "INSERT INTO users VALUES (?, ?)" name password)
  (map (lambda (c) (query-exec db "INSERT INTO user2club VALUES (?, ?)" name c)) clubs))
;contentincsv
(map (lambda (a) (user-insert! (second a) (list (car a)) (pwhash 'scrypt (string->bytes/utf-8 (third a)) `((ln , (inexact->exact (+ 1 (round (* (random) 10))))))))) contentincsv)