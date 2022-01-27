#lang racket
(require web-server/servlet
         web-server/servlet-env)

(require web-server/formlets)
(require web-server/http/basic-auth)
(require web-server/http/id-cookie)

(require "model.rkt")

(require crypto)
(require crypto/all)
(use-all-factories!)


(define (base title body)
  `(html (head (meta (charset "UTF-8"))
               (title ,(string-append title " - RDFZ社联查分系统")))
         ,body))

(define (homepage request)
  (define (render-homepage embed/url)
    (response/xexpr (base "首页" `(body (h1 "首页") (p "欢迎使用RDFZ社联查分系统") (a ((href ,(embed/url login))) "登录以查分")))))
  (send/suspend/dispatch render-homepage))

(define secret-salt (make-secret-salt/file (build-path PATH "secret-salt.bin")))

(define (login request)
  (define (render-login embed/url)
    (let ((id (request-id-cookie request #:name "identity" #:key secret-salt)))
      (if id
          (response/xexpr `(html (head (meta ((http-equiv "refresh") (content ,(string-append "0;url=" (embed/url (if (eq? (user-club id) "admin") admin query)))))))))
          (match (request->basic-credentials request)
            [(cons user pass) #:when (pwhash-verify #f (string->bytes/utf-8 pass) (user-password user)) (response/xexpr `(html (head (meta ((http-equiv "refresh") (content ,(string-append "0;url=" (embed/url (if (eq? (user-club user) "admin") admin query))))))))
                                                                                                                        #:cookies (make-id-cookie "identity" user #:key secret-salt #:max-age -1))]
            [else (response/xexpr (base "请输入正确的用户名密码" `(body (h1 "请输入正确的用户名密码") (a ((href ,(embed/url login))) "重试") (a ((href ,(embed/url homepage))) "首页"))))])
          )))
  (send/suspend/dispatch render-login))

(define (admin request)
  (define (render-admin embed/url)
    (if (eq? (user-club (request-id-cookie request #:name "identity" #:key secret-salt)) "admin")
        (response/xexpr (base "管理面板" ))
        (response/xexpr (base "您不是管理员" `(body (h1 "您不是管理员") (a ((href ,(embed/url login))) "登录") (a ((href ,(embed/url homepage))) "首页"))))
        )
    )
  (send/suspend/dispatch render-admin)
  )

(define (start request)
  '())

;run
(serve/servlet start)
