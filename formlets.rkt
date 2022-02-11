#lang racket
(require web-server/formlets)

(define get-user (formlet
                    (div
                     "查询用户/"
                     "用户名：" ,{input-string . => . name}
                     "社团：" ,{input-string . => . club}
                     )
                    (values name club)))

(define add-user (formlet
                    (div
                     "添加用户/"
                     "用户名：" ,{input-string . => . name}
                     "密码：" ,{input-string . => . password}
                     "社团（用,分开多个社团，示例club1,club2，注意请使用半角逗号，admin为管理组）：" ,{input-string . => . club}
                     )
                    (values name password club)))
(define update-user (formlet
                    (div
                     "更新用户/"
                     "原用户名：" ,{input-string . => . name}
                     "新用户名：" ,{input-string . => . newname}
                     "新密码：" ,{input-string . => . password}
                     )
                    (values name newname password)))
(define update-user-add-club (formlet
                    (div
                     "用户添加到社团/"
                     "用户名：" ,{input-string . => . user}
                     "社团" ,{input-string . => . club}
                     )
                    (values user club)))
(define update-user-rm-club (formlet
                    (div
                     "用户移出社团/"
                     "用户名：" ,{input-string . => . user}
                     "社团" ,{input-string . => . club}
                     )
                    (values user club)))
(define delete-user (formlet
                    (div
                     "删除用户/"
                     "用户名：" ,{input-string . => . name}
                     )
                    (values name)))

(define get-club (formlet
                    (div
                     "所有社团"
                     )
                    (values)))

(define add-club (formlet
                    (div
                     "添加社团/"
                     "社团名：" ,{input-string . => . name}
                     "分数：" ,{input-int . => . score}
                     )
                    (values name score)))
(define update-club (formlet
                    (div
                     "更新社团（安全）/"
                     "原社团名：" ,{input-string  . => . name}
                     "新社团名：" ,{input-string  . => . newname}
                     )
                    (values name newname)))

(define add-log (formlet
                    (div
                     "更改积分/"
                     "社团名：" ,{input-string  . => . name}
                     "分数（更改为）：" ,{input-int . => . score}
                     "备注：" ,{input-string . => . comment}
                     )
                    (values name score comment)))
(define add-log-change (formlet
                    (div
                     "更改积分/"
                     "社团名：" ,{input-string  . => . name}
                     "分数（增量）：" ,{input-int . => . score-change}
                     "备注：" ,{input-string . => . comment}
                     )
                    (values name score-change comment)))
(define get-logs (formlet
                    (div
                     "查询积分记录/"
                     "社团：" ,{input-string . => . club}
                     )
                    (values club)))
(define login-form (formlet (div
                             "用户名：" ,{input-string . => . username}
                             "密码：" ,{input-string . => . password})
                            (values username password)))
(provide (all-defined-out))
