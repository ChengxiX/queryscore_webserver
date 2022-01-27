#lang racket
(require web-server/formlets)

(define get-user (formlet
                    (div
                     "查询用户"
                     "用户名：" ,{(to-string (text-input)) . => . name}
                     "社团：" ,{(to-string (text-input)) . => . club}
                     {submit})
                    (values name club)))

(define add-user (formlet
                    (div
                     "添加用户"
                     "用户名：" ,{(to-string (required (text-input))) . => . name}
                     "密码：" ,{(to-string (required (text-input))) . => . password}
                     "社团（用/分开多个社团，示例club1/club2，只有/为空，admin为管理）：" ,{(to-string (text-input)) . => . club}
                     {submit})
                    (values name password club)))
(define update-user (formlet
                    (div
                     "更新用户"
                     "原用户名：" ,{(to-string (required (text-input))) . => . name}
                     "新用户名：" ,{(to-string (text-input)) . => . newname}
                     "新密码：" ,{(to-string (text-input)) . => . password}
                     "新社团（覆盖，用/分开多个社团，示例club1/club2，只有/为空，admin为管理）：" ,{(to-string (text-input)) . => . club}
                     {submit})
                    (values name newname password club)))
(define delete-user (formlet
                    (div
                     "删除用户"
                     "原用户名：" ,{(to-string (required (text-input))) . => . name}
                     {submit})
                    (values name)))

(define get-club (formlet
                    (div
                     "所有社团"
                     {submit})
                    (values)))

(define add-club (formlet
                    (div
                     "添加社团"
                     "社团名：" ,{(to-string (required (text-input))) . => . name}
                     "分数：" ,{(to-number (input #:type "number")) . => . score}
                     {submit})
                    (values name score)))
(define update-club (formlet
                    (div
                     "更新社团（安全）"
                     "原社团名：" ,{(to-string (required (text-input))) . => . name}
                     "新社团名：" ,{(to-string (text-input)) . => . newname}
                     {submit})
                    (values name newname)))

(define add-log (formlet
                    (div
                     "更改积分"
                     "社团名：" ,{(to-string (required (text-input))) . => . name}
                     "分数（更改为）：" ,{(to-number (input #:type "number")) . => . score}
                     "备注：" ,{(to-string (required (text-input))) . => . comment}
                     {submit})
                    (values name score comment)))

(define get-logs (formlet
                    (div
                     "查询积分记录"
                     "社团：" ,{(to-string (text-input)) . => . club}
                     {submit})
                    (values club)))
(provide (all-defined-out))
