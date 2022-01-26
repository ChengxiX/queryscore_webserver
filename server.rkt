#lang racket
(require web-server/servlet)
(require web-server/formlets)
(require "model.rkt")

(define PATH (current-directory-for-user)) ;can be set manually
(init-db! (build-path (current-directory) "database.sqlite"))
