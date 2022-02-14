#lang racket
(require web-server/formlets)

(define get-user (formlet
                  (div
                   (h5 "查询用户")
                   (div ((class "form-group")) (label "用户名：") ,{input-string . => . name})
                   (div ((class "form-group")) (label "社团：") ,{input-string . => . club})
                   (button ([type "submit"] [class "btn btn-primary"]) "查询")
                   )
                  (values name club)))

(define add-user (formlet
                  (div
                   (h5 "添加用户")
                   (div ((class "form-group")) (label "用户名：") ,{input-string . => . name})
                   (div ((class "form-group")) (label "密码：") ,{input-string . => . password})
                   (div ((class "form-group")) (label "社团")  ,{(to-string (required (text-input #:attributes '((placeholder "用,分开多个社团，示例club1,club2，注意请使用半角逗号，admin为管理组"))))) . => . club})
                   (button ([type "submit"] [class "btn btn-primary"]) "提交")
                   )
                  (values name password club)))
(define update-user (formlet
                     (div
                      (h5 "更新用户")
                      (div ((class "form-group")) (label "原用户名：") ,{input-string . => . name})
                      (div ((class "form-group")) (label "新用户名：") ,{input-string . => . newname})
                      (div ((class "form-group")) (label "新密码：") ,{input-string . => . password})
                      (button ([type "submit"] [class "btn btn-primary"]) "提交")
                      )
                     (values name newname password)))
(define update-user-add-club (formlet
                              (div
                               (h5 "用户添加到社团")
                               (div ((class "form-group")) (label "用户名：") ,{input-string . => . user})
                               (div ((class "form-group")) (label "社团") ,{input-string . => . club})
                               (button ([type "submit"] [class "btn btn-primary"]) "提交")
                               )
                              (values user club)))
(define update-user-rm-club (formlet
                             (div
                              (h5 "用户移出社团")
                              (div ((class "form-group")) (label "用户名：") ,{input-string . => . user})
                              (div ((class "form-group")) (label "社团") ,{input-string . => . club})
                              (button ([type "submit"] [class "btn btn-primary"]) "提交")
                              )
                             (values user club)))
(define delete-user (formlet
                     (div
                      (h5 "删除用户")
                      (div ((class "form-group")) (label "用户名：") ,{input-string . => . name})
                      (button ([type "submit"] [class "btn btn-primary"]) "提交")
                      )
                     (values name)))

(define get-club (formlet
                  (div
                   (h5 "所有社团")
                   (button ([type "submit"] [class "btn btn-primary"]) "查询")
                   )(values)))

(define add-club (formlet
                  (div
                   (h5 "添加社团")
                   (div ((class "form-group")) (label "社团名：") ,{input-string . => . name})
                   (div ((class "form-group")) (label "分数：") ,{(to-number (to-string (default #"0" (text-input)))) . => . score})
                   (button ([type "submit"] [class "btn btn-primary"]) "提交")
                   )
                  (values name score)))
(define update-club (formlet
                     (div
                      (h5 "更改社团名")
                      (div ((class "form-group")) (label "原社团名：") ,{input-string  . => . name})
                      (div ((class "form-group")) (label "新社团名：") ,{input-string  . => . newname})
                      (button ([type "submit"] [class "btn btn-primary"]) "提交")
                      )
                     (values name newname)))
(define delete-club (formlet
                     (div
                      (h5 "删除社团")
                      (div ((class "form-group")) (label "社团名：") ,{input-string . => . name})
                      (button ([type "submit"] [class "btn btn-primary"]) "提交")
                      )
                     (values name)))

(define add-log (formlet
                 (div
                  (h5 "更改积分")
                  (div ((class "form-group")) (label "社团名：") ,{input-string  . => . name})
                  (div ((class "form-group")) (label "分数（更改为）：") ,{input-int . => . score})
                  (div ((class "form-group")) (label "备注：") ,{input-string . => . comment})
                  (button ([type "submit"] [class "btn btn-primary"]) "提交")
                  )
                 (values name score comment)))
(define add-log-change (formlet
                        (div
                         (h5 "更改积分")
                         (div ((class "form-group")) (label "社团名：") ,{input-string  . => . name})
                         (div ((class "form-group")) (label "分数（增量）：") ,{input-int . => . score-change})
                         (div ((class "form-group")) (label "备注：") ,{input-string . => . comment})
                         (button ([type "submit"] [class "btn btn-primary"]) "提交")
                         )
                        (values name score-change comment)))
(define get-logs (formlet
                  (div
                   (h5 "查询积分记录")
                   (div ((class "form-group")) (label "社团：") ,{input-string . => . club})
                   (button ([type "submit"] [class "btn btn-primary"]) "查询")
                   )
                  (values club)))
(define login-form (formlet (div ((class "container"))
                             (div ((class "form-group")) (label "用户名：") ,{input-string . => . username})
                             (div ((class "form-group")) (label "密码：") ,{(to-string (required (password-input))) . => . password})
                             (div ((class "form-check")) (label "自动登录" ,{(to-string (default #"f" (checkbox "t" #t))) . => . rem}))
                             (button ([type "submit"] [class "btn btn-primary"]) "登录"))
                            (values username password rem)))
(provide (all-defined-out))
