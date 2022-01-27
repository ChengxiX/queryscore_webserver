#lang racket
(require web-server/servlet
         web-server/servlet-env)

(require web-server/formlets)
(require web-server/http/basic-auth)
(require web-server/http/id-cookie)

(require "model.rkt")
(require "formlets.rkt")


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
    (let ((id (request-id-cookie request #:name "identity" #:key secret-salt #:shelf-life 86400)))
      (if id
          (response/xexpr `(html (head (meta ((http-equiv "refresh") (content ,(string-append "0;url=" (embed/url (if (eq? (user-club id) "admin") admin query)))))))))
          (match (request->basic-credentials request)
            [(cons user pass) #:when (pwhash-verify #f (string->bytes/utf-8 pass) (user-password user)) (response/xexpr `(html (head (meta ((http-equiv "refresh") (content ,(string-append "0;url=" (embed/url (if (eq? (user-club user) "admin") admin query))))))))
                                                                                                                        #:cookies (make-id-cookie "identity" user #:key secret-salt #:max-age -1))]
            [else (response/xexpr (base "验证失败" `(body (h1 "验证失败") (p "请输入正确的用户名密码") (a ((href ,(embed/url login))) "重试") (a ((href ,(embed/url homepage))) "首页"))))])
          )))
  (send/suspend/dispatch render-login))

(define (admin request)
  (define (after-auth request next) (if (eq? (user-club (request-id-cookie request #:name "identity" #:key secret-salt #:shelf-life 86400)) "admin") (next)
            (response/xexpr (base "无权限" `(body (h1 "无权限") (p "您不是管理员") (a ((href ,(embed/url login))) "登录") (a ((href ,(embed/url homepage))) "首页"))))))
  (define (render-admin embed/url)
    (after-auth request (lambda ()
        (response/xexpr (base "管理面板" `(body (h1 "管理面板")
                                            (h2 "用户")
                                            (form ([action ,(embed/url lambda-get-user)])
                                                  ,@(formlet-display get-user))
                                            (form ([action ,(embed/url lambda-add-user)])
                                                  ,@(formlet-display add-user))
                                            (form ([action ,(embed/url lambda-update-user)])
                                                  ,@(formlet-display update-user))
                                            (form ([action ,(embed/url lambda-delete-user)])
                                                  ,@(formlet-display delete-user))
                                            (h2 "社团")
                                            (form ([action ,(embed/url lambda-get-club)])
                                                  ,@(formlet-display get-club))
                                            (form ([action ,(embed/url lambda-add-club)])
                                                  ,@(formlet-display add-club))
                                            (form ([action ,(embed/url lambda-update-club)])
                                                  ,@(formlet-display update-club))
                                            (h2 "积分")
                                            (form ([action ,(embed/url lambda-add-log)])
                                                  ,@(formlet-display add-log))
                                            (form ([action ,(embed/url lambda-get-logs)])
                                                  ,@(formlet-display get-logs))
                                            ))))))
  (define (lambda-get-user request)
    (after-auth request (lambda ()
                  (define-values (name club) (formlet-process get-user request))
                  (response/xexpr (base "查询用户结果" `(body (h1 "查询用户结果")
                                                        ,(user-get name club)))))))
  (define (lambda-get-club request)
    (after-auth request (lambda () (response/xexpr (base "所有社团" `(body (h1 "所有社团")
                                                               ,(club-all)))))))
  (define (lambda-get-logs request)
    (after-auth request (lambda () (
                            (define-values (club) (formlet-process get-logs request))
                            (response/xexpr (base "查询积分记录结果" `(body (h1 "查询积分记录结果")
                                                                  ,(user-get club))))))))
  (define (lambda-add-user request)
    (after-auth request (lambda ()(
                                   (define-values (name password club) (formlet-process add-user))
                                   ()
                                   ))))
  (send/suspend/dispatch render-admin))

(define (query) '())

(define (start request)
  '())

;run
(serve/servlet start)
