#lang racket
(...)
(when (equal? (club-user "admin") null)
(user-insert! "minister" '("admin") (pwhash 'scrypt (string->bytes/utf-8 "580193443") `((ln , (inexact->exact (+ 1 (round (* (random) 10)))))))))