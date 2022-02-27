#lang racket
(require csv-reading)
(require db)

(define contentincsv (csv->list (open-input-file "in.CSV")))

(define db (mysql-connect #:user "remote" #:password "g5kXuPWp4Eoz"
;#:server "voiceme.club" #:port 8806
#:database "clubunion" #:ssl 'yes))

(define (club-insert! name score)
  (query-exec db "INSERT INTO clubs VALUES (?, ?)" name score))
;contentincsv
(map (lambda (a) (club-insert! (car (cdr a)) (string->number (car a)))) contentincsv)