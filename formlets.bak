#lang racket
(require web-server/formlets)

(define get-user (formlet
                    (div
                     "查询用户"
                     "用户名：" ,{(to-string text-input) . => . name}
                     "社团：" ,{(to-string text-input) . => . club}
                     {submit})
                    (values name club)))

(define add-user (formlet
                    (div
                     "添加用户"
                     "用户名：" ,{(to-string (required text-input)) . => . name}
                     "密码：" ,{(to-string (required text-input)) . => . password}
                     "社团（用/分开多个社团，示例club1/club2）：" ,{(to-string text-input) . => . club}
                     {submit})
                    (values name password club)))
(define update-user (formlet
                    (div
                     "更新用户"
                     "原用户名：" ,{(to-string (required text-input)) . => . name}
                     "新用户名：" ,{(to-string text-input) . => . newname}
                     "新密码：" ,{(to-string text-input) . => . password}
                     "新社团（覆盖，用/分开多个社团，示例club1/club2）：" ,{(to-string text-input) . => . club}
                     {submit})
                    (values name newname password club)))
(define delete-user (formlet
                    (div
                     "删除用户"
                     "原用户名：" ,{(to-string (required text-input)) . => . name}
                     {submit})
                    (values name)))

(define add-club (formlet
                    (div
                     "添加社团"
                     "社团名：" ,{(to-string (required text-input)) . => . name}
                     "分数：" ,{(to-number (input #:type "number")) . => . score}
                     {submit})
                    (values name score)))

(define add-log (formlet
                    (div
                     "更改分数"
                     "社团名：" ,{(to-string (required text-input)) . => . name}
                     "分数（更改到）：" ,{(to-number (input #:type "number")) . => . score}
                     "备注：" ,{(to-string (required text-input)) . => . comment}
                     {submit})
                    (values name score)))

(define get-logs (formlet
                    (div
                     "查询分数记录"
                     "社团：" ,{(to-string text-input) . => . club}
                     {submit})
                    (values name club)))
